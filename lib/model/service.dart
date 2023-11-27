import 'package:pet_care/core/constants.dart';

class ServiceModel {
  String? id;
  String? name;
  String? decription;
  String? image;
  Map<String, dynamic>? options;
  bool isByDate;
  String? selectedOption;
  DateTime? fromDate;
  DateTime? toDate;
  int discount;
  double? days;
  bool isDog;
  bool isCat;
  bool deleted;

  ServiceModel(
      {this.id,
      this.name,
      this.options,
      this.isDog = false,
      this.isCat = false,
      this.image,
      this.decription,
        this.deleted = false,
      this.isByDate = false,
      this.selectedOption,
      this.discount = 0,
      this.fromDate,
      this.toDate,
      this.days});

  Map<String, dynamic> toMap() {
    return {
      Constants.name: name,
      Constants.options: options,
      Constants.image: image,
      Constants.discount: discount,
      Constants.description: decription,
      Constants.byDate: isByDate,
      Constants.isDog: isDog,
      Constants.isCat: isCat,
      Constants.isDeleted: deleted
    };
  }

  Map<String, dynamic> toMapForInvoice() {
    return {
      Constants.name: name,
      Constants.options: options,
      Constants.image: image,
      Constants.byDate: isByDate,
      Constants.startDate: fromDate,
      Constants.selectedOption: selectedOption,
      Constants.endDate: toDate,
      Constants.dateCal: days
    };
  }

  factory ServiceModel.fromDocumentForInvoice(Map<String, dynamic> data) {
    return ServiceModel(
        image: data[Constants.image],
        name: data[Constants.name],
        options: data[Constants.options],
        decription: data[Constants.description],
        isByDate: data[Constants.byDate],
        fromDate: (data[Constants.startDate] != null) ? data[Constants.startDate].toDate() : null,
        toDate:(data[Constants.endDate]!= null) ?  data[Constants.endDate].toDate() : null,
        selectedOption: data[Constants.selectedOption],
        days: data[Constants.dateCal]);
  }

  factory ServiceModel.fromDocument(Map<String, dynamic> data) {
    return ServiceModel(
        image: data[Constants.image],
        name: data[Constants.name],
        options: data[Constants.options],
        decription: data[Constants.description],
        isByDate: data[Constants.byDate],
        discount: data[Constants.discount],
        isDog: data[Constants.isDog] ?? false,
        isCat: data[Constants.isCat] ?? false,
        selectedOption: data[Constants.selectedOption],
        deleted: data[Constants.isDeleted] ?? false,
        days: data[Constants.dateCal]);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServiceModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
