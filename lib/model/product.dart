import 'package:get/get.dart';

import '../core/constants.dart';

class Product {
  String? id;
  String? name;
  String? image;
  String? description;
  int? price;
  int? amount;
  int priceInput;
  String? type;
  String? unit;
  bool selected;
  int? discount;
  bool deleted;
  int sold;

  Product({this.id,
    this.name,
    this.description,
    this.price,
    this.amount = 0,
    this.sold = 0,
    this.image,
    this.type,
    this.deleted = false,
    this.discount = 0,
    this.unit,
    this.selected = false,
    this.priceInput = 0});

  Map<String, dynamic> toMap() {
    return {
      Constants.name: name,
      Constants.price: price,
      Constants.image: image,
      Constants.amount: amount,
      Constants.description: description,
      Constants.priceInput: priceInput,
      Constants.unit: unit,
      Constants.sold: sold,
      Constants.isDeleted: deleted,
      Constants.discount: discount,
      Constants.type: type
    };
  }

  factory Product.fromDocument(Map<String, dynamic> data) {
    return Product(
        name: data[Constants.name],
        image: data[Constants.image],
        price: data[Constants.price],
        amount: data[Constants.amount],
        unit: data[Constants.unit],
        sold: data[Constants.sold],
        description: data[Constants.description],
        deleted: data[Constants.isDeleted],
        discount: data[Constants.discount].toInt(),
        type: data[Constants.type],
        selected: data['selected'] ?? false);
  }
}
