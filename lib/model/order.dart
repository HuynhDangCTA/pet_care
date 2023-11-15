import 'package:pet_care/model/product.dart';
import 'package:pet_care/model/user_response.dart';

class Order {
  String? id;
  UserResponse? customer;
  DateTime? createdAt;
  OrderStatus? status;
  String? reason; // lý do hủy
  DateTime? finishAt;
  int? total;
  List<Product>? products;
}

class OrderStatus {
  static const String success = 'Thành công';
  static const String fail = 'Hủy đơn';
  static const String returnOrder = 'Trả hàng';
  static const String preparing = 'Đang soạn hàng';
  static const String delivering = 'Đang giao hàng';
}
