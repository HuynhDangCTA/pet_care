import 'package:pet_care/core/constants.dart';

class Voucher {
  String? id;
  String? name;
  String? code;
  int? discount;
  int? amount;
  int? condition;
  int used;
  DateTime? toDate;
  DateTime? fromDate;

  Voucher(
      {this.id,
      this.code,
      this.name,
      this.discount,
      this.amount,
      this.toDate,
      this.fromDate,
      this.condition,
      this.used = 0});

  Map<String, dynamic> toMap() {
    return {
      Constants.name: name,
      Constants.code: code,
      Constants.condition: condition,
      Constants.used: used,
      Constants.amount: amount,
      Constants.discount: discount,
      Constants.toDate: toDate,
      Constants.fromDate: fromDate
    };
  }

  factory Voucher.fromMap(Map<String, dynamic> data) {
    return Voucher(
      name: data[Constants.name],
      code: data[Constants.code],
      condition: data[Constants.condition],
      used: data[Constants.used].toInt(),
      amount: data[Constants.amount].toInt(),
      discount: data[Constants.discount],
      toDate: data[Constants.toDate].toDate(),
      fromDate: data[Constants.fromDate].toDate()
    );
  }
}
