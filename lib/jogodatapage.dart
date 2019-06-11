import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:toast/toast.dart';

import 'escalacao.dart';
import 'models/models.dart';

class JogosDataPage extends StatefulWidget {
  final DocumentSnapshot jogo;
  final torneio;

  const JogosDataPage({Key key, this.jogo, this.torneio}) : super(key: key);

  @override
  _JogosDataPageState createState() => _JogosDataPageState();
}

class _JogosDataPageState extends State<JogosDataPage> {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageController _pageController = new PageController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(key: _scaffoldKey, body: JogoData(jogo: widget.jogo, torneio: widget.torneio));
  }
}

class JogoData extends StatefulWidget {
  final DocumentSnapshot jogo;
  final String torneio;

  const JogoData({Key key, this.jogo, this.torneio}) : super(key: key);

  @override
  _JogoDataState createState() => _JogoDataState(int.parse(this.jogo["jogvaltime1"].toString()), int.parse(this.jogo["jogvaltime2"].toString()));
}

class _JogoDataState extends State<JogoData> {

  String _currVal = "";
  int _qtd_gol_casa;
  int _qtd_gol_fora;
  bool _throwShotAway =  false;

  _JogoDataState(this._qtd_gol_casa, this._qtd_gol_fora);

  _setGol(Gol gol){
    setState(() {
      Firestore.instance.collection('torneios').document(widget.torneio).collection("jogos").document(widget.jogo.documentID).collection("gols").add(gol.toMap());
      Firestore.instance.collection('torneios').document(widget.torneio).collection("jogos").document(widget.jogo.documentID).updateData({"jogvaltime1": _qtd_gol_casa, "jogvaltime2": _qtd_gol_fora});
    });
  }

  _setCard(Cartao cartao){
    Firestore.instance.collection('torneios').document(widget.torneio)
        .collection("jogos").document(widget.jogo.documentID)
        .collection("cartoes").add(cartao.toMap());
  }


  _displayDialog(BuildContext context, String time, String op) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Escolha o jogador | ${_currVal}'),
              content: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('jogadores').where('jogtime', isEqualTo: time).snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  if (snapshot.hasData) {
                    return new ListView(
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        return new RadioListTile(
                          title: Text("${document["jogusual"]}"),
                          groupValue: _currVal,
                          value: document["jogid"],
                          onChanged: (val) {
                            setState(() {
                              _currVal = val;
                              Navigator.of(context).pop();

                                switch (op) {
                                  case "gol":
                                    Gol mgol = new  Gol(val,"",time);
                                    if (widget.jogo["jogtime1"] == time){
                                      _qtd_gol_casa++;
                                    }else{
                                      _qtd_gol_fora++;
                                    }
                                    _setGol(mgol);
                                    break;
                                  case "yellow_card":
                                    Cartao card = new  Cartao(val,"A",time);
                                    _setCard(card);
                                    break;

                                  case "red_card":
                                    Cartao card = new  Cartao(val,"V",time);
                                    _setCard(card);
                                    break;
                                }


                            });
                          },

                        );
                      }).toList(),
                    );
                  }else{
                    return new CircularProgressIndicator();
                  }
                },
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('Salvar'),
                  onPressed: () {
                    Toast.show("Deu bom", context,
                        duration: Toast.LENGTH_LONG);
                    Navigator.of(context).pop();
                  },
                )
              ]);
        });
  }


  _escalacaoDialog(BuildContext context, String time, String op) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text('Escalação'),
              content: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('jogadores').where('jogtime', isEqualTo: time).snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  if (snapshot.hasData) {
                    return new ListView(
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        return new CheckboxListTile(
                          title: Text("${document["jogusual"]}"),
                          value: _throwShotAway,
                          onChanged: (val) {
                            setState(() {
                              _throwShotAway = val;
                            });
                          },
                        );
                      }).toList(),
                    );
                  }else{
                    return new CircularProgressIndicator();
                  }
                },
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('Salvar'),
                  onPressed: () {
                    Toast.show("Deu bom", context,
                        duration: Toast.LENGTH_LONG);
                    Navigator.of(context).pop();
                  },
                )
              ]);
        });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        CustomCard(document: widget.jogo, idJogo: widget.jogo.documentID,qtd_gol_casa: _qtd_gol_casa, qtd_gol_fora: _qtd_gol_fora, ),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                const SizedBox(height: 30),
                RaisedButton(
                  onPressed: () {
                    _displayDialog(context,widget.jogo["jogtime1"], "gol");
                  },
                  child: Column(
                    // Replace with a Row for horizontal icon + text
                    children: <Widget>[
                      Icon(
                        Icons.brightness_1,
                        color: Colors.indigo,
                      ),
                      Text('GOL', style: TextStyle(fontSize: 20))
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                RaisedButton(
                  onPressed: () {
                    _displayDialog(context,widget.jogo["jogtime1"], "yellow_card");
                  },
                  child: Column(
                    // Replace with a Row for horizontal icon + text
                    children: <Widget>[
                      Icon(
                        Icons.view_carousel,
                        color: Colors.yellowAccent,
                      ),
                      Text('Cartão', style: TextStyle(fontSize: 20))
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                RaisedButton(
                  onPressed: () {
                    _displayDialog(context,widget.jogo["jogtime1"], "red_card");
                  },
                  child: Column(
                    // Replace with a Row for horizontal icon + text
                    children: <Widget>[
                      Icon(
                        Icons.view_carousel,
                        color: Colors.redAccent,
                      ),
                      Text('Cartão', style: TextStyle(fontSize: 20))
                    ],
                  ),
                ),
              ]),


              // DADOS DO TIME QUE JOGA COMO VISITANTE

              Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                const SizedBox(height: 30),
                RaisedButton(
                  onPressed: () {
                    _displayDialog(context,widget.jogo["jogtime2"], "gol");
                  },
                  child: Column(
                    // Replace with a Row for horizontal icon + text
                    children: <Widget>[
                      Icon(
                        Icons.brightness_1,
                        color: Colors.indigo,
                      ),
                      Text('GOL', style: TextStyle(fontSize: 20))
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                RaisedButton(
                  onPressed: () {
                    _displayDialog(context,widget.jogo["jogtime2"], "yellow_card");
                  },
                  child: Column(
                    // Replace with a Row for horizontal icon + text
                    children: <Widget>[
                      Icon(
                        Icons.view_carousel,
                        color: Colors.yellowAccent,
                      ),
                      Text('Cartão', style: TextStyle(fontSize: 20))
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                RaisedButton(
                  onPressed: () {
                    _displayDialog(context,widget.jogo["jogtime2"], "red_card");
                  },
                  child: Column(
                    // Replace with a Row for horizontal icon + text
                    children: <Widget>[
                      Icon(
                        Icons.view_carousel,
                        color: Colors.redAccent,
                      ),
                      Text('Cartão', style: TextStyle(fontSize: 20))
                    ],
                  ),
                ),
              ]),
            ]),
        const SizedBox(height: 20),
          RaisedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      builder: (context) => new EscalacaoPage(jogo: widget.jogo)));
            },
            child: Column(
              // Replace with a Row for horizontal icon + text
              children: <Widget>[
                Icon(
                  Icons.list,
                  color: Colors.green,
                ),
                Text('Escalação', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 10),
              ],
            ),
          ),
      ],
    ));
  }


}

class CustomCard extends StatelessWidget {
  CustomCard({@required this.document, this.idJogo, this.qtd_gol_casa, this.qtd_gol_fora});

  final document;
  final idJogo;
  final qtd_gol_casa;
  final qtd_gol_fora;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: Card(
          child: Container(
              height: 150,
              padding: const EdgeInsets.only(top: 5.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(8.0),
                          width: 100,
                          child: Text(document["time_casa"]["nome"]),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          width: 50,
                          child: Image.network(
                            document["time_casa"]["escudo"],
                            scale: 0.5,
                          ),
                        ),
                        Container(
                          width: 20,
                          padding: EdgeInsets.all(0.0),
                          child: Text(" X "),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          width: 50,
                          child: Image.network(document["time_fora"]["escudo"]),
                        ),
                        Container(
                          width: 100,
                          padding: EdgeInsets.all(8.0),
                          child: Text(document["time_fora"]["nome"]),
                        ),
                      ]),
                  Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(8.0),
                          width: 60,
                          child: Text(
                            qtd_gol_casa.toString(),
                            style: TextStyle(fontSize: 35),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          width: 35,
                          child: Text(qtd_gol_fora.toString(),
                              style: TextStyle(fontSize: 35)),
                        ),
                      ])
                ],
              ))),
      onTap: () {},
    );
  }
}
