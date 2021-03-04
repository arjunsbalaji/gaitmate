import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PainChart extends StatelessWidget {

  final List<int> pain;
  PainChart(this.pain);

  @override
  Widget build(BuildContext context) {
        final List<Color> color = <Color>[];
        color.add(Colors.blue[50]);
        color.add(Colors.blue[200]);
        color.add(Colors.blue);

        final List<double> stops = <double>[];
        stops.add(0.0);
        stops.add(0.5);
        stops.add(1.0);

        final LinearGradient gradientColors =
            LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: color,
              stops: stops);

        final List<PainData> chartData = [];
        for (var i=0; i < pain.length; i++) {
          if (pain[i] != null){
            chartData.add(PainData(i,pain[i]));
          }
        }

        if (chartData.length == 1) {
          chartData.add(PainData(1, pain[0]));
        }

        return Scaffold(
            body: Center(
                child: Container(
                    child: SfCartesianChart(
                        primaryXAxis: NumericAxis(
                          labelStyle: TextStyle(fontSize:0),
                        ),
                        primaryYAxis: NumericAxis(
                          title: AxisTitle(
                            text: 'Pain Rating',
                          ),
                          interval: 2,
                          visibleMaximum: 10,
                          visibleMinimum: 0,
                        ),
                        series: <ChartSeries>[
                            // Renders area chart
                            AreaSeries<PainData, int>(
                                dataSource: chartData,
                                xValueMapper: (PainData value, _) => value.x,
                                yValueMapper: (PainData value, _) => value.painValue,
                                 gradient: gradientColors
                            )
                        ]
                    )
                )
            )
        );
    }
}

class PainData {
    final int x;
    final int painValue;
    PainData(this.x, this.painValue);
}
