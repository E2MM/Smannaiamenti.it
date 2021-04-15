class Library {
  List<Book> books = <Book>[];

  Library({this.books = const <Book>[]});

  Library.fromJson(Map<String, dynamic> json) {
    if (json['books'] != null) {
      books = <Book>[];
      json['books'].forEach((v) {
        books.add(new Book.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['books'] = this.books.map((v) => v.toJson()).toList();
    return data;
  }
}

class Book {
  String title = "";
  String subtitle = "";
  List<Section> sections = <Section>[];

  Book({
    this.title = "",
    this.subtitle = "",
    this.sections = const <Section>[],
  });

  Book.fromJson(Map<String, dynamic> json) {
    title = json['title'] ?? "";
    subtitle = json['subtitle'] ?? "";
    if (json['sections'] != null) {
      json['sections'].forEach((v) {
        sections.add(new Section.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = this.title;
    data['sections'] = this.sections.map((v) => v.toJson()).toList();
    return data;
  }
}

class Section {
  String title = "";
  String file = "";

  Section({this.title = "", this.file = ""});

  Section.fromJson(Map<String, dynamic> json) {
    title = json['title'] ?? "";
    file = json['file'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = this.title;
    data['file'] = this.file;
    return data;
  }
}
