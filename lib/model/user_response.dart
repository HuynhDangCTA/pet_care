import 'package:pet_care/core/constants.dart';

class UserResponse {
  String? id;
  String? username;
  String? password;
  String? name;
  String? phoneNumber;
  String? address;
  String? avatar;
  String? type;
  bool isDeleted;

  UserResponse(
      {this.id,
      this.username,
      this.password,
      this.name,
      this.phoneNumber,
      this.address,
      this.avatar,
      this.type, this.isDeleted = false});

  Map<String, dynamic> toMap() {
    return {
      Constants.username: username,
      Constants.password: password,
      Constants.fullname: name,
      Constants.phone: phoneNumber,
      Constants.address: address,
      Constants.avt: avatar,
      Constants.typeAccount: type,
      Constants.isDeleted: isDeleted
    };
  }
}
