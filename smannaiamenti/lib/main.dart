import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'pages/home.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  initializeDateFormatting("it_IT");
  Intl.defaultLocale = "it_IT";
  runApp(SmannaiamentiApp());
}

class SmannaiamentiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smannaiamenti.it',
      theme: ThemeData(
        brightness: Brightness.light,
        /* light theme settings */
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: ThemeMode.system,
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      home: HomePage(),
    );
  }
}
