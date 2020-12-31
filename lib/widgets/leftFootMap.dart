import 'package:flutter/material.dart';
import 'dart:math';
import 'package:gaitmate/helpers/size_config.dart';

final leftArray = List.filled(25, 0);

class LeftFootMap extends StatefulWidget {
  @override
  _LeftFootMapState createState() => _LeftFootMapState();

}

class _LeftFootMapState extends State<LeftFootMap> {

  var _sensors = Stream<List<int>>.periodic(Duration(seconds:1),
      (x) => [
        (5*sin(x-3*pi/4)).toInt(),
        (5*sin(x-2*pi/4)).toInt(),
        (5*sin(x-pi/4)).toInt(),
        (5*sin(x)).toInt(),
      ]).take(100);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<int>>(
      stream: _sensors,
      builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
        List<Widget> children;
        if (snapshot.hasError) {
          children = <Widget> [
            Icon(
              Icons.error_outline,
              color:Colors.red,
              size:60,
            ),
            Text('Error: ${snapshot.error}'),
          ];
        } else {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              children = <Widget> [
                Icon(
                  Icons.info,
                  color: Colors.blue
                ),
                Text('Connect the sensors'),
              ];
              break;
            case ConnectionState.waiting:
              children = <Widget> [
                Container(
                  padding: EdgeInsets.all(
                      SizeConfig.blockSizeHorizontal*10),
                  width: SizeConfig.blockSizeVertical*20,
                  height: SizeConfig.blockSizeVertical*20,
                  child: const CircularProgressIndicator(),
                )
              ];
              break;
            case ConnectionState.active:
              leftArray[2] = snapshot.data[0];
              leftArray[8] = snapshot.data[1];
              leftArray[5] = snapshot.data[2];
              leftArray[21] = snapshot.data[3];
              leftArray[7] = (0.5*(leftArray[2] + leftArray[8])).toInt();
              leftArray[6] = (0.5*(leftArray[5] + leftArray[7])).toInt();
              leftArray[11] = leftArray[6] + ((leftArray[21] - leftArray[6])~/3);
              leftArray[16] = leftArray[11] + ((leftArray[21] - leftArray[6])~/3);
              leftArray[12] = ((leftArray[7] + leftArray[11])~/2);

              children = <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal:SizeConfig.blockSizeHorizontal),
                  width: SizeConfig.blockSizeHorizontal*25,
                  height: SizeConfig.blockSizeVertical*20,
                  child: GridView.count(
                    crossAxisCount: 5,
                    children: List.generate(25, (int index) {
                      return Container(
                        color: Colors.amber[100 * leftArray[index]],
                      );
                    },),
                  ),
                ),
              ];
              break;
            case ConnectionState.done:
              children = <Widget>[
                Container(
                  padding: EdgeInsets.all(
                      SizeConfig.blockSizeHorizontal*5),
                  width: SizeConfig.blockSizeHorizontal*25,
                  height: SizeConfig.blockSizeVertical*20,
                  child: Column(children: [
                    Icon(
                      Icons.info,
                      color:Colors.blue,
                    ),
                    Text(
                      'Sensor off',
                      textAlign: TextAlign.center,
                    )]),
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
      }
    );
  }
}