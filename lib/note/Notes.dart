import 'package:calpin/note/NotesEntry.dart';
import 'package:calpin/note/NotesList.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'NotesDBWorker.dart';
import 'NotesModel.dart' show NoteModel, noteModel;

class Note extends StatelessWidget {
  Note() {
    noteModel.loadData("notes", NoteDBWorker.db);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
        model: noteModel,
        child: ScopedModelDescendant<NoteModel>(
          builder: (BuildContext inContext, Widget inChild, NoteModel inModel) {
            return IndexedStack(
              index: inModel.stackIndex,
              children: <Widget>[NoteList(), NoteEntry()],
            );
          },
        ));
  }
}
