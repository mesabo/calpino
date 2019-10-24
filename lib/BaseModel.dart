import 'package:scoped_model/scoped_model.dart';

class BaseModel extends Model {
  int stackIndex = 0;
  List entityList = [];
  String chosenDate;
  var entityBeingEdited;

  /*@chosenDate
  * fonction qui donne la date choisie*/
  void setChosenDte(String inDate) {
    chosenDate = inDate;
    notifyListeners();
  }

  /*@loadData
  * methode appelée à chaque fois qu'on ajoute ou supprime
  * une donnée dans la bd.
  * Elle actualise la vue*/
  void loadData(String entityType, dynamic inDatabase) async {
    entityList = await inDatabase.getAll();
    notifyListeners();
  }

  /*@setStackIndex
  * methode appelée à chaque fois que noous voulons naviguer
  * entre les écran de liste et de saisie pour une entité donné.*/
  void setStackIndex(int inStackIndex) {
    stackIndex = inStackIndex;
    notifyListeners();
  }
}
