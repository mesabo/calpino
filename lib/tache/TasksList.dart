import 'package:calpin/tache/TasksDBWorker.dart';
import 'package:calpin/tache/TasksModel.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:scoped_model/scoped_model.dart';

import 'TasksModel.dart' show Task, TaskModel, taskModel;

class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
        model: taskModel,
        child: ScopedModelDescendant<TaskModel>(
          builder: (BuildContext inContext, Widget inChild, TaskModel inModel) {
            return Scaffold(
                floatingActionButton: FloatingActionButton(
                  backgroundColor: Colors.grey,
                  onPressed: () {
                    taskModel.entityBeingEdited = Task();
                    taskModel
                        .setStackIndex(1); //index 1 renvoie la page d'édition
                  },
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
                body: ListView.builder(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    itemCount: taskModel.entityList.length,
                    itemBuilder: (BuildContext inBuildContext, int inInDex) {
                      Task task = taskModel.entityList[inInDex];
                      String sDueDate;

                      if (task.dueDate != null) {
                        List datePart = task.dueDate.split(",");
                        DateTime dueDate = DateTime(int.parse(datePart[0]),
                            int.parse(datePart[1]), int.parse(datePart[2]));
                        sDueDate =
                            DateFormat.yMMMd("en_US").format(dueDate.toLocal());
                      }

                      return Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: .25,
                        child: Card(
                          elevation: 8,
                          child: ListTile(
                            leading: CircularCheckBox(
                                inactiveColor: Colors.cyan,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.padded,
                                activeColor: Colors.green,
                                value: task.completed == "true" ? true : false,
                                onChanged: (inValue) async {
                                  task.completed = inValue.toString();
                                  await TaskDBWorker.db.updateTask(task);
                                  taskModel.loadData("tasks", TaskDBWorker.db);
                                }),
                            title: Text(
                              "${task.description}",
                              style: task.completed == "true"
                                  ? TextStyle(
                                      color: Theme.of(inContext).disabledColor,
                                      decoration: TextDecoration.lineThrough)
                                  : TextStyle(
                                      fontFamily: 'Mali',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(inContext)
                                          .textTheme
                                          .title
                                          .color),
                            ),
                            subtitle: Text("${task.dueDate}"),
                          ),
                        ),
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            caption: "Supprimer",
                            color: Colors.red,
                            icon: Icons.delete,
                            onTap: () {
                              _deleteTask(inContext, task);
                            },
                          ),
                          IconSlideAction(
                              caption: "Editer",
                              color: Colors.green,
                              icon: Icons.update,
                              onTap: () async {
                                taskModel.entityBeingEdited =
                                    await TaskDBWorker.db.getTask(task.id);
                                taskModel.setStackIndex(1);
                              }),
                        ],
                      );
                    }));
          },
        ));
  }

  Future _deleteTask(BuildContext inContext, Task task) {
    int couper(String txtLeng) {
      int taille;
      if (txtLeng.length < 8) {
        txtLeng = txtLeng.padRight(8, "");
        taille = txtLeng.length;
      }
      if (txtLeng.length > 8) {
        txtLeng = txtLeng.substring(0, 8);
        taille = txtLeng.length;
      } else {
        taille = txtLeng.length;
      }

      return taille;
    }

    return Alert(
      context: inContext,
      type: AlertType.warning,
      title: "SUPPRESSION",
      content: Text(
        "${task.description.substring(0, couper(task.description))}....",
        style: TextStyle(
            color: Colors.black,
            decoration: TextDecoration.overline,
            fontSize: 24,
            fontFamily: 'Mali',
            fontStyle: FontStyle.italic),
      ),
      desc: "Etes-vous sur de vouloir supprimer cette task?",
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
            await TaskDBWorker.db.deleteTask(task.id);
            Navigator.of(inContext).pop();
            Scaffold.of(inContext).showSnackBar(SnackBar(
              content: Text("Tache supprimée avec succès."),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ));
            taskModel.loadData("tasks", TaskDBWorker.db);
          },
          color: Color.fromRGBO(200, 25, 10, 1.0),
        )
      ],
    ).show();
  }
}
