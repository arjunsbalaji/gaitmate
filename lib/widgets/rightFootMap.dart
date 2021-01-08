import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:gaitmate/helpers/size_config.dart';
import 'package:gaitmate/providers/blue_provider.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

final rightArray = List.filled(25, 0);

class RightFootMap extends StatefulWidget {
  //Stream<List<int>> sensors;

  //RightFootMap(this.sensors);
  RightFootMap();
  @override
  _RightFootMapState createState() => _RightFootMapState();
}

class _RightFootMapState extends State<RightFootMap> {
  StreamController<List<int>> streamController;
  StreamSubscription<List<int>> streamSubscription;

  var sensors = Stream<List<int>>.periodic(
      Duration(seconds: 1),
      (x) => [
            (5 * sin(x - 7 * pi / 4)).toInt(),
            (5 * sin(x - 6 * pi / 4)).toInt(),
            (5 * sin(x - 5 * pi / 4)).toInt(),
            (5 * sin(x - pi)).toInt(),
          ]).take(100);

  //var _sensors = Stream<List<int>>

  @override
  Widget build(BuildContext context) {
    Stream<List<int>> sensorStream =
        Provider.of<BlueProvider>(context).sensorStream;

    BlueProvider blue = Provider.of<BlueProvider>(context);

    /* streamSubscription =
        sensorStream.asBroadcastStream().listen((List<int> event) {
      return event;
    }); */

    return StreamBuilder<List<int>>(
        stream: sensorStream, //widget.sensors,
        builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
          List<Widget> children;
          if (snapshot.hasError) {
            children = <Widget>[
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Text('Error: ${snapshot.error}'),
            ];
          } else {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                children = <Widget>[
                  Icon(Icons.info, color: Colors.blue),
                  Text('Connect the sensors'),
                ];
                break;
              case ConnectionState.waiting:
                children = <Widget>[
                  Center(
                    child: Container(
                      padding:
                          EdgeInsets.all(SizeConfig.blockSizeHorizontal * 10),
                      width: SizeConfig.blockSizeVertical * 20,
                      height: SizeConfig.blockSizeVertical * 20,
                      child: const CircularProgressIndicator(),
                    ),
                  )
                ];
                break;
              case ConnectionState.active:
                rightArray[2] = snapshot.data[0];
                rightArray[6] = snapshot.data[1];
                rightArray[9] = snapshot.data[2];
                rightArray[23] = snapshot.data[3];
                rightArray[7] = ((rightArray[2] + rightArray[6]) ~/ 2);
                rightArray[8] = ((rightArray[7] + rightArray[9]) ~/ 2);
                rightArray[13] =
                    rightArray[8] + ((rightArray[23] - rightArray[8]) ~/ 3);
                rightArray[18] =
                    rightArray[13] + ((rightArray[23] - rightArray[8]) ~/ 3);
                rightArray[12] = ((rightArray[7] + rightArray[13]) ~/ 2);

                children = <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: SizeConfig.blockSizeHorizontal),
                    width: SizeConfig.blockSizeHorizontal * 25,
                    height: SizeConfig.blockSizeVertical * 20,
                    child: GridView.count(
                      crossAxisCount: 5,
                      children: List.generate(
                        25,
                        (int index) {
                          return Container(
                            color: Colors.purple[
                                100 * (rightArray[index] / 2000).ceil()],
                          );
                        },
                      ),
                    ),
                  ),
                ];
                break;
              case ConnectionState.done:
                children = <Widget>[
                  Container(
                    padding: EdgeInsets.all(SizeConfig.blockSizeHorizontal * 5),
                    width: SizeConfig.blockSizeHorizontal * 25,
                    height: SizeConfig.blockSizeVertical * 20,
                    child: Column(children: [
                      Icon(
                        Icons.info,
                        color: Colors.blue,
                      ),
                      Text(
                        'Sensor off',
                        textAlign: TextAlign.center,
                      )
                    ]),
                  ),
                ];
                break;
            }
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          );
        });
  }
}
