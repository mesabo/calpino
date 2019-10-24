import 'package:calpin/note/NotesModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:scoped_model/scoped_model.dart';

import 'NotesDBWorker.dart';
import 'NotesModel.dart' show Note, NoteModel, noteModel;

class NoteList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
        model: noteModel,
        child: ScopedModelDescendant<NoteModel>(
          builder: (BuildContext inContext, Widget inChild, NoteModel inModel) {
            return Scaffold(
                floatingActionButton: FloatingActionButton(
                  backgroundColor: Colors.grey,
                  onPressed: () {
                    noteModel.entityBeingEdited = Note();
                    noteModel.setColor(null);
                    noteModel
                        .setStackIndex(1); //index 1 renvoie la page d'édition
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
                body: ListView.builder(
                    itemCount: noteModel.entityList.length,
                    itemBuilder: (BuildContext inBuildContext, int inInDex) {
                      Note note = noteModel.entityList[inInDex];
                      Color color = Colors.greenAccent;

                      switch (note.color) {
                        case "blue":
                          color = Colors.blue;
                          break;
                        case "green":
                          color = Colors.green;
                          break;
                        case "purple":
                          color = Colors.purple;
                          break;
                        case "grey":
                          color = Colors.grey;
                          break;
                        case "amber":
                          color = Colors.amber;
                          break;
                        case "red":
                          color = Colors.red;
                          break;
                      }

                      return Container(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                        child: Slidable(
                            actionExtentRatio: .30,
                            secondaryActions: <Widget>[
                              IconSlideAction(
                                caption: "Supprimer",
                                color: Colors.red,
                                icon: Icons.delete,
                                onTap: () {
                                  _deleteNote(inContext, note);
                                },
                              ),
                              IconSlideAction(
                                  caption: "Editer",
                                  color: Colors.green,
                                  icon: Icons.update,
                                  onTap: () async {
/*Ici, on n'a pas besoin de se fatiguer; on attribut juste le valeurs de la ta
                                  * à la valiable entityBeingEdited dans le modèle NoteModel.
                                  * Tout est dès lors présent dans les champs d'édition*/
                                    noteModel.entityBeingEdited =
                                        await NoteDBWorker.db.getNote(note.id);
                                    noteModel.setStackIndex(1);
                                  }),
                            ],
                            child: Card(
                                //@TODO
                                //Besoin d'un stack index pour aggrandir la note.
                                //DEMAIN SERA MEILLEUR .
                                color: color,
                                elevation: 8,
                                child: ExpansionTile(
                                  title: Text(
                                    "${note.title}",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: "Mali",
                                        fontSize: 18,
                                        color: Colors.black54,
                                        backgroundColor: Colors.black12),
                                  ),
                                  children: <Widget>[
                                    Text(
                                      "${note.content}",
                                      style: TextStyle(
                                        fontFamily: "Mali",
                                        fontSize: 24,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )
                                  ],
                                )),
                            actionPane: SlidableDrawerActionPane()),
                      );
                    }));
          },
        ));
  }

  Future _deleteNote(BuildContext inContext, Note note) {
    return Alert(
      context: inContext,
      type: AlertType.warning,
      title: "SUPPRESSION",
      desc: "Etes-vous sur de vouloir supprimer cette note?\n ${note.title} ",
      buttons: [
        DialogButton(
          child: Text(
            "Annuler",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(inContext),
          color: Color.fromRGBO(0, 179, 134, 1.0),
        ),
        DialogButton(
          child: Text(
            "supprimer",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () async {
            await NoteDBWorker.db.deleteNote(note.id);
            Navigator.of(inContext).pop();
            Scaffold.of(inContext).showSnackBar(SnackBar(
              content: Text("Note supprimée avec succès."),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ));
            noteModel.loadData("notes", NoteDBWorker.db);
          },
          color: Color.fromRGBO(200, 25, 10, 1.0),
        )
      ],
    ).show();
  }
}
