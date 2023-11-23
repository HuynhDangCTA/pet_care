
import 'package:flutter/material.dart';
import 'package:pet_care/model/chart_data.dart';
import 'package:pet_care/widgets/app_text.dart';
import 'package:pet_care/widgets/empty_data.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ColumnChart extends StatelessWidget {
  final String? title;
  final List<ChartData> data;

  const ColumnChart({super.key, this.title, required this.data});

  @override
  Widget build(BuildContext context) {
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: (data.isNotEmpty) ? SfCartesianChart(
              primaryXAxis: CategoryAxis(
                majorGridLines: const MajorGridLines(width: 0),
                labelStyle:
                const TextStyle(fontSize: 10, fontWeight: FontWeight.w400),
              ),
              margin: const EdgeInsets.all(0),
              legend: const Legend(
                  isVisible: false,
                  alignment: ChartAlignment.near,
                  position: LegendPosition.bottom,
                  overflowMode: LegendItemOverflowMode.wrap),
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ColumnSeries<ChartData, String>>[
                ColumnSeries<ChartData, String>(
                  dataSource: data,
                  dataLabelSettings: const DataLabelSettings(
                    connectorLineSettings: ConnectorLineSettings(
                        length: '15', type: ConnectorType.curve, width: 3),
                    isVisible: true,
                    margin: EdgeInsets.all(0),
                    labelPosition: ChartDataLabelPosition.outside,
                    labelAlignment: ChartDataLabelAlignment.outer,
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 13),
                    labelIntersectAction: LabelIntersectAction.none,
                  ),
                  xValueMapper: (ChartData data, _) => data.x,
                  yValueMapper: (ChartData data, _) => data.y,
                )
              ],
            ) : const EmptyDataWidget(),
          ),
        ],
      ),
    );
  }
}
