import 'package:amparsports/drawer.dart';
import 'package:amparsports/jogodatapage.dart';
import 'package:amparsports/popup_menu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:toast/toast.dart';

class JogosPage extends StatefulWidget {

  final String torneioID;

  const JogosPage({Key key, this.torneioID}): super(key: key);


  @override
  _JogosPageState createState() => _JogosPageState();
}


class _JogosPageState extends State<JogosPage> {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageController _pageController  = new PageController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      body: JogosList(torneioID: widget.torneioID)
    );
  }
}



class JogosList extends StatefulWidget {
  final String torneioID;

  const JogosList({Key key, this.torneioID}): super(key: key);

  @override
  _JogoListState createState() => _JogoListState();
}

class _JogoListState extends State<JogosList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Container(
              padding: const EdgeInsets.all(10.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('torneios').document(widget.torneioID).collection('jogos').snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                   if (snapshot.hasData) {
                     return new ListView(
                       children: snapshot.data.documents
                           .map((DocumentSnapshot document) {
                         return new CustomCard(
                           document: document,
                           idJogo: document.documentID,
                           idTorneio: widget.torneioID,
                         );
                       }).toList(),
                     );
                   }else{
                     return new CircularProgressIndicator();
                   }
                },
              )),
        )
    );
  }
}

class CustomCard extends StatelessWidget {
  CustomCard({@required this.document, this.idJogo, this.idTorneio});

  final document;
  final idJogo;
  final idTorneio;


  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: Card(
          child: Container(
             height: 100,
              padding: const EdgeInsets.only(top: 5.0),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(8.0),
                    width: 100,
                    child:  Text(document["time_casa"]["nome"]),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    width: 50,
                    child:  Image.network(
                       document["time_casa"]["escudo"],
                       scale: 0.5,
                    ),
                  ),
                  Container(
                    width: 30,
                    padding: EdgeInsets.all(0.0),
                    child:  Text(" X "),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.0),
                    width: 50,
                    child:  Image.network(document["time_fora"]["escudo"]),
                  ),
                  Container(
                    width: 100,
                    padding: EdgeInsets.all(8.0),
                    child:  Text(document["time_fora"]["nome"]),
                  ),
                ],
              ))),
      onTap: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new JogosDataPage(jogo: document, torneio: idTorneio )));
      },
    );
  }
}
