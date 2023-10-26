import 'package:get/get.dart';
import 'package:pet_care/model/product.dart';

import '../../../../core/constants.dart';
import '../../../../model/user_request.dart';
import '../../../../network/firebase_helper.dart';
import '../../../../util/dialog_util.dart';
import '../../../home/home_controller.dart';

class ProductDetailCustomerController extends GetxController {
  Product product = Get.arguments;
  UserRequest user = HomeController.instants.userCurrent!;

  Future addToCart(Product product) async {
    await FirebaseHelper.getProductFromCart(product.id!, user.id!)
        .then((value) {
      if (value.exists) {
        String amount = value.get(Constants.amount);
        product.amount = int.parse(amount) + 1;
      } else {
        product.amount = 1;
      }
    });

    await FirebaseHelper.addToCart(product, user.id!).then((value) {
      DialogUtil.showSnackBar('Thêm thành công');
    });
  }
}
