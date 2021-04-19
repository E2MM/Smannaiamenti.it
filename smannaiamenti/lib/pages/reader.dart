import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class ReaderPage extends StatefulWidget {
  final String markdownContent;

  ReaderPage(this.markdownContent);

  @override
  _ReaderPageState createState() => _ReaderPageState(markdownContent);
}

class _ReaderPageState extends State<ReaderPage> {
  final String markdownContent;

  _ReaderPageState(this.markdownContent);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("smannaiamenti.it"),
      ),
      body: SafeArea(
        child: Container(
          child: Markdown(
            data: markdownContent,
          ),
        ),
      ),
    );
  }
}
