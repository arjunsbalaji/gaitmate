import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ColumnChart extends StatelessWidget {
  final List<ForceData> chartData = [
    ForceData('Big Toe', 50, 40),
    ForceData('Inner Foot', 30, 30),
    ForceData('Outer Foot', 50, 30),
    ForceData('Heel', 60,60)
  ];

  @override
  Widget build(BuildContext context) {
    //print(activity.position.toString());
    return Scaffold(
      body: Center(
        child: Container(
          child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(
              title: AxisTitle(
                text: 'Force (N)',
              ),
            ),

            legend: Legend(
              isVisible: true,
              position: LegendPosition.bottom,
              ),
            series: <ChartSeries>[
              ColumnSeries<ForceData, dynamic>(
                name: 'Population Average',
                dataSource: chartData,
                xValueMapper: (ForceData value, _) => value.x,
                yValueMapper: (ForceData value, _) => value.average
              ),
              ColumnSeries<ForceData, dynamic>(
                name: 'Yours',
                dataSource: chartData,
                xValueMapper: (ForceData value, _) => value.x,
                yValueMapper: (ForceData value, _) => value.client
              )
            ],
            title: ChartTitle(
              text: 'Left Foot'
            ),
          )
        )
      )
    );
  }
}

  class ForceData {
    final String x;
    final double client;
    final double average;
    ForceData(this.x, this.client, this.average);
  }