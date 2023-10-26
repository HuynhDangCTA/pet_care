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

  Product(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.amount = 0,
      this.image,
      this.type,
      this.priceInput = 0});

  Map<String, dynamic> toMap() {
    return {
      Constants.name: name,
      Constants.price: price,
      Constants.image: image,
      Constants.amount: amount,
      Constants.description: description,
      Constants.priceInput: priceInput,
      Constants.type: type
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
