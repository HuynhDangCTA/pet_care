import 'package:pet_care/core/constants.dart';
import 'package:pet_care/model/customer.dart';
import 'package:pet_care/model/service.dart';
import 'package:pet_care/model/user_response.dart';

import 'product.dart';

class Invoice {
  String? id;
  String staffId;
  String customerId;
  String customerName;
  String staffName;
  int discountProduct;
  int discountService;
  String paymentMethod;
  int paymentMoney;
  int totalMoney;
  DateTime createdAt;
  String status;
  List<Product>? products;
  List<ServiceModel>? services;
  Customer? customer;
  UserResponse? staff;

  Invoice(
      {this.id,
      required this.staffId,
      required this.customerId,
      required this.customerName,
      required this.staffName,
      this.discountProduct = 0,
      this.discountService = 0,
      required this.paymentMethod,
      required this.paymentMoney,
      this.status = 'Đã lưu',
      required this.totalMoney,
      this.products,
      this.services,
      this.customer,
      this.staff,
      required this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      Constants.staffId: staffId,
      Constants.customerId: customerId,
      Constants.customerName: customerName,
      Constants.staffName: staffName,
      Constants.discountProduct: discountProduct,
      Constants.discountService: discountService,
      Constants.status: status,
      Constants.paymentMethod: paymentMethod,
      Constants.paymentMoney: paymentMoney,
      Constants.totalMoney: totalMoney,
      Constants.createdAt: createdAt
    };
  }

  factory Invoice.fromDocument(Map<String, dynamic> data) {
    return Invoice(
        staffId: data[Constants.staffId],
        discountProduct: data[Constants.discountProduct],
        discountService: data[Constants.discountService],
        customerName: data[Constants.customerName],
        staffName: data[Constants.staffName],
        status: data[Constants.status],
        customerId: data[Constants.customerId],
        paymentMethod: data[Constants.paymentMethod],
        paymentMoney: data[Constants.paymentMoney],
        totalMoney: data[Constants.totalMoney],
        createdAt: data[Constants.createdAt].toDate());
  }
}
