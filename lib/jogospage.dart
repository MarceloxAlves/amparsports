import 'package:amparsports/jogodatapage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'model/tdata.dart';

class JogosPage extends StatefulWidget {
  final DocumentSnapshot torneio;
  final DocumentSnapshot delegado;

  const JogosPage({Key key, this.torneio, this.delegado}) : super(key: key);

  @override
  _JogosPageState createState() => _JogosPageState();
}

class _JogosPageState extends State<JogosPage> {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageController _pageController = new PageController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey, body: JogosList(torneio: widget.torneio, delegado: widget.delegado));
  }
}

class JogosList extends StatefulWidget {
  final DocumentSnapshot torneio;
  final DocumentSnapshot delegado;

  const JogosList({Key key, this.torneio, this.delegado}) : super(key: key);

  @override
  _JogoListState createState() => _JogoListState();
}

class _JogoListState extends State<JogosList> {
  @override
  void initState() {
    super.initState();
  }

  Future<dynamic> _timData(String time) async {
    DocumentSnapshot dtime;
    await Firestore.instance
        .collection("times")
        .where("timid", isEqualTo: time)
        .getDocuments()
        .then((doc) {
          dtime =  doc.documents.first;
    });

    return dtime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
          padding: const EdgeInsets.all(10.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('torneios')
                .document(widget.torneio.documentID)
                .collection('jogos')
                .where('jogrodada', isEqualTo: widget.torneio.data["torrodada"])
                .where('jogfase', isEqualTo: widget.torneio.data["jogfase"])
                .where('jogtime1', isEqualTo: widget.delegado.data["timid"])
                .orderBy("jogdata", descending: true)
            .limit(1)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              if (snapshot.hasData) {
                return new ListView(
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    return FutureBuilder(
                        future: _timData(document.data["jogtime1"]),
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> timeCasa) {
                          return Center(
                            child: timeCasa.hasData ?
                             FutureBuilder(
                                future: _timData(document.data["jogtime2"]),
                                builder: (BuildContext context,
                                AsyncSnapshot<dynamic> timeFora) {
                                  return timeFora.hasData ?
                                 new CustomCard(
                                   document: document,
                                   idJogo: document.documentID,
                                   idTorneio: widget.torneio.documentID,
                                   timecasa: timeCasa,
                                   timefora: timeFora): new CircularProgressIndicator();
                                }
                            ) : new CircularProgressIndicator(),
                          );
                        });
                  }).toList(),
                );
              } else {
                return new CircularProgressIndicator();
              }
            },
          )),
    ));
  }
}

class CustomCard extends StatelessWidget {
  CustomCard({@required this.document, this.idJogo, this.idTorneio, this.timecasa, this.timefora});

  final document;
  final idJogo;
  final idTorneio;
  final timecasa;
  final timefora;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: Card(
          margin: EdgeInsets.all(8.0),
          child: Container(
              height: 140,
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(8.0),
                        child: Text(TDate.date_br(document["jogdata"]),
                            style: TextStyle(
                              color: Colors.black38,
                            )),
                      ),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(timecasa?.data["timnome"]),
                        ),
                        flex: 4,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Container(
                              height: 80,
                              child: Image.network(
                                timecasa?.data["timescudo"] ?? "",
                                scale: 0.5,
                              ),
                            ),
                          ),
                        ),
                        flex: 2,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(" X "),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                              child: Container(
                                  height: 80,
                                  child: Image.network(
                                      timefora?.data["timescudo"] ?? ""))),
                        ),
                        flex: 2,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(timefora?.data["timnome"]),
                        ),
                        flex: 4,
                      ),
                    ],
                  ),
                ],
              ))),
      onTap: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) =>
                    new JogosDataPage(jogo: document, torneio: idTorneio)));
      },
    );
  }
}
