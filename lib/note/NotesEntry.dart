import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'NotesDBWorker.dart';
import 'NotesModel.dart' show NoteModel, noteModel;

class NoteEntry extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  NoteEntry() {
    _titleController.addListener(() {
      noteModel.entityBeingEdited.title = _titleController.text;
    });
    _contentController.addListener(() {
      noteModel.entityBeingEdited.content = _contentController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    /*nous voudrons nous assurer que les valeurs précédentes pour
    le titre et le contenu sont affichées à l'écran lors de l'édition.*/
    _titleController.text = noteModel.entityBeingEdited.title;
    _contentController.text = noteModel.entityBeingEdited.content;

    return ScopedModel(
      model: noteModel,
      child: ScopedModelDescendant<NoteModel>(
        builder: (BuildContext inContext, Widget inChild, NoteModel inModel) {
          return Scaffold(
            bottomNavigationBar: Padding(
              padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              child: Row(
                children: <Widget>[
                  FlatButton(
                      onPressed: () {
                        FocusScope.of(inContext).requestFocus(FocusNode());
                        inModel.setStackIndex(0);
                      },
                      child: Text("Quitter")),
                  Spacer(),
                  FlatButton(
                      onPressed: () {
                        _saveNote(inContext, noteModel);
                      },
                      child: Text("Enregistrer")),
                ],
              ),
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.title),
                    title: TextFormField(
                      maxLength: 25,
                      controller: _titleController,
                      decoration: InputDecoration(
                          labelText: "Titre",
                          labelStyle: TextStyle(
                              fontFamily: "Mali",
                              color: Colors.indigo,
                              fontSize: 22,
                              fontWeight: FontWeight.w500)),
                      validator: (String inValue) {
                        if (inValue.length == 0) {
                          return "Entrer un titre svp.";
                        } else if (inValue.length < 4) {
                          return "Titre d'au moins 4 caractères";
                        }
                        return null;
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.content_paste),
                    title: TextFormField(
                      maxLines: 5,
                      maxLength: 500,
                      //textCapitalization: TextCapitalization.sentences,
                      autocorrect: true,
                      controller: _contentController,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                            fontFamily: "Mali",
                            color: Colors.indigo,
                            fontSize: 20),
                        labelText: "Contenu de la note",
                      ),
                      validator: (String inValue) {
                        if (inValue.length == 0) {
                          return "Entrer votre contenu svp.";
                        }
                        return null;
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.color_lens),
                    title: Row(
                      children: <Widget>[
                        //Blue
                        GestureDetector(
                            child: Container(
                              decoration: ShapeDecoration(
                                  shape: Border.all(
                                          width: 16, color: Colors.blue) +
                                      Border.all(
                                          width: 6,
                                          color: noteModel.color == "blue"
                                              ? Colors.blue
                                              : Theme.of(inContext)
                                                  .canvasColor)),
                            ),
                            onTap: () {
                              noteModel.entityBeingEdited.color = "blue";
                              noteModel.setColor("blue");
                            }),
                        Spacer(),
                        //Green
                        GestureDetector(
                            child: Container(
                              decoration: ShapeDecoration(
                                  shape: Border.all(
                                          width: 16, color: Colors.green) +
                                      Border.all(
                                          width: 6,
                                          color: noteModel.color == "green"
                                              ? Colors.green
                                              : Theme.of(inContext)
                                                  .canvasColor)),
                            ),
                            onTap: () {
                              noteModel.entityBeingEdited.color = "green";
                              noteModel.setColor("green");
                            }),
                        Spacer(),
                        //purple
                        GestureDetector(
                            child: Container(
                              decoration: ShapeDecoration(
                                  shape: Border.all(
                                          width: 16, color: Colors.purple) +
                                      Border.all(
                                          width: 6,
                                          color: noteModel.color == "purple"
                                              ? Colors.purple
                                              : Theme.of(inContext)
                                                  .canvasColor)),
                            ),
                            onTap: () {
                              noteModel.entityBeingEdited.color = "purple";
                              noteModel.setColor("purple");
                            }),
                        Spacer(),
                        //Grey
                        GestureDetector(
                            child: Container(
                              decoration: ShapeDecoration(
                                  shape: Border.all(
                                          width: 16, color: Colors.grey) +
                                      Border.all(
                                          width: 6,
                                          color: noteModel.color == "grey"
                                              ? Colors.grey
                                              : Theme.of(inContext)
                                                  .canvasColor)),
                            ),
                            onTap: () {
                              noteModel.entityBeingEdited.color = "grey";
                              noteModel.setColor("grey");
                            }),
                        Spacer(),
                        //Amber
                        GestureDetector(
                            child: Container(
                              decoration: ShapeDecoration(
                                  shape: Border.all(
                                          width: 16, color: Colors.amber) +
                                      Border.all(
                                          width: 6,
                                          color: noteModel.color == "amber"
                                              ? Colors.amber
                                              : Theme.of(inContext)
                                                  .canvasColor)),
                            ),
                            onTap: () {
                              noteModel.entityBeingEdited.color = "amber";
                              noteModel.setColor("amber");
                            }),
                        Spacer(),
                        //Red
                        GestureDetector(
                            child: Container(
                              decoration: ShapeDecoration(
                                  shape:
                                      Border.all(width: 16, color: Colors.red) +
                                          Border.all(
                                              width: 6,
                                              color: noteModel.color == "red"
                                                  ? Colors.red
                                                  : Theme.of(inContext)
                                                      .canvasColor)),
                            ),
                            onTap: () {
                              noteModel.entityBeingEdited.color = "red";
                              noteModel.setColor("red");
                            }),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _saveNote(BuildContext inContext, NoteModel inModel) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    if (inModel.entityBeingEdited.id == null) {
      await NoteDBWorker.db.createNote(noteModel.entityBeingEdited);
    } else {
      await NoteDBWorker.db.updateNote(noteModel.entityBeingEdited);
    }

    noteModel.loadData("notes", NoteDBWorker.db);
    inModel.setStackIndex(0);

    Scaffold.of(inContext).showSnackBar(SnackBar(
      content: Text("La note a été ajoutée avec succès"),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.green,
    ));
  }
}
