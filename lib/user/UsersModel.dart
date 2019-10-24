import 'package:calpin/BaseModel.dart';

class User {
  int id;
  String name;
  String email;
  String phone;

  String toString() {
    return "{id=$id, name=$name, email=$email, phone=$phone}";
  }
}

class UserModel extends BaseModel {
  void triggerRebuild() {
    notifyListeners();
  }
}

UserModel userModel = UserModel();
