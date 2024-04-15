import 'dart:io';

import 'package:flutter/material.dart';

class GlobalErrorDisplay extends StatelessWidget {
  const GlobalErrorDisplay({
    super.key,
    this.flutterError,
    this.platformError,
  });

  final FlutterErrorDetails? flutterError;
  final Object? platformError;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    textAlign: TextAlign.center,
                    'Oops... something went wrong.\nWe will investigte immediately and solve this issue as soon as possible.'),
                SizedBox(height: 50),
                ElevatedButton(
                    onPressed: () {
                      exit(1);
                    },
                    child: Text('Exit the app.'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
