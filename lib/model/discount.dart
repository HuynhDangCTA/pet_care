
import 'package:pet_care/core/constants.dart';

class Discount {
  String? id;
  String? name;
  int? discount;
  List? productId;
  bool? isAllProduct;
  DateTime? toDate;
  DateTime? fromDate;
  String status;

  Discount({this.id, this.name, this.discount, this.productId, this.isAllProduct,
      this.toDate, this.fromDate, this.status = 'Dừng'});

  Map<String, dynamic> toMap() {
    return {
      Constants.name: name,
      Constants.discount: discount,
      Constants.toDate: toDate,
      Constants.fromDate: fromDate,
      Constants.allProduct: isAllProduct,
      Constants.products: productId,
    };
  }

  factory Discount.fromMap(Map<String, dynamic> doc) {
    return Discount(
      name: doc[Constants.name],
      discount: doc[Constants.discount],
      isAllProduct: doc[Constants.allProduct],
      productId: doc[Constants.products],
      toDate: doc[Constants.toDate].toDate(),
      fromDate: doc[Constants.fromDate].toDate()
    );
  }

}