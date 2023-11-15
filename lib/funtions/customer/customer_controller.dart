import 'package:get/get.dart';
import 'package:pet_care/core/constants.dart';
import 'package:pet_care/model/state.dart';
import 'package:pet_care/network/firebase_helper.dart';

import '../../model/customer.dart';

class CustomerController extends GetxController {
  RxList<Customer> customers = <Customer>[].obs;
  Rx<AppState> state = Rx(StateSuccess());

  @override
  void onInit() async {
    super.onInit();
    state.value = StateLoading();
    await getAllCustomers();
  }

  Future getAllCustomers() async {
    state.value = StateLoading();
    await FirebaseHelper.getAllCustomer().then((value) {
      if (value.docs.isNotEmpty) {
        List<Customer> result = [];
        state.value = StateSuccess();
        for (var doc in value.docs) {
          Customer customer = Customer(
              id: doc.id,
              times: doc[Constants.times],
              name: doc[Constants.fullname],
              phone: doc[Constants.phone]);
          result.add(customer);
        }
        customers.value = result;
      }
    });
  }
}
