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
  double? days;

  ServiceModel(
      {this.id,
      this.name,
      this.options,
      this.image,
      this.decription,
      this.isByDate = false,
      this.selectedOption,
      this.fromDate,
      this.toDate,
      this.days});

  Map<String, dynamic> toMap() {
    return {
      Constants.name: name,
      Constants.options: options,
      Constants.image: image,
      Constants.byDate: isByDate
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

  factory ServiceModel.fromDocument(Map<String, dynamic> data) {
    return ServiceModel(
      image: data[Constants.image],
      name: data[Constants.name],
      options: data[Constants.options],
      isByDate: data[Constants.byDate],
      fromDate: data[Constants.startDate].toDate(),
      toDate: data[Constants.endDate].toDate(),
      selectedOption: data[Constants.selectedOption],
      days: data[Constants.dateCal]
    );
  }
}
