import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:smannaiamenti/config.dart';
import 'package:smannaiamenti/pages/reader.dart';
import 'home.dart';

class Smannaiapp extends StatefulWidget {
  @override
  _SmannaiappState createState() => _SmannaiappState();
}

class _SmannaiappState extends State<Smannaiapp> {
  ThemeMode _themeMode = ThemeMode.system;
  final router = FluroRouter();

  void defineRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return ReaderPage("");
    });

    router.define(
      "/:page",
      handler: Handler(handlerFunc:
          (BuildContext? context, Map<String, List<String>> params) {
        var page = params["page"]?[0] ?? "";
        return ReaderPage(page);
      }),
      transitionDuration: Duration(seconds: 0),
    );
  }

  @override
  void initState() {
    super.initState();
    currentTheme.addListener(() {
      setState(() {
        _themeMode = currentTheme.themeMode();
      });
    });
    defineRoutes(router);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: router.generator,
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
