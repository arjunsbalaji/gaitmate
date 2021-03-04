import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SensorDataChart extends StatelessWidget {
  final List<List<int>> sensorData;

  SensorDataChart(this.sensorData);

  @override
  Widget build(BuildContext context) {

    final l0 = sensorData.map((e) => e[0]).toList();
    final l1 = sensorData.map((e) => e[1]).toList();
    final l2 = sensorData.map((e) => e[2]).toList();
    final l3 = sensorData.map((e) => e[3]).toList(); 

    final s0 = l0.length == 0 ? 0.0: l0.reduce((a,b) => a + b)/l0.length;
    final s1 = l1.length == 0 ? 0.0: l1.reduce((a,b) => a + b)/l1.length;
    final s2 = l2.length == 0 ? 0.0: l2.reduce((a,b) => a + b)/l2.length;
    final s3 = l3.length == 0 ? 0.0: l3.reduce((a,b) => a + b)/l3.length;

    final List<ForceData> chartData = [
      ForceData('Big Toe', s0, 40),
      ForceData('Inner Foot', s1, 300),
      ForceData('Outer Foot', s2, 100),
      ForceData('Heel', s3, 60)
    ];

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
              text: 'Right Foot'
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