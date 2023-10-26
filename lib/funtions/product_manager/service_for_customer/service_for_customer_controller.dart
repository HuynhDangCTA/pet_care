import 'package:get/get.dart';
import 'package:pet_care/core/constants.dart';

import '../../../model/service.dart';
import '../../../model/state.dart';
import '../../../network/firebase_helper.dart';

class ServiceForCustomerController extends GetxController {
  RxList<ServiceModel> services = RxList();
  Rx<AppState> state = Rx(StateSuccess());

  @override
  void onInit() async{
    await getAllService();
    super.onInit();
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
        services.value = result;
        if (result.isEmpty) {
          state.value = StateEmptyData();
        }
      }
    });
  }
}
