import 'package:pet_care/core/constants.dart';

import 'item_warehouse.dart';

class Warehouse {
  List<ItemWarehouse> proudcts;
  DateTime timeCreated;

  Warehouse(this.proudcts, this.timeCreated);

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> productMap = proudcts.map((e) =>
    {
      e.product.id!: e.amount
    }).toList();
    return {
      Constants.products: productMap,
      Constants.createdAt: timeCreated
    };
  }
}