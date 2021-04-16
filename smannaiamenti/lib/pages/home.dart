import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:smannaiamenti/models/library.dart';
import 'package:smannaiamenti/pages/reader.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Library library = Library();
  Book? clickedBook;

  @override
  void initState() {
    _loadLibrary();
    super.initState();
  }

  void _loadLibrary() async {
    var s = await rootBundle.loadString("md/content.json");
    setState(() {
      library = Library.fromJson(jsonDecode(s));
    });
  }

  void _loadMd(int index) async {
    var file = library.books.first.sections[index].file;
    var markdownContent = await rootBundle.loadString("md/$file.md");

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
    var size = MediaQuery.of(context).size;
    var width = size.width;

    Widget _buildBookButton(int index) {
      Book book = library.books[index];
      return Card(
        margin: EdgeInsets.fromLTRB(4, 4, 32, 4),
        child: ListTile(
          leading: Icon(Icons.menu_book_rounded),
          title: Text(book.title),
          subtitle: Text(
            book.subtitle,
            maxLines: 2,
          ),
          onTap: () =>
              setState(() => clickedBook = clickedBook == book ? null : book),
        ),
      );
    }

    Widget _buildSectionButton(Book book, int index) {
      Section section = book.sections[index];
      return Card(
        margin: EdgeInsets.fromLTRB(56, 4, 4, 4),
        child: ListTile(
          leading: Icon(Icons.radio_button_checked_outlined),
          title: Text(section.title),
          subtitle: Text(
            DateFormat.yMMMd().format(section.date),
            maxLines: 1,
          ),
          onTap: () => _loadMd(index),
        ),
      );
    }

    Widget _buildBooksWithSections() {
      int bookIndex = library.books.indexOf(clickedBook!);
      int sectionsCount = clickedBook!.sections.length;
      return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: library.books.length + sectionsCount,
        itemBuilder: (_, int index) {
          if (index <= bookIndex)
            return _buildBookButton(index);
          else if (index > bookIndex && index <= bookIndex + sectionsCount)
            return _buildSectionButton(clickedBook!, index - bookIndex - 1);
          else
            return _buildBookButton(index - sectionsCount);
        },
      );
    }

    Widget _buildBooksWithoutSections() {
      return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: library.books.length,
        itemBuilder: (_, int index) {
          return _buildBookButton(index);
        },
      );
    }

    Widget _buildListView() {
      if (clickedBook != null)
        return _buildBooksWithSections();
      else
        return _buildBooksWithoutSections();
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Image.asset(
              "web/icons/Icon-200.png",
              height: 100,
            ),
            Text("Smannaiamenti.it"),
          ],
        ),
      ),
      body: SafeArea(
        child: Row(
          children: <Widget>[
            Container(
              width: min(width, max(480, width * 0.4)),
              child: _buildListView(),
            )
          ],
        ),
      ),
    );
  }
}
