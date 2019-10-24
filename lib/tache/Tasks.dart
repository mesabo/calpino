import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'TasksDBWorker.dart';
import 'TasksEntry.dart';
import 'TasksList.dart';
import 'TasksModel.dart' show TaskModel, taskModel;

class Task extends StatelessWidget {
  Task() {
    taskModel.loadData("tasks", TaskDBWorker.db);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
        model: taskModel,
        child: ScopedModelDescendant<TaskModel>(
          builder: (BuildContext inContext, Widget inChild, TaskModel inModel) {
            return IndexedStack(
              index: inModel.stackIndex,
              children: <Widget>[TaskList(), TaskEntry()],
            );
          },
        ));
  }
}
