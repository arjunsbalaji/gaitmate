import 'package:flutter/material.dart';

class Quote extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return 
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.3, 1],
                  colors: [Colors.blue[100], Colors.blue[200]])
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                  child: Text(
                      'A journey of a thousand miles begins with a single step - Laozi',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 1.5,
                      ),
                    ),
                )
              ),
            );
  }
}