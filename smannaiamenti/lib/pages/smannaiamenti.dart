import 'package:flutter/material.dart';
import 'package:smannaiamenti/config.dart';
import 'home.dart';

class SmannaiamentiApp extends StatefulWidget {
  @override
  _SmannaiamentiAppState createState() => _SmannaiamentiAppState();
}

class _SmannaiamentiAppState extends State<SmannaiamentiApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    currentTheme.addListener(() {
      setState(() {
        _themeMode = currentTheme.themeMode();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'smannaiamenti.it',
      theme: ThemeData(
        brightness: Brightness.light,
        /* light theme settings */
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: _themeMode,
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      // ),
      home: HomePage(),
    );
  }
}