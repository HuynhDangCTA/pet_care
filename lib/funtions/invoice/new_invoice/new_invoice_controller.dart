
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:pet_care/funtions/customer/customer_controller.dart';
import 'package:pet_care/funtions/home/home_controller.dart';
import 'package:pet_care/funtions/invoice/invoice_controller.dart';
import 'package:pet_care/model/customer.dart';
import 'package:pet_care/model/invoice.dart';
import 'package:pet_care/model/service.dart';
import 'package:pet_care/model/user_request.dart';
import 'package:pet_care/util/date_util.dart';
import 'package:pet_care/util/loading.dart';
import 'package:pet_care/util/number_util.dart';
import 'package:pet_care/widgets/app_button.dart';
import 'package:pet_care/widgets/app_text.dart';
import 'package:pet_care/widgets/text_form_field.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:volume_watcher/volume_watcher.dart';
import '../../../core/constants.dart';
import '../../../core/payment_methods_charactor.dart';
import '../../../model/product.dart';
import '../../../model/state.dart';
import '../../../network/firebase_helper.dart';
import '../../../routes/routes_const.dart';

class NewInvoiceController extends GetxController {
  List<Customer> customers = <Customer>[];
  RxList<Customer> customerFilter = <Customer>[].obs;
  Rx<AppState> state = Rx(StateSuccess());
  String? phone;
  Rx<Customer?> selectedCustomer = Rx(null);
  TextEditingController? phoneController;
  TextEditingController? nameController;
  RxList<Product> selectedProduct = <Product>[].obs; // lưu sản phẩm đã chọn
  RxList<ServiceModel> selectedServices =
      <ServiceModel>[].obs; // lưu dịch vụ đã chon
  RxList amountProduct = [].obs; // lưu số lượng sản phẩm đã chọn kiểu int
  RxList amountService = [].obs; // lưu giá dịch vụ đã tính tiền kiểu int
  RxList<String> optionsService =
      <String>[].obs; // lưu {giá: option} đẫ chọn kiểu Map
  RxString optionRadioService = ''.obs;
  List<Product> products = [];
  RxList<Product> productFilter = <Product>[].obs;
  List<ServiceModel> services = [];
  RxList<ServiceModel> servicesFilter = <ServiceModel>[].obs;
  RxList dateService = [].obs;
  TextEditingController productDiscountController = TextEditingController();
  TextEditingController serviceDiscountController = TextEditingController();
  RxString paymentMethods = ''.obs;
  TextEditingController paymentController = TextEditingController();
  var selectedDateStart = DateTime.now().obs;
  var selectedDateEnd = (DateTime.now().add(const Duration(days: 1))).obs;
  var selectedTime = TimeOfDay.now().obs;
  var day = 1.0;
  Invoice? invoice = Get.arguments;

  @override
  void onInit() async {
    super.onInit();
    state.value = StateLoading();
    await getAllCustomers();
    getAllProduct();
    getAllService();
    if (invoice != null) {
      serviceDiscountController.text = invoice!.discountService.toString();
      productDiscountController.text = invoice!.discountProduct.toString();
      paymentMethods.value = invoice!.paymentMethod;
      for (var customer in customers) {
        if (customer.id == invoice!.customerId) {
          selectedCustomer.value = customer;
          break;
        }
      }
      await getAllProductWithId(invoice!.id!);
      await getAllServiceWithId(invoice!.id!);
    }
  }

  Future getAllProductWithId(String id) async {
    await FirebaseHelper.getAllProductInInvoice(id).then((value) {
      if (value.docs.isNotEmpty) {
        for (int i = 0; i < value.docs.length; i++) {
          Product product = Product.fromDocument(
              value.docs[i].data() as Map<String, dynamic>);
          product.id = value.docs[i].id;
          selectedProduct.add(product);
          amountProduct.add(product.amount);
        }
      }
    });
  }

  Future getAllServiceWithId(String id) async {
    await FirebaseHelper.getAllServiceInInvoice(id).then((value) {
      if (value.docs.isNotEmpty) {
        for (int i = 0; i < value.docs.length; i++) {
          ServiceModel serviceModel = ServiceModel.fromDocument(
              value.docs[i].data() as Map<String, dynamic>);
          serviceModel.id = value.docs[i].id;
          selectedServices.add(serviceModel);
          int price = (serviceModel.options![serviceModel.selectedOption] *
                  serviceModel.days)
              .round();
          amountService.add(price);
          optionsService.add(serviceModel.selectedOption!);
          selectedDateStart.value = serviceModel.fromDate!;
          selectedDateEnd.value = serviceModel.toDate!;
        }
      }
    });
  }

  Future getAllCustomers() async {
    state.value = StateLoading();
    await FirebaseHelper.getAllCustomer().then((value) {
      if (value != null && value.docs.length > 0) {
        List<Customer> result = [];
        state.value = StateSuccess();
        for (var doc in value.docs) {
          Customer customer = Customer(
              id: doc.id,
              times: doc[Constants.times],
              name: doc[Constants.name],
              phone: doc[Constants.phone]);
          result.add(customer);
        }
        customers = result;
      }
    });
  }

  void searchCustomer(String? phone) {
    this.phone = phone;
    if (phone == null || phone.isEmpty) {
      customerFilter.clear();
      return;
    }
    customerFilter.clear();
    for (var customer in customers) {
      if (customer.phone.contains(phone)) {
        customerFilter.add(customer);
      }
    }
  }

  void searchProduct(String? name) {
    if (name == null || name.isEmpty) {
      productFilter.addAll(products);
      return;
    }
    productFilter.clear();
    for (var product in products) {
      if (product.name!
          .toLowerCase()
          .trim()
          .contains(name.toLowerCase().trim())) {
        productFilter.add(product);
      }
    }
  }

  void searchService(String? name) {
    servicesFilter.clear();
    if (name == null || name.isEmpty) {
      servicesFilter.addAll(services);
      return;
    }
    for (var service in services) {
      if (service.name!
          .toLowerCase()
          .trim()
          .contains(name.toLowerCase().trim())) {
        servicesFilter.add(service);
      }
    }
  }

  Future getAllProduct() async {
    await FirebaseHelper.getAllProducts().then((value) {
      if (value != null && value.docs.length > 0) {
        List<Product> result = [];
        state.value = StateSuccess();
        for (var doc in value.docs) {
          Product product = Product(
              id: doc.id,
              name: doc[Constants.name],
              image: doc[Constants.image],
              price: doc[Constants.price],
              amount: doc[Constants.amount]);
          result.add(product);
        }
        products = result;
      }
    });
    productFilter.addAll(products);
  }

  Future getAllService() async {
    await FirebaseHelper.getAllServices().then((value) {
      if (value != null && value.docs.length > 0) {
        List<ServiceModel> result = [];
        state.value = StateSuccess();
        for (var doc in value.docs) {
          ServiceModel service = ServiceModel(
              id: doc.id,
              name: doc[Constants.name],
              image: doc[Constants.image],
              options: doc[Constants.options],
              isByDate: doc[Constants.byDate]);
          result.add(service);
        }
        services = result;
      }
    });
    servicesFilter.addAll(services);
  }

  void pickCustomer(int index) {
    selectedCustomer.value = customerFilter[index];
    customerFilter.clear();
  }

  void addProduct() {
    productFilter.addAll(products);
    Get.toNamed(RoutesConst.addProduct);
  }

  void addService() {
    servicesFilter.addAll(services);
    Get.toNamed(RoutesConst.addService);
  }

  void newCustomer() async {
    phoneController = TextEditingController();
    nameController = TextEditingController();
    if (phone != null) {
      phoneController!.text = phone!;
    }

    await Get.defaultDialog(
        title: 'Thêm khách hàng',
        content: Container(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyTextFormField(
                label: 'Số điện thoại',
                controller: phoneController,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 20,
              ),
              MyTextFormField(
                label: 'Tên khách hàng',
                controller: nameController,
              ),
            ],
          ),
        ),
        actions: [
          AppButton(
            onPressed: () async {
              String name = nameController!.text;
              String phone = phoneController!.text;
              if (name.isNotEmpty && phone.isNotEmpty) {
                Customer customer = Customer(name: name, phone: phone);
                await FirebaseHelper.newCustomer(customer).then((value) {
                  customer.id = value.id;
                  selectedCustomer.value = customer;
                  customers.add(customer);
                });
                Get.back();
              }
            },
            text: 'Lưu',
          ),
          AppButton(
            onPressed: () {
              Get.back();
            },
            text: 'Đóng',
            backgroundColor: Colors.grey.withOpacity(0.4),
          ),
        ]);

    if (Get.isRegistered<CustomerController>()) {
      Get.find<CustomerController>().getAllCustomers();
    }
  }

  void inputAmount(Product product) async {
    TextEditingController amountController = TextEditingController(text: '1');
    if (selectedProduct.indexOf(product) != -1) {
      amountController.text =
          amountProduct[selectedProduct.indexOf(product)].toString();
    }
    Get.defaultDialog(
        title: 'Nhập số lượng',
        content: Container(
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MyTextFormField(
                label: 'Số lượng',
                controller: amountController,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          AppButton(
            onPressed: () async {
              String amount = amountController.text;
              if (amount.isNotEmpty && int.parse(amount) > 0) {
                if (selectedProduct.indexOf(product) != -1) {
                  amountProduct[selectedProduct.indexOf(product)] =
                      int.tryParse(amount);
                } else {
                  selectedProduct.add(product);
                  amountProduct.add(int.tryParse(amount));
                }

                Get.back();
              }
            },
            text: 'Lưu',
          ),
          AppButton(
            onPressed: () {
              Get.back();
            },
            text: 'Đóng',
            backgroundColor: Colors.grey.withOpacity(0.4),
          ),
        ]);
  }

  void pickDate(selectedDate) async {
    DateTime? pickedDate = await showDatePicker(
      context: Get.context!,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: Get.context!,
        initialTime: selectedTime.value,
      );
      if (pickedTime != null) {
        selectedDate.value = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        selectedTime.value = pickedTime;
      }
    }
  }

  String _calculationDate() {
    var diff = selectedDateEnd.value.difference(selectedDateStart.value);
    debugPrint('${selectedDateEnd} -- ${selectedDateStart}');
    var days = diff.inDays;
    debugPrint('days: $days');
    var hours = (diff.inHours - days * 24) / 24;
    debugPrint('hours: $hours');
    var minute = (diff.inMinutes - days * 24 * 60 - hours * 60) / 60;
    hours += minute;
    debugPrint('hours cal: $hours');
    if (days == 0) {
      if (selectedDateEnd.value.day - selectedDateStart.value.day == 1) {
        return '1 ngày';
      }
    }

    double tempDay = days + hours / 24;
    debugPrint('tempDay: $tempDay');
    day = (tempDay * 100).round() / 100;
    debugPrint('day: $day');

    return '$day ngày';
  }

  void inputService(ServiceModel serviceModel) {
    Get.defaultDialog(
        title: 'Chọn loại',
        content: Container(
          width: Get.width,
          height: Get.height * 0.4,
          constraints: BoxConstraints(
            maxHeight: Get.height * 0.8,
          ),
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: serviceModel.options!.keys.length,
                itemBuilder: (context, index) {
                  return Obx(() => RadioListTile(
                        value: serviceModel.options!.keys
                            .toList()[index]
                            .toString(),
                        groupValue: optionRadioService.value,
                        onChanged: (value) {
                          optionRadioService.value = value!;
                        },
                        title: Text(serviceModel.options!.keys
                            .toList()[index]
                            .toString()),
                      ));
                },
              ),
              (serviceModel.isByDate)
                  ? Column(
                      children: [
                        Row(
                          children: [
                            Expanded(flex: 1, child: AppText(text: 'Ngày gửi')),
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () {
                                  pickDate(selectedDateStart);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  height: 58,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.3),
                                          width: 1),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    children: [
                                      Obx(() => AppText(
                                          text:
                                              '${DateTimeUtil.formatTime(selectedDateStart.value)}')),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const Expanded(
                                flex: 1, child: AppText(text: 'Ngày nhận')),
                            Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () {
                                  pickDate(selectedDateEnd);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  height: 58,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.withOpacity(0.3),
                                          width: 1),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    children: [
                                      Obx(() => AppText(
                                          text:
                                              '${DateTimeUtil.formatTime(selectedDateEnd.value)}')),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
                  : Container(),
              const SizedBox(
                height: 15,
              ),
              Obx(() => Row(
                    children: [
                      Expanded(child: AppText(text: 'Số ngày gửi')),
                      Expanded(child: AppText(text: _calculationDate()))
                    ],
                  ))
            ],
          ),
        ),
        actions: [
          AppButton(
            onPressed: () async {
              selectedServices.add(serviceModel);
              optionsService.add(optionRadioService.value);
              var price =
                  (serviceModel.options![optionRadioService.value] * day)
                      .round();
              amountService.add(price);
              if (serviceModel.isByDate) {
                dateService.add({
                  Constants.startDate: selectedDateStart.value,
                  Constants.endDate: selectedDateEnd.value,
                  Constants.dateCal: day
                });
              } else {
                dateService.add({
                  Constants.startDate: null,
                  Constants.endDate: null,
                  Constants.dateCal: 1.0,
                });
              }

              optionRadioService.value = '';
              Get.back();
            },
            text: 'Lưu',
          ),
          AppButton(
            onPressed: () {
              Get.back();
            },
            text: 'Đóng',
            backgroundColor: Colors.grey.withOpacity(0.4),
          ),
        ]);
  }

  int calculationProducts() {
    if (selectedProduct.isEmpty) return 0;
    int total = 0;
    for (var i = 0; i < selectedProduct.length; i++) {
      num price = selectedProduct[i].price! * amountProduct[i];
      total += price.toInt();
    }
    return total;
  }

  void changePayment(String value) {
    if (value == PaymentMethods.cash) {
      paymentController = TextEditingController();
    }
    paymentMethods.value = value;
  }

  // tính tiền dịch vụ
  int calculationService() {
    if (selectedServices.isEmpty) return 0;
    int total = 0;
    for (var i = 0; i < amountService.length; i++) {
      num price = amountService[i];
      total += price.toInt();
    }
    return total;
  }

  // tính giảm giá sản phẩm
  int calculationDiscountProduct() {
    String discountText = productDiscountController.text;
    if (discountText.isEmpty) return 0;
    int total = calculationProducts();
    int discountInt = int.tryParse(discountText) ?? 0;
    return (total * discountInt / 100).round();
  }

  // tính giảm giá dịch vụ
  int calculationDiscountService() {
    String discountText = serviceDiscountController.text;
    if (discountText.isEmpty) return 0;
    int total = calculationService();
    int discountInt = int.tryParse(discountText) ?? 0;
    return (total * discountInt / 100).round();
  }

  // tính tổng tiền sau từ hết giảm giá
  int calculationTotal() {
    int product = calculationProducts();
    int service = calculationService();
    int discountProduct = calculationDiscountProduct();
    int discountService = calculationDiscountService();
    return product + service - discountProduct - discountService;
  }

  // tính tiền khách đưa
  int calculationCash() {
    if (paymentMethods.value == PaymentMethods.transfer) {
      return calculationTotal();
    }
    String cash = paymentController.text;
    if (cash.isEmpty) return 0;
    int cashInt = NumberUtil.parseCurrency(cash).toInt();
    return cashInt;
  }

  // tính tiền thối lại
  int calculationChangeDue() {
    int cash = calculationCash();
    int total = calculationTotal();
    return cash - total;
  }

  Future saveInvoice() async {
    if (selectedCustomer.value == null) return;
    if (selectedProduct.isEmpty && selectedServices.isEmpty) return;
    if (paymentMethods.value.isEmpty) return;
    if (paymentMethods.value == PaymentMethods.cash &&
        paymentController.text.isEmpty) return;

    int discountProduct = int.tryParse(productDiscountController.text) ?? 0;
    int discountService = int.tryParse(serviceDiscountController.text) ?? 0;
    int paymentMoney = calculationCash();
    int totalMoney = calculationTotal();
    DateTime createdAt = DateTime.now();
    UserRequest user = Get.find<HomeController>().userCurrent!;
    String staffId = user.id!;
    String staffName = user.name;
    String customerId = selectedCustomer.value!.id!;
    String customerName = selectedCustomer.value!.name;
    Invoice invoice = Invoice(
        customerName: customerName,
        staffName: staffName,
        staffId: staffId,
        customerId: customerId,
        paymentMethod: paymentMethods.value,
        discountProduct: discountProduct,
        discountService: discountService,
        paymentMoney: paymentMoney,
        totalMoney: totalMoney,
        createdAt: createdAt);

    Loading.showLoading();

    await FirebaseHelper.newInvoice(invoice).then((value) async {
      debugPrint(invoice.toMap().toString());
      if (selectedProduct.isNotEmpty) {
        for (int i = 0; i < selectedProduct.length; i++) {
          var product = selectedProduct[i];
          product.amount = amountProduct[i];
          await FirebaseHelper.newInvoiceProduct(product, value.id)
              .then((valueProduct) {});
        }
      }

      if (selectedServices.isNotEmpty) {
        for (int i = 0; i < selectedServices.length; i++) {
          var service = selectedServices[i];
          service.fromDate = dateService.value[i][Constants.startDate];
          service.toDate = dateService.value[i][Constants.endDate];
          service.days = dateService.value[i][Constants.dateCal];
          service.selectedOption = optionsService[i];
          await FirebaseHelper.newInvoiceService(service, value.id)
              .then((value) {});
        }
      }
    });
    for (int i = 0; i < selectedProduct.length; i++) {
      num amount = selectedProduct[i].amount! - amountProduct[i];
      await FirebaseHelper.updateAmountProduct(
              selectedProduct[i].id!, amount.toInt())
          .then((value) {});
    }
    if (selectedServices.isNotEmpty) {
      int times = selectedCustomer.value!.times + 1;
      await FirebaseHelper.updateCustomer(times, selectedCustomer.value!.id!)
          .then((value) {
        if (Get.isRegistered<CustomerController>()) {
          Get.find<CustomerController>().getAllCustomers();
        }
      });
    }
    Loading.hideLoading();
    Get.back();
    Get.find<InvoiceController>().getAllInvoices();
  }

  Future updateInvoice() async {}

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  final player = AudioPlayer();
  Barcode? scanData = null;

  void scannerQR() {
    Get.defaultDialog(
      title: '',
        content: Container(
      width: Get.width,
      height: Get.width,
      child: Column(
        children: [
          Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: (controller) {
                this.controller = controller;
                controller.scannedDataStream.listen((scanData) {
                      if (scanData.code == null) {
                        this.scanData = null;
                      } else {
                        this.scanData = scanData;
                      }

                });
              },
            ),
          ),
          const SizedBox(height: 10,),
          AppButton(onPressed: () async {
            if (scanData != null && scanData!.code != null && scanData!.code!.isNotEmpty) {
              for (int i = 0; i < products.length; i++) {
                if (products[i].id == scanData!.code!) {
                  if (selectedProduct.contains(products[i])) {
                    amountProduct[i] = amountProduct[i] + 1;
                  } else {
                    selectedProduct.add(products[i]);
                    amountProduct.add(1);
                  }
                }
              }

              await player.setAsset('assets/audio_scanner.mp3');
              await player.setVolume(1);
              await player.play();
              await player.stop();
            }
            scanData = null;
          }, text: 'Quét', isShadow: false,)
        ],
      ),
    ));
  }
}
