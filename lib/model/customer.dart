import 'package:pet_care/model/user_response.dart';

import '../core/constants.dart';
import 'order_model.dart';

class Customer {
  String? id;
  String name;
  String phone;
  int times;
  String? idUser;
  UserResponse? user;
  List<OrderModel>? orders;

  Customer(
      {this.id,
      required this.name,
      required this.phone,
      this.times = 0,
      this.user,
      this.orders,
      this.idUser});

  Map<String, dynamic> toMap() {
    return {
      Constants.fullname: name,
      Constants.phone: phone,
      Constants.times: times
    };
  }

  factory Customer.fromDoc(Map<String, dynamic> data) {
    return Customer(
        name: data[Constants.fullname],
        phone: data[Constants.phone],
        idUser: data[Constants.id],
        times: data[Constants.times]);
  }
}
