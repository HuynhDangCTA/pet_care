import 'package:get/get.dart';
import 'package:pet_care/core/constants.dart';
import 'package:pet_care/model/product.dart';
import 'package:pet_care/model/user_response.dart';
import 'package:pet_care/network/firebase_helper.dart';
import '../home/home_controller.dart';

class CartController extends GetxController {
  UserResponse user = HomeController.instants.userCurrent!;
  RxList<Product> products = <Product>[].obs;

  Future getAllProduct() async {
    await FirebaseHelper.getAllProductFromCart(user.id!).then((value) async {
      if (value.docs.isNotEmpty) {
        for (var item in value.docs) {
          await FirebaseHelper.getProductFromID(item.id).then((productDoc) {
            if (productDoc.exists) {
              Product product =
              Product.fromDocument(productDoc.data() as Map<String, dynamic>);
              product.amount = item[Constants.amount];
              products.add(product);
            }
          });
        }
      }
    });
  }
}
