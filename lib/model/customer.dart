
import '../core/constants.dart';

class Customer {
  String? id;
  String name;
  String phone;
  int times;

  Customer({this.id, required this.name, required this.phone, this.times = 0});

  Map<String, dynamic> toMap() {
    return {
      Constants.fullname: name,
      Constants.phone: phone,
      Constants.times: times
    };
  }
}