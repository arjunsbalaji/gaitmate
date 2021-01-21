import 'package:flutter/material.dart';
import 'package:gaitmate/helpers/size_config.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SensorDataChart extends StatelessWidget {
  final List<List<int>> sensorData;

  SensorDataChart(this.sensorData);

  @override
  Widget build(BuildContext context) {
    final s0 = sensorData.map((e) => e[0]).toList();
    final s1 = sensorData.map((e) => e[1]).toList();
    final s2 = sensorData.map((e) => e[2]).toList();
    final s3 = sensorData.map((e) => e[3]).toList();
/* 
    s0.asMap().forEach((key, value) => [key, value]) as List;
    s1.asMap().forEach((key, value) => [key, value]) as List;
    s2.asMap().forEach((key, value) => [key, value]);
    s3.asMap().forEach((key, value) => [key, value]); */
    print('PPP' +
        (s0.asMap().forEach((key, value) => [key, value]) as List).toString());
    return Container(
      height: SizeConfig.screenHeight * 0.4,
      width: SizeConfig.screenWidth * 0.9,
      child: SfCartesianChart(
        primaryXAxis: NumericAxis(
          title: AxisTitle(
            text: 'Time (s)',
          ),
        ),
        primaryYAxis: NumericAxis(
          title: AxisTitle(
            text: 'Force (N)',
          ),
        ),
        legend: Legend(
          isVisible: true,
          position: LegendPosition.bottom,
        ),
        series: <CartesianSeries>[
          LineSeries<List<int>, int>(
            enableTooltip: true,
            dataSource: s0.asMap().forEach((key, value) => [key, value])
                as List<List<int>>,
            xValueMapper: (List<int> s, _) => s[1],
            yValueMapper: (List<int> s, _) => s[0],
          ),
          LineSeries<List<int>, int>(
            dataSource: s1.asMap().forEach((key, value) => [key, value])
                as List<List<int>>,
            xValueMapper: (List<int> s, _) => s[1],
            yValueMapper: (List<int> s, _) => s[0],
          ),
          LineSeries<List<int>, int>(
            dataSource: s2.asMap().forEach((key, value) => [key, value])
                as List<List<int>>,
            xValueMapper: (List<int> s, _) => s[1],
            yValueMapper: (List<int> s, _) => s[0],
          ),
          LineSeries<List<int>, int>(
            dataSource: s3.asMap().forEach((key, value) => [key, value])
                as List<List<int>>,
            xValueMapper: (List<int> s, _) => s[1],
            yValueMapper: (List<int> s, _) => s[0],
          ),
        ],
        title: ChartTitle(text: 'Right Foot'),
      ),
    );
  }
}
