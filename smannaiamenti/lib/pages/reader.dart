import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/services.dart';
import 'package:smannaiamenti/components/smannaiappbar.dart';

class ReaderPage extends StatefulWidget {
  final String markdownContent;

  ReaderPage(this.markdownContent);

  @override
  _ReaderPageState createState() => _ReaderPageState(markdownContent);
}

class _ReaderPageState extends State<ReaderPage> {
  final String markdownContent;

  _ReaderPageState(this.markdownContent);

  void _goToLink(String text, String? href, String title) async {
    var markdownContent = await rootBundle.loadString("wiki/$href.md");

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) =>
            ReaderPage(markdownContent),
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
          child: Markdown(
            data: markdownContent,
            onTapLink: _goToLink,
          ),
        ),
      ),
    );
  }
}
