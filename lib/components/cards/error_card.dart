import 'package:flutter/material.dart';

/// Display the current error status from the speech
/// recognizer
class ErrorWidget extends StatelessWidget {
  final String lastError;

  const ErrorWidget({Key? key, required this.lastError}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Center(
          child: Text(
            '',
            style: TextStyle(fontSize: 22.0),
          ),
        ),
        Center(
          child: Text(lastError),
        ),
      ],
    );
  }
}
