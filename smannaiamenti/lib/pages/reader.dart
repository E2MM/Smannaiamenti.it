import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/services.dart';
import 'package:smannaiamenti/components/smannaiappbar.dart';

class ReaderPage extends StatefulWidget {
  final String page;

  ReaderPage(this.page);

  @override
  _ReaderPageState createState() => _ReaderPageState(page);
}

class _ReaderPageState extends State<ReaderPage> {
  late final Future<String> markdownContentFuture;
  late final String markdownContent;
  final String page;

  _ReaderPageState(this.page);

  @override
  initState() {
    markdownContentFuture = rootBundle.loadString("wiki/$page.md");
    markdownContentFuture.then((value) {
      markdownContent = value;
      this.setState(() {});
    });
    super.initState();
  }

  void _goToLink(String text, String? href, String title) async {
    Navigator.push(
      context,
      PageRouteBuilder(
        settings: RouteSettings(name: "/$href"),
        pageBuilder: (context, animation1, animation2) =>
            ReaderPage(href ?? ""),
        transitionDuration: Duration(seconds: 0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SmannaiappBar(),
      body: SafeArea(
        child: Container(
          child: FutureBuilder(
            future: markdownContentFuture,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Markdown(data: "Loading");
              } else if (snapshot.hasError)
                return Markdown(data: "404 Not Found");
              else
                return Markdown(
                  data: markdownContent,
                  onTapLink: _goToLink,
                );
            },
          ),
        ),
      ),
    );
  }
}
