import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
class DrawerTile extends StatelessWidget {

  final IconData icon;
  final String text;
  final String id;

  GoogleSignIn _googleSignIn = GoogleSignIn();

  DrawerTile(this.icon, this.text, this.id);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        highlightColor: Colors.blue[200],
        onTap: (){
            Navigator.of(context).pop();
            if (id == "inicio"){
              Navigator.of(context).pushReplacementNamed('/userpage');
            }
            if (id == "sair"){
                  _googleSignIn.signOut();
                FirebaseAuth.instance.signOut().then((action) {
                  Navigator.of(context)
                      .pushReplacementNamed('/loginpage');
                }).catchError((e) {
                  print(e);
                });
              Navigator.of(context).pushReplacementNamed('/loginpage');
            }
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 32),
          child: Container(
            height: 60.0,
            child: Row(
              children: <Widget>[
                Icon(
                    icon,
                    size: 32.0,
                    color: Colors.white,
                ),
                SizedBox(width: 32,),
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
