import 'package:pet_care/core/constants.dart';

import 'item_warehouse.dart';

class Warehouse {
  List<ItemWarehouse>? proudcts;
  DateTime? timeCreated;
  String? image;
  int? price;

  Warehouse({this.proudcts, this.timeCreated, this.image, this.price});

  Map<String, dynamic> toMap() {
    return {
      Constants.price: price,
      Constants.createdAt: timeCreated,
      Constants.image: image
    };
  }
}
