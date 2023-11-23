
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/funtions/dashboard/dashboard_controller.dart';
import 'package:pet_care/widgets/column_chart.dart';
import 'package:pet_care/widgets/line_chart.dart';

class DashBoardPage extends GetView<DashBoardController> {
  const DashBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(() => LineChart(data: controller.customers.value, title: 'Lượng khách hàng',)),
            const SizedBox(height: 10,),
            Obx(() => ColumnChart(data: controller.doanhThus.value, title: 'Doanh thu',))
          ],
        ),
      ),
    );
  }
}
