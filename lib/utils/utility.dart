import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utility {
  static int _uniqueIdStepper = 0;

  static String getNextId({String? prefix}) {
    int id = _uniqueIdStepper++;
    return '$prefix $id';
  }
}

enum DashboardBottomTab { home, accounts, settings }

DashboardBottomTab getDashboardBottomTabByIndex(int index) {
  switch (index) {
    case 0:
      return DashboardBottomTab.home;
    case 1:
      return DashboardBottomTab.accounts;
    case 2:
      return DashboardBottomTab.settings;
  }

  return DashboardBottomTab.home;
}

void showToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.black87,
      textColor: Colors.lightGreenAccent,
      fontSize: 22.0);
}

void showAlertDialog(BuildContext context,
    {required List<TextButton> buttons,
    required String title,
    String? content}) {
  var exampleButton = TextButton(
    child: Text("Remind me later"),
    onPressed: () {},
  );

  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(content ?? ''),
    actions: buttons,
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
