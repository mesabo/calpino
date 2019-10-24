import 'dart:io';

import 'package:calpin/tache/Tasks.dart';
import 'package:calpin/user/Users.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shifting_tabbar/shifting_tabbar.dart';

import 'Utils.dart' as utils;
import 'note/Notes.dart';

void main() {
  startMeUp() async {
    Directory docsDir = await getApplicationDocumentsDirectory();
    utils.docsDir = docsDir;

    runApp(FlutterCalpin());
  }

  startMeUp();
}

class FlutterCalpin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: ShiftingTabBar(
            color: Colors.grey,
            forceUpperCase: false,
            brightness: Brightness.dark,
            tabs: [
              ShiftingTab(icon: Icon(Icons.note), text: "Notes"),
              ShiftingTab(
                  icon: Icon(Icons.assignment_turned_in), text: "Taches"),
              ShiftingTab(icon: Icon(Icons.contact_mail), text: "Contacts"),
            ],
          ),
          body: TabBarView(
            children: [Note(), Task(), User()],
          ),
        ),
      ),
    );
  }
}
