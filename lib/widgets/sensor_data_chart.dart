import 'package:flutter/material.dart';
import 'package:gaitmate/helpers/size_config.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SensorDataChart extends StatelessWidget {
  final List<List<int>> sensorData;

  SensorDataChart(this.sensorData);

  @override
  Widget build(BuildContext context) {
    /* 
    final s0 = sensorData.map((e) => e[0]).toList();
    final s1 = sensorData.map((e) => e[1]).toList();
    final s2 = sensorData.map((e) => e[2]).toList();
    final s3 = sensorData.map((e) => e[3]).toList(); */
    SensorDataForPlot ssd = SensorDataForPlot(sensorData);
    final List<GMSensorData> data = ssd.convertRawSensorData();
    /* 
    s0.asMap().forEach((key, value) => [key, value]) as List;
    s1.asMap().forEach((key, value) => [key, value]) as List;
    s2.asMap().forEach((key, value) => [key, value]);
    s3.asMap().forEach((key, value) => [key, value]); */
    print('PPP' + sensorData[0].toString());
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
        series: <ChartSeries>[
          LineSeries<GMSensorData, int>(
            enableTooltip: true,
            dataSource: data,
            yValueMapper: (GMSensorData s, i) => s.i_1,
            xValueMapper: (GMSensorData s, i) => i,
          ),
        ],
        title: ChartTitle(text: 'Right Foot'),
      ),
    );
  }
}

class SensorDataForPlot {
  List<List<int>> sd;
  SensorDataForPlot(this.sd);

  List<GMSensorData> convertRawSensorData() {
    List<GMSensorData> data = [];
    sd.forEach(
      (element) {
        data.add(
          GMSensorData(element[0], element[1], element[2], element[3]),
        );
      },
    );
  }

  List<List<int>> getEnumerateSingleList(int index) {
    List<int> s = sd.map((e) => e[index]).toList();
    return s.asMap().forEach((key, value) => [key, value]) as List<List<int>>;
  }
}

class GMSensorData {
  static const String settings = 'some calibration data?';
  int i_1;
  int i_2;
  int i_3;
  int i_4;
  GMSensorData(this.i_1, this.i_2, this.i_3, this.i_4);
}
