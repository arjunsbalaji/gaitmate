import 'package:flutter/material.dart';

class TotalDurationText extends StatelessWidget {

  final String strTotalDuration;

  TotalDurationText(this.strTotalDuration);

  @override
  Widget build(BuildContext context) {
    return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.3, 1],
                  colors: [Color(0xff5f2c82), Color(0xff49a09d)]),
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                  child: Text(
                        'Total Duration of Activity for this week: $strTotalDuration',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                    ),
                )
              ),
            );
  }
}

