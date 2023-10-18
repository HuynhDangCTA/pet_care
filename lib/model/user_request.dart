import 'package:pet_care/core/constants.dart';

class UserRequest {
  String? id;
  String name;
  String password;
  String type;

  UserRequest(
      {this.id, required this.name, required this.password, this.type = 'staff'});

  @override
  String toString() {
    return '{"id": "$id","name": "$name", "password": "$password", "type": "$type"}';
  }

  factory UserRequest.fromMap(Map<String, dynamic> data) {
    return UserRequest(
      id: data["id"],
      name: data[Constants.name],
      password: data[Constants.password],
      type: data[Constants.typeAccount]
    );
  }
}