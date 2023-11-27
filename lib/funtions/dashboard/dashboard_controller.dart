import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/model/chart_data.dart';
import 'package:pet_care/model/invoice.dart';
import 'package:pet_care/network/firebase_helper.dart';
import 'package:pet_care/util/dialog_util.dart';

class DashBoardController extends GetxController {
  final List<ChartData> chartData = [
    ChartData('2010', 35, Colors.white),
    ChartData('2011', 28, Colors.white),
    ChartData('2012', 34, Colors.white),
    ChartData('2013', 32, Colors.white),
    ChartData('2014', 40, Colors.white)
  ];

  RxList<ChartData> customers = <ChartData>[].obs;
  RxList<ChartData> doanhThus = <ChartData>[].obs;

  @override
  void onReady() async {
    super.onReady();
    DialogUtil.showLoading();
    await getCustomers();
    DialogUtil.hideLoading();
  }

  Future getCustomers() async {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    List<DateTime> daysOfWeek = [];
    for (int i = 0; i < 7; i++) {
      daysOfWeek.add(startOfWeek.add(Duration(days: i)));
    }

    DateTime fromDate = daysOfWeek.first.subtract(const Duration(days: 1));
    DateTime toDate = daysOfWeek.last;
    await FirebaseHelper.getAmountCustomer(fromDate, toDate).then((value) {
      if (value.docs.isNotEmpty) {
        setUpCustomer();
        setUpDoanhThu();
        List<double> yValuesCustomer = [0, 0, 0, 0, 0, 0, 0];
        List<double> yValuesDoanhThu = [0, 0, 0, 0, 0, 0, 0];
        for (var doc in value.docs) {
          Invoice invoice =
              Invoice.fromDocument(doc.data() as Map<String, dynamic>);
          if (invoice.createdAt.isBefore(toDate)) {
            var day = invoice.createdAt.day;
            if (day == daysOfWeek[0].day) {
              yValuesCustomer[0] += 1;
              yValuesDoanhThu[0] += (invoice.totalMoney).toDouble();
            } else if (day == daysOfWeek[1].day) {
              yValuesCustomer[1] += 1;
              yValuesDoanhThu[1] += (invoice.totalMoney).toDouble();
            } else if (day == daysOfWeek[2].day) {
              yValuesCustomer[2] += 1;
              yValuesDoanhThu[2] += (invoice.totalMoney).toDouble();
            } else if (day == daysOfWeek[3].day) {
              yValuesCustomer[3] += 1;
              yValuesDoanhThu[3] += (invoice.totalMoney).toDouble();
            } else if (day == daysOfWeek[4].day) {
              yValuesCustomer[4] += 1;
              yValuesDoanhThu[4] += (invoice.totalMoney).toDouble();
            } else if (day == daysOfWeek[5].day) {
              yValuesCustomer[5] += 1;
              yValuesDoanhThu[5] += (invoice.totalMoney).toDouble();
            } else if (day == daysOfWeek[6].day) {
              yValuesCustomer[6] += 1;
              yValuesDoanhThu[6] += (invoice.totalMoney).toDouble();
            } else if (day == daysOfWeek[7].day) {
              yValuesCustomer[7] += 1;
              yValuesDoanhThu[7] += (invoice.totalMoney).toDouble();
            }
          }
        }
        for (var i = 0; i < customers.length; i++) {
          customers[i].y = yValuesCustomer[i];
          doanhThus[i].y = yValuesDoanhThu[i];
        }
      }
    });
  }

  void setUpCustomer() {
    customers.add(ChartData('Thứ 2', 0, Colors.white));
    customers.add(ChartData('Thứ 3', 0, Colors.white));
    customers.add(ChartData('Thứ 4', 0, Colors.white));
    customers.add(ChartData('Thứ 5', 0, Colors.white));
    customers.add(ChartData('Thứ 6', 0, Colors.white));
    customers.add(ChartData('Thứ 7', 0, Colors.white));
    customers.add(ChartData('CN', 0, Colors.white));
  }

  void setUpDoanhThu() {
    doanhThus.add(ChartData('Thứ 2', 0, Colors.white));
    doanhThus.add(ChartData('Thứ 3', 0, Colors.white));
    doanhThus.add(ChartData('Thứ 4', 0, Colors.white));
    doanhThus.add(ChartData('Thứ 5', 0, Colors.white));
    doanhThus.add(ChartData('Thứ 6', 0, Colors.white));
    doanhThus.add(ChartData('Thứ 7', 0, Colors.white));
    doanhThus.add(ChartData('CN', 0, Colors.white));
  }

}
