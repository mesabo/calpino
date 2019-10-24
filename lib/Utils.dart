import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/rounded_date_picker.dart';
import 'package:intl/intl.dart';

import 'BaseModel.dart';

Directory docsDir;

/*@selectDate
*Une date est requise pour une tache ou évènement donné
* , alors elle est soit la date ou l'heure actuelle ou choisien par l'utilisateur.*/

Future selectDate(
    BuildContext inContext, BaseModel inModel, String inDateString) async {
  DateTime intitialDate = DateTime.now(); //Date par @défaut: date actuelle

  if (inDateString != null) {
    List datePart = inDateString.split(",");
    intitialDate = DateTime(
        int.parse(datePart[0]), int.parse(datePart[1]), int.parse(datePart[2]));
  }

  DateTime datePicked = await RoundedDatePicker.show(inContext,
      fontFamily: 'Mali',
      initialDate: intitialDate,
      firstDate: DateTime(2018),
      lastDate: DateTime(2100),
      background: Colors.white,
      theme: ThemeData(
          primaryColor: Colors.red[400],
          accentColor: Colors.green[800],
          dialogBackgroundColor: Colors.purple[50],
          textTheme: TextTheme(
              body1: TextStyle(color: Colors.red),
              caption: TextStyle(color: Colors.blue)),
          disabledColor: Colors.orange,
          accentTextTheme:
              TextTheme(body2: TextStyle(color: Colors.green[200]))));
  if (datePicked != null) {
    inModel
        .setChosenDte(DateFormat.yMMMd("en_US").format(datePicked.toLocal()));
    return "${datePicked.day},${datePicked.month},${datePicked.year}";
  }
}
