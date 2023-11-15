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
  int times;

  UserResponse(
      {this.id,
        this.username,
        this.password,
        this.name,
        this.phoneNumber,
        this.address,
        this.times = 0,
        this.avatar,
        this.type,
        this.isDeleted = false});

  Map<String, dynamic> toMap() {
    return {
      Constants.id: id,
      Constants.username: username,
      Constants.password: password,
      Constants.fullname: name,
      Constants.phone: phoneNumber,
      Constants.address: address,
      Constants.avt: avatar,
      Constants.typeAccount: type,
      Constants.isDeleted: isDeleted,
      Constants.times: times,
    };
  }

  factory UserResponse.fromMap(Map<String, dynamic> json) {
    return UserResponse(
        username: json[Constants.username],
        password: json[Constants.password],
        name: json[Constants.fullname],
        phoneNumber: json[Constants.phone],
        address: json[Constants.address],
        avatar: json[Constants.avt],
        type: json[Constants.type],
        isDeleted: json[Constants.isDeleted]);
  }
}
