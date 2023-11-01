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
  double discount;
  double? days;
  bool isDog;
  bool isCat;

  ServiceModel(
      {this.id,
      this.name,
      this.options,
      this.isDog = false,
      this.isCat = false,
      this.image,
      this.decription,
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
      Constants.isCat: isCat
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
        fromDate: data[Constants.startDate].toDate(),
        toDate: data[Constants.endDate].toDate(),
        discount: data[Constants.discount],
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
        days: data[Constants.dateCal]);
  }
}
