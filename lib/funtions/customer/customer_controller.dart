import 'package:get/get.dart';
import 'package:pet_care/core/constants.dart';
import 'package:pet_care/model/order_model.dart';
import 'package:pet_care/model/product.dart';
import 'package:pet_care/model/state.dart';
import 'package:pet_care/model/user_response.dart';
import 'package:pet_care/model/voucher.dart';
import 'package:pet_care/network/firebase_helper.dart';
import 'package:pet_care/routes/routes_const.dart';
import 'package:pet_care/util/loading.dart';

import '../../model/customer.dart';

class CustomerController extends GetxController {
  RxList<Customer> customers = <Customer>[].obs;
  Rx<AppState> state = Rx(StateSuccess());

  @override
  void onInit() async {
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
    await getAllCustomers();
  }

  Future getAllCustomers() async {
    Loading.showLoading();
    state.value = StateLoading();
    await FirebaseHelper.getAllCustomer().then((value) {
      Loading.hideLoading();
      if (value.docs.isNotEmpty) {
        List<Customer> result = [];
        state.value = StateSuccess();
        for (var doc in value.docs) {
          Customer customer =
              Customer.fromDoc(doc.data() as Map<String, dynamic>);
          customer.id = doc.id;
          result.add(customer);
        }
        customers.value = result;
      }
    });
  }

  Future goDetailCustomers(Customer customer) async {
    print('user id: ${customer.idUser}');
    Loading.showLoading();
    if (customer.idUser != null) {
      await FirebaseHelper.getUserFromID(customer.idUser!).then((value) async {
        if (value.exists) {
          UserResponse user =
              UserResponse.fromMap(value.data() as Map<String, dynamic>);
          user.id = value.id;
          customer.user = user;
          await FirebaseHelper.getAllOrderCustomer(customer.user!.id!)
              .then((value) async {
            if (value.docs.isNotEmpty) {
              customer.orders = [];
              for (var doc in value.docs) {
                OrderModel order =
                    OrderModel.fromMap(doc.data() as Map<String, dynamic>);
                order.id = doc.id;
                await FirebaseHelper.getProductFromOrder(order.id!)
                    .then((value) {
                  if (value.docs.isNotEmpty) {
                    List<Product> result = [];
                    for (var doc in value.docs) {
                      Product product = Product.fromDocument(
                          doc.data() as Map<String, dynamic>);
                      product.id = doc.id;
                      result.add(product);
                    }
                    order.product = result;
                  }
                });
                await FirebaseHelper.getVoucherFromOrder(order.id!)
                    .then((value) {
                  if (value.docs.isNotEmpty) {
                    Voucher voucher = Voucher.fromMap(
                        value.docs.first.data() as Map<String, dynamic>);
                    voucher.id = value.docs.first.id;
                    order.voucher = voucher;
                  }
                });
                order.orderBy = user;
                customer.orders!.add(order);

              }
            }
          });
        }
      });
    }
    Loading.hideLoading();
    Get.toNamed(RoutesConst.customerDetail, arguments: customer);
  }
}
