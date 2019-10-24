import 'package:calpin/BaseModel.dart';

class Note {
  int id;
  String title;
  String content;
  String color;

  String toString() {
    return "{id=$id, title=$title, content=$content, color=$color}";
  }
}

class NoteModel extends BaseModel {
  String color;

  // Ici nous passons une @couleur à la note.
  void setColor(String inColor) {
    color = inColor;
    notifyListeners();
  }
}

NoteModel noteModel = NoteModel();
