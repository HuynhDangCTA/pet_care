import 'package:get/get.dart';
import 'package:pet_care/funtions/invoice/new_invoice/new_invoice_controller.dart';
import 'package:pet_care/model/customer.dart';
import 'package:pet_care/model/product.dart';
import 'package:pet_care/model/service.dart';
import 'package:pet_care/model/user_response.dart';
import 'package:pet_care/network/firebase_helper.dart';
import 'package:pet_care/routes/routes_const.dart';

import '../../model/invoice.dart';

class InvoiceController extends GetxController {
  RxList<Invoice> invoices = <Invoice>[].obs;
  RxInt totalInvoice = 0.obs;
  RxInt totalMoney = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    await getAllInvoices();
  }

  void goNewInvoice() {
    Get.lazyPut(() => NewInvoiceController());
    Get.toNamed(RoutesConst.newInvoice);
  }

  void goCustomerPage() {
    Get.toNamed(RoutesConst.customer);
  }

  void goOrderPage() {
    Get.toNamed(RoutesConst.order);
  }

  Future getAllInvoices() async {
    invoices.clear();
    await FirebaseHelper.getAllInvoice().then((value) {
      if (value.docs.isNotEmpty) {
        for (var doc in value.docs) {
          Invoice invoice =
              Invoice.fromDocument(doc.data() as Map<String, dynamic>);
          invoice.id = doc.id;
          invoices.add(invoice);
        }
      }
    });
    calculationInvoice();
  }

  void calculationInvoice() {
    DateTime today = DateTime.now();
    int totalI = 0;
    int totalM = 0;
    if (invoices.isNotEmpty) {
      for (var invoice in invoices) {
        if (invoice.createdAt.day == today.day &&
            invoice.createdAt.year == today.year &&
            invoice.createdAt.month == today.month) {
          totalI++;
          totalM += invoice.totalMoney;
        }
      }
    }
    totalInvoice.value = totalI;
    totalMoney.value = totalM;
  }

  void editInvoice(Invoice invoice) {
    Get.lazyPut(() => NewInvoiceController());
    Get.toNamed(RoutesConst.newInvoice, arguments: invoice);
  }

  Future goDetail(Invoice invoice) async {
    await FirebaseHelper.getAllProductInInvoice(invoice.id!).then((value) {
      if (value.docs.isNotEmpty) {
        invoice.products = [];
        for (var doc in value.docs) {
          Product product =
              Product.fromDocument(doc.data() as Map<String, dynamic>);
          product.id = doc.id;
          invoice.products!.add(product);
        }
      }
    });

    await FirebaseHelper.getAllServiceInInvoice(invoice.id!).then((value) {
      if (value.docs.isNotEmpty) {
        invoice.services = [];
        for (var doc in value.docs) {
          ServiceModel serviceModel =
              ServiceModel.fromDocumentForInvoice(doc.data() as Map<String, dynamic>);
          serviceModel.id = doc.id;
          invoice.services!.add(serviceModel);
        }
      }
    });

    await FirebaseHelper.getCustomerFromID(invoice.customerId).then((value) {
      if (value.exists) {
        Customer customer =
            Customer.fromDoc(value.data() as Map<String, dynamic>);
        customer.id = value.id;
        invoice.customer = customer;
      }
    });

    await FirebaseHelper.getUserFromID(invoice.staffId).then((value) {
      if (value.exists) {
        UserResponse user =
        UserResponse.fromMap(value.data() as Map<String, dynamic>);
        user.id = value.id;
        invoice.staff = user;
      }
    });

    Get.toNamed(RoutesConst.invoiceDetail, arguments: invoice);
  }
}
