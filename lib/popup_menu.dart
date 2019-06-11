import 'package:flutter/material.dart';

class MPopupMenu {
  MPopupMenu({this.title, this.icon});
  String title;
  IconData icon;

}

class SelectedOption extends StatelessWidget {
  MPopupMenu choice;

  SelectedOption({Key key, this.choice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(choice.icon, size: 140.0, color: Colors.white),
            Text(
              choice.title,
              style: TextStyle(color: Colors.white, fontSize: 30),
            )
          ],
        ),
      ),
    );
  }
}