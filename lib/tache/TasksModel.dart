import 'package:calpin/BaseModel.dart';

class Task {
  int id;
  String description;
  String dueDate;
  String completed;

  String toString() {
    return "{id=$id, description=$description, dueDate=$dueDate, completed=$completed}";
  }
}

class TaskModel extends BaseModel {}

TaskModel taskModel = TaskModel();
