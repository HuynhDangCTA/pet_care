import 'package:pet_care/core/constants.dart';

class StaffResponse {
  String? username;
  String? password;
  String? name;
  String? phoneNumber;
  String? address;
  String avatar;
  String? type;

  StaffResponse(
      {this.username,
      this.password,
      this.name,
      this.phoneNumber,
      this.address,
      this.avatar = 'images/profile.png', this.type});

  Map<String, dynamic> toMap() {
    return {
      Constants.username: username,
      Constants.password: password,
      Constants.name: name,
      Constants.phone: phoneNumber,
      Constants.address: address,
      Constants.avt: avatar,
      Constants.typeAccount: type
    };
  }
}
