import 'package:calpin/user/UsersDBWorker.dart';
import 'package:calpin/user/UsersModel.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:scoped_model/scoped_model.dart';

import 'UsersModel.dart' show User, UserModel, userModel;

class UserList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModel(
        model: userModel,
        child: ScopedModelDescendant<UserModel>(
          builder: (BuildContext inContext, Widget inChild, UserModel inModel) {
            User user = userModel.entityList[0];
            return Scaffold(
                bottomNavigationBar: Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  child: FlatButton(
                      onPressed: () async {
                        userModel.entityBeingEdited =
                            await UserDBWorker.db.getUser(user.id);
                        userModel.setStackIndex(1);
                      },
                      child: Text("Mise à jour")),
                ),
                body: Container(
                  child: Card(
                    child: ListView(
                      children: <Widget>[
                        ListTile(
                          contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          title: Text(
                            user.name.isEmpty
                                ? "Pas de nom inscrit"
                                : "${user.name}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            user.email.isEmpty
                                ? "Pas d'email ?"
                                : "${user.email}",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        ListTile(
                          title: Text(
                            user.phone.isEmpty
                                ? "Pas de téléphone ?"
                                : "${user.phone}",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                  ),
                ));
          },
        ));
  }

  Future _deleteUser(BuildContext inContext, User user) {
    return Alert(
      context: inContext,
      type: AlertType.warning,
      title: "SUPPRESSION",
      content: Text(
        "${user.name}",
        style: TextStyle(
            color: Colors.black,
            decoration: TextDecoration.overline,
            fontSize: 24,
            fontFamily: 'Mali',
            fontStyle: FontStyle.italic),
      ),
      desc: "Etes-vous sur de vouloir supprimer cette user?",
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
            await UserDBWorker.db.deleteUser(user.id);
            Navigator.of(inContext).pop();
            Scaffold.of(inContext).showSnackBar(SnackBar(
              content: Text("Tache supprimée avec succès."),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ));
            userModel.loadData("users", UserDBWorker.db);
          },
          color: Color.fromRGBO(200, 25, 10, 1.0),
        )
      ],
    ).show();
  }
}
