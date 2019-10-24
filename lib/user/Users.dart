import 'package:calpin/user/UsersEntry.dart';
import 'package:calpin/user/UsersList.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'UsersDBWorker.dart';
import 'UsersModel.dart' show UserModel, userModel;

class User extends StatelessWidget {
  User() {
    userModel.loadData("users", UserDBWorker.db);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
        model: userModel,
        child: ScopedModelDescendant<UserModel>(
          builder: (BuildContext inContext, Widget inChild, UserModel inModel) {
            return IndexedStack(
              index: inModel.stackIndex,
              children: <Widget>[UserList(), UserEntry()],
            );
          },
        ));
  }
}
