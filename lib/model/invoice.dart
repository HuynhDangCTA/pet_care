import 'package:pet_care/core/constants.dart';

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
