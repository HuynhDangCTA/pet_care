import '../core/constants.dart';

class Product {
  String? id;
  String? name;
  String? image;
  String? description;
  int? price;
  int? amount;
  int priceInput;

  Product(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.amount = 0,
      this.image,
      this.priceInput = 0});

  Map<String, dynamic> toMap() {
    return {
      Constants.name: name,
      Constants.price: price,
      Constants.image: image,
      Constants.amount: amount,
      Constants.priceInput: priceInput
    };
  }

  factory Product.fromDocument(Map<String, dynamic> data) {
    return Product(
        name: data[Constants.name],
        image: data[Constants.image],
        price: data[Constants.price],
        amount: data[Constants.amount]);
  }
}