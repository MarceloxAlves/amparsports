import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:amparsports/tiles/drawer_tile.dart';

class MDrawerVisitante extends StatelessWidget {


  MDrawerVisitante();


  @override
  Widget build(BuildContext context) {
    Widget _buildDrawerBack() => Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromARGB(255,8,57,98),
            Colors.blue[300]
          ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
          )
      ),
    );
    return Drawer(
      child: Stack(
        children: <Widget>[
          _buildDrawerBack(),
          ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 32, bottom: 16),
                child: FutureBuilder<FirebaseUser>(
                  future: FirebaseAuth.instance.currentUser(),
                  builder: (context, snapshot) {
                    if(!snapshot.hasData){
                      return Center(child: Text("Olá Visitante",
                        style: TextStyle(
                            fontSize: 24,
                            color: Colors.white
                        ),
                      )
                      );
                    }
                    return ListBody(
                      children: <Widget>[
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                                radius: 50.0,
                                backgroundColor: Colors.white,
                                backgroundImage: snapshot.data.photoUrl == null ?
                                NetworkImage("https://upload.wikimedia.org/wikipedia/commons/thumb/6/6e/Breezeicons-actions-22-im-user.svg/768px-Breezeicons-actions-22-im-user.svg.png") :
                                NetworkImage(snapshot.data.photoUrl)
                            ),
                          ),
                        ),
                        snapshot.data.displayName == null ? Text(' '): Text(snapshot.data.displayName,
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                              color: Colors.white
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Icon(Icons.mail, color: Colors.white,),
                              ),
                              Text(snapshot.data.email,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
              Divider(),
              Container(
                child: ListBody(
                    children: <Widget> [
                      DrawerTile(Icons.home, "Início","inicio_visitante"),
                      DrawerTile(Icons.grid_on, "Classificação","classificacao"),
                      DrawerTile(Icons.blur_circular, "Tabela de Jogos","tabela"),
                      DrawerTile(Icons.check, "+ Disciplinado","disciplinado"),
                    ]
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
