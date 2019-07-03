import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'model/tdata.dart';

class JogoViewPage extends StatefulWidget {
  final String jogoId;
  final String torneioId;

  const JogoViewPage({Key key, this.jogoId, this.torneioId}) : super(key: key);

  @override
  _JogoViewPageState createState() => _JogoViewPageState();
}

class _JogoViewPageState extends State<JogoViewPage> {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageController _pageController = new PageController();
  bool _mostrar = false;

  Future<dynamic> _timData(String time) async {
    DocumentSnapshot dtime;
    await Firestore.instance
        .collection("times")
        .where("timid", isEqualTo: time)
        .getDocuments()
        .then((doc) {
      dtime = doc.documents.first;
    });

    return dtime;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: new IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.grey,
              ),
              onPressed: () => Navigator.pop(context)),
          title: Image(
            image: AssetImage(
              "images/ampar_name.png",
            ),
            height: 30.0,
            fit: BoxFit.fitHeight,
          ),
          elevation: 0.0,
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance
              .collection("torneios")
              .document(widget.torneioId)
              .collection("jogos")
              .document(widget.jogoId)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> jogo) {
            if (jogo.hasError) return new Text('Error: ${jogo.error}');
            if (jogo.hasData) {
              return ListView(
                children: <Widget>[
                  FutureBuilder(
                      future: _timData(jogo.data.data["jogtime1"]),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> timeCasa) {
                        return timeCasa.hasData
                            ? FutureBuilder(
                                future: _timData(jogo.data.data["jogtime2"]),
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> timeFora) {
                                  return timeFora.hasData
                                      ? new CustomCard(
                                          document: jogo.data,
                                          timecasa: timeCasa,
                                          timefora: timeFora)
                                      : Center(
                                          child: new RefreshProgressIndicator(
                                          backgroundColor: Colors.blue[900],
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Colors.white),
                                        ));
                                })
                            : new Text("");
                      }),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Text("Detalhes do jogo"),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text("Escalações"),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                    child: StreamBuilder<QuerySnapshot>(
                                      stream: Firestore.instance
                                          .collection('torneios')
                                          .document(widget.torneioId)
                                          .collection('jogos')
                                          .document(widget.jogoId)
                                          .collection("escalacoes")
                                          .document("escalacao" + jogo.data["jogtime1"])
                                          .collection("jogadores")
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot> snapshot) {
                                        if (snapshot.hasError)
                                          return new Text(
                                              'Error: ${snapshot.error}');
                                        if (snapshot.hasData) {
                                          return Container(
                                            height: MediaQuery.of(context).size.height,
                                            child: new ListView(
                                                children:
                                                (snapshot.data.documents.map((DocumentSnapshot jogador) {
                                                  DocumentReference jogRef = jogador.data["jogador"];
                                                  return StreamBuilder<DocumentSnapshot>(
                                                      stream: jogRef.snapshots(),
                                                      builder: (context, AsyncSnapshot<DocumentSnapshot> player) {
                                                        return player.hasData ? Row(
                                                          children: <Widget>[
                                                            Expanded(child: Text(player.data["jogusual"]?? "indefinido"), flex: 1,)
                                                          ],
                                                        ) : Text("");
                                                      }
                                                  );
                                                }).toList())),
                                          );
                                        } else {
                                          return new CircularProgressIndicator();
                                        }
                                      },
                                    ),
                                    flex: 2,
                                  ),
                                  Expanded(
                                    child: StreamBuilder<QuerySnapshot>(
                                      stream: Firestore.instance
                                          .collection('torneios')
                                          .document(widget.torneioId)
                                          .collection('jogos')
                                          .document(widget.jogoId)
                                          .collection("escalacoes")
                                          .document("escalacao" + jogo.data["jogtime2"])
                                          .collection("jogadores")
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot> snapshot) {
                                        if (snapshot.hasError)
                                          return new Text(
                                              'Error: ${snapshot.error}');
                                        if (snapshot.hasData) {
                                          return Container(
                                            height: MediaQuery.of(context).size.height,
                                            child: new ListView(
                                                children:
                                                (snapshot.data.documents.map((DocumentSnapshot jogador) {
                                                  DocumentReference jogRef = jogador.data["jogador"];
                                                  return  StreamBuilder<DocumentSnapshot>(
                                                      stream: jogRef.snapshots(),
                                                      builder: (context, AsyncSnapshot<DocumentSnapshot> player) {
                                                        return player.hasData ? Row(
                                                          children: <Widget>[
                                                            Expanded(child: Text(player.data["jogusual"]?? "indefinido"), flex: 1,)
                                                          ],
                                                        ) : Text("");
                                                      }
                                                  );
                                                }).toList())),
                                          );
                                        } else {
                                          return new CircularProgressIndicator();
                                        }
                                      },
                                    ),
                                    flex:2,
                                  ),
                                ],
                              ),

                            ],
                          )
                        ],
                      ),
                    )),
                  )
                ],
              );
            } else {
              return Center(
                child: new CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}

class CustomCard extends StatelessWidget {
  CustomCard({@required this.document, this.timecasa, this.timefora});

  final document;
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
                      Text(document.data["jogid"]),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(timecasa?.data["timsigla"]),
                        ),
                        flex: 2,
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
                          child: Center(
                            child: Text(
                              document?.data["jogvaltime1"] ?? "",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 30),
                            ),
                          ),
                        ),
                        flex: 1,
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
                            child: Text(
                              document?.data["jogvaltime2"] ?? "",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 30),
                            ),
                          ),
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
                          child: Text(timefora?.data["timsigla"]),
                        ),
                        flex: 2,
                      ),
                    ],
                  ),
                ],
              ))),
      onTap: () {},
    );
  }
}
