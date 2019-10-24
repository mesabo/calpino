import 'package:calpin/Utils.dart' as utils;
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'TasksDBWorker.dart';
import 'TasksModel.dart' show TaskModel, taskModel;

class TaskEntry extends StatelessWidget {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dueDateController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TaskEntry() {
    _descriptionController.addListener(() {
      taskModel.entityBeingEdited.description = _descriptionController.text;
    });
    _dueDateController.addListener(() {
      taskModel.entityBeingEdited.dueDate = _dueDateController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    /*nous voudrons nous assurer que les valeurs précédentes pour
    le titre et le contenu sont affichées à l'écran lors de l'édition.*/
    _descriptionController.text = taskModel.entityBeingEdited.description;
    _dueDateController.text = taskModel.entityBeingEdited.dueDate;

    return ScopedModel(
      model: taskModel,
      child: ScopedModelDescendant<TaskModel>(
        builder: (BuildContext inContext, Widget inChild, TaskModel inModel) {
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
                        _saveTask(inContext, taskModel);
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
                      maxLength: 200,
                      controller: _descriptionController,
                      decoration: InputDecoration(
                          labelText: "Description",
                          labelStyle: TextStyle(
                              fontFamily: "Mali",
                              color: Colors.indigo,
                              fontSize: 20,
                              fontWeight: FontWeight.w500)),
                      validator: (String inValue) {
                        if (inValue.length == 0) {
                          return "Entrer une description svp.";
                        }
                        return null;
                      },
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.today),
                    title: Text(
                      "Date de réalisation",
                      style: TextStyle(
                          fontFamily: "Mali",
                          color: Colors.indigo[400],
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                    subtitle: Text(
                      taskModel.chosenDate == null ? "" : taskModel.chosenDate,
                      style: TextStyle(
                          fontFamily: "Mali",
                          color: Colors.indigo[800],
                          fontSize: 22,
                          fontWeight: FontWeight.w500),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.select_all,
                        color: Colors.indigo,
                        size: 48.0,
                      ),
                      onPressed: () async {
                        String dateChosed = await utils.selectDate(inContext,
                            taskModel, taskModel.entityBeingEdited.dueDate);
                        if (dateChosed != null) {
                          taskModel.entityBeingEdited.dueDate = dateChosed;
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _saveTask(BuildContext inContext, TaskModel inModel) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    if (inModel.entityBeingEdited.id == null) {
      await TaskDBWorker.db.createTask(taskModel.entityBeingEdited);
    } else {
      await TaskDBWorker.db.updateTask(taskModel.entityBeingEdited);
    }

    taskModel.loadData("tasks", TaskDBWorker.db);
    inModel.setStackIndex(0);

    Scaffold.of(inContext).showSnackBar(SnackBar(
      content: Text("La tache a été ajoutée avec succès"),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.green,
    ));
  }
}
