import 'package:card_settings/card_settings.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'UsersDBWorker.dart';
import 'UsersModel.dart' show UserModel, userModel;

class UserEntry extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  UserEntry() {
    _nameController.addListener(() {
      userModel.entityBeingEdited.name = _nameController.text;
    });
    _emailController.addListener(() {
      userModel.entityBeingEdited.email = _emailController.text;
    });
    _phoneController.addListener(() {
      userModel.entityBeingEdited.phone = _phoneController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    /*nous voudrons nous assurer que les valeurs précédentes pour
    le titre et le contenu sont affichées à l'écran lors de l'édition.*/
    _nameController.text = userModel.entityBeingEdited.name;
    _emailController.text = userModel.entityBeingEdited.email;
    _phoneController.text = userModel.entityBeingEdited.phone;

    return ScopedModel(
      model: userModel,
      child: ScopedModelDescendant<UserModel>(
        builder: (BuildContext inContext, Widget inChild, UserModel inModel) {
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
                        _saveUser(inContext, userModel);
                      },
                      child: Text("Enregistrer")),
                ],
              ),
            ),
            body: Form(
                key: _formKey,
                child: CardSettings(
                  children: <Widget>[
                    CardSettingsHeader(
                      label: "Infos personnelles",
                      labelAlign: TextAlign.center,
                      color: Colors.indigoAccent,
                    ),
                    CardSettingsText(
                      controller: _nameController,
                      hintText: "Nom complet",
                      label: "Nom ",
                      icon: Icon(Icons.person),
                      keyboardType: TextInputType.text,
                      labelAlign: TextAlign.end,
                      numberOfLines: 1,
                      maxLength: 45,
                      style: TextStyle(
                        color: Colors.indigo,
                        fontFamily: 'Mali',
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                    ),
                    CardSettingsEmail(
                      keyboardType: TextInputType.emailAddress,
                      labelAlign: TextAlign.end,
                      label: "Email",
                      icon: Icon(Icons.email),
                      controller: _emailController,
                      style: TextStyle(
                        color: Colors.indigo,
                        fontFamily: 'Mali',
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                    ),
                    CardSettingsText(
                      keyboardType: TextInputType.phone,
                      labelAlign: TextAlign.end,
                      label: "Phone",
                      icon: Icon(Icons.phone_iphone),
                      controller: _phoneController,
                      style: TextStyle(
                        color: Colors.indigo,
                        fontFamily: 'Mali',
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                    )
                  ],
                )),
          );
        },
      ),
    );
  }

  void _saveUser(BuildContext inContext, UserModel inModel) async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    if (inModel.entityBeingEdited.id == null) {
      await UserDBWorker.db.createUser(userModel.entityBeingEdited);
    } else {
      await UserDBWorker.db.updateUser(userModel.entityBeingEdited);
    }

    userModel.loadData("users", UserDBWorker.db);
    inModel.setStackIndex(0);

    Scaffold.of(inContext).showSnackBar(SnackBar(
      content: Text("Votre compte a été mise à jour"),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.green,
    ));
  }
}
