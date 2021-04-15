import 'package:flutter/material.dart';
import 'pages/home.dart';

void main() {
  runApp(SmannaiamentiApp());
}

class SmannaiamentiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smannaiamenti.it',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
