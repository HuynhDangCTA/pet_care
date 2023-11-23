import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pet_care/model/chart_data.dart';
import 'package:pet_care/widgets/app_text.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DoughnutChart extends StatelessWidget {
  final String? title;
  final List<ChartData> data;
  final bool showLabel;

  const DoughnutChart(
      {super.key, this.title, required this.data, this.showLabel = true});

  @override
  Widget build(BuildContext context) {
    Widget cardNormal = GridView.builder(
      itemCount: data.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 2.5),
      itemBuilder: (BuildContext context, int index) {
        return Card(
          elevation: 4,
          color: Colors.white,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 5,
                height: 70,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                    color: data[index].color),
              ),
              Container(
                width: 150,
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: AppText(
                        text: data[index].x,
                        color: data[index].color,
                        isBold: true,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.trending_up,
                          color: Colors.green,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        AppText(
                          text: data[index].y.toInt().toString(),
                          color: Colors.green,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

    Widget cardResponsive = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        direction: Axis.horizontal,
        children: List.generate(data.length, (index) {
          return Card(
            elevation: 4,
            color: Colors.white,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 5,
                  height: 70,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                      color: data[index].color),
                ),
                Container(
                  width: 150,
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: AppText(
                          text: data[index].x,
                          color: data[index].color,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.trending_up,
                            color: Colors.green,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          AppText(
                            text: data[index].y.toInt().toString(),
                            color: Colors.green,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
    return Card(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (title != null)
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AppText(
                    text: title!,
                    isBold: true,
                  ),
                )
              : Container(),
          SfCircularChart(

              margin: const EdgeInsets.all(0),
            legend: const Legend(
                padding: 0,
                itemPadding: 0,
                isVisible: false,
                alignment: ChartAlignment.center,
                position: LegendPosition.right,
                overflowMode: LegendItemOverflowMode.wrap),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CircularSeries<ChartData, String>>[
              DoughnutSeries<ChartData, String>(
                dataSource: data,
                dataLabelSettings: DataLabelSettings(
                  connectorLineSettings: const ConnectorLineSettings(
                      length: '15', type: ConnectorType.curve, width: 3),
                  isVisible: showLabel,
                  margin: const EdgeInsets.all(0),
                  labelPosition: ChartDataLabelPosition.outside,
                  textStyle: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 13),
                  labelIntersectAction: LabelIntersectAction.none,
                ),
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
                pointColorMapper: (ChartData data, index) => data.color,
              )
            ],
          ),
          (showLabel)
              ? ((Get.height / Get.width).toStringAsFixed(2) == '2.33')
                  ? cardNormal
                  : cardResponsive
              : Container()
        ],
      ),
    );
  }
}
