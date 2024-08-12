class Note {
  String title;
  String content;
  int id;

  Note({required this.title, required this.content, required this.id});

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "content": content,
      "id": id,
    };
  }

  static Note fromMap(Map<String, dynamic> map) {
    print(map);
    return Note(title: map["TITLE"]!, content: map["CONTENT"]!, id: map["ID"]);
  }
}
