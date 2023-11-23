import 'package:pet_care/core/constants.dart';
import 'package:pet_care/model/product.dart';
import 'package:pet_care/model/user_response.dart';
import 'package:pet_care/model/voucher.dart';


class OrderModel {
  String? id;
  int? totalMoney;
  int? discountMoney;
  int? voucherMoney;
  int? payMoney;
  String? address;
  int? shipFee;
  Voucher? voucher;
  List<Product>? product;
  UserResponse? orderBy;
  UserResponse? staff;
  String? status;
  DateTime? createdAt;

  OrderModel(
      {this.id,
      this.totalMoney,
      this.discountMoney,
      this.voucherMoney,
      this.payMoney,
      this.address,
      this.shipFee,
      this.voucher,
      this.product,
      this.orderBy,
      this.staff,
      this.status,
      this.createdAt});

  Map<String, dynamic> toMap() {
    return {
      Constants.customerName: orderBy!.name,
      Constants.discount: discountMoney,
      Constants.customerId: orderBy!.id,
      Constants.status: status,
      Constants.ship: shipFee,
      Constants.address: address,
      Constants.createdAt: DateTime.now(),
      Constants.totalMoney: totalMoney,
      Constants.paymentMoney: payMoney,
      Constants.products: product!.length,
      Constants.voucherName: (voucher == null) ? null : voucher!.name,
      Constants.voucherCode: (voucher == null) ? null : voucher!.code,
      Constants.voucherId: (voucher == null) ? null : voucher!.id,
      Constants.voucherMoney: voucherMoney
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> data) {
    return OrderModel(
      voucherMoney: data[Constants.voucherMoney],
      discountMoney: data[Constants.discount],
      status: data[Constants.status],
      shipFee: data[Constants.ship],
      address: data[Constants.address],
      payMoney: data[Constants.paymentMoney],
      totalMoney: data[Constants.totalMoney],
      createdAt: data[Constants.createdAt].toDate(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
