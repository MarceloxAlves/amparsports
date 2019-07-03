import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EscalacaoPage extends StatefulWidget {
  final DocumentSnapshot jogo;
  final String time;

  const EscalacaoPage({Key key, this.jogo, this.time}) : super(key: key);

  @override
  _EscalacaoPagePageState createState() => _EscalacaoPagePageState();
}

class _EscalacaoPagePageState extends State<EscalacaoPage> {
  PageController _pageController = new PageController();
  DocumentSnapshot _torneio = null;
  DocumentSnapshot _time = null;

  initState() {
    super.initState();
  }

  _getTimeRef() {
    return Firestore.instance
        .collection('times')
        .where('timid', isEqualTo: this.widget.time)
        .snapshots();
  }

  _getTorneioRef() {
    return Firestore.instance
        .collection('torneios')
        .where('torid', isEqualTo: this.widget.jogo.data["jodtorneio"])
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        StreamBuilder<QuerySnapshot>(
          stream: _getTimeRef(),
          builder: (context, snap) {
            if (snap.data == null) return CircularProgressIndicator();
            if (snap.hasData &&
                !snap.hasError &&
                snap.data.documents.length > 0) {
              _time = snap.data.documents[0];
            }

            return snap.data.documents.length > 0
                ? CustomCard(time: _time)
                : Text("Não POSSUI DADOS");
          },
        ),
        StreamBuilder<QuerySnapshot>(
          stream: _getTorneioRef(),
          builder: (context, snap) {
            if (snap.data == null)
              return SizedBox(
                width: 0,
                height: 0,
              );
            if (snap.hasData &&
                !snap.hasError &&
                snap.data.documents.length > 0) {
              _torneio = snap.data.documents[0];
            }

            return snap.data.documents.length > 0
                ? TimeEscalacaoPage(
                    ano:
                        _torneio?.data["torperiodo"].toString().substring(0, 4),
                    timid: _time?.data["timid"],
                    torneioId: _torneio.documentID,
                    jogoId: widget.jogo.documentID)
                : SizedBox(
                    width: 0,
                    height: 0,
                  );
          },
        ),
      ],
    );
  }
}

class CustomCard extends StatelessWidget {
  CustomCard({@required this.time});

  final DocumentSnapshot time;

  @override
  Widget build(BuildContext context) {
    return Card(
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
                      child: Text("Escalação",
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
                        child: Text(time.data["timusual"]),
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
                              time.data["timescudo"].toString(),
                              scale: 1.0,
                            ),
                          ),
                        ),
                      ),
                      flex: 2,
                    ),
                  ],
                ),
              ],
            )));
  }
}

class TimeEscalacaoPage extends StatefulWidget {
  final String ano;
  final String timid;
  final String torneioId;
  final String jogoId;

  const TimeEscalacaoPage(
      {Key key, this.ano, this.timid, this.torneioId, this.jogoId})
      : super(key: key);

  @override
  _TimeEscalacaoPageState createState() => _TimeEscalacaoPageState();
}

class _TimeEscalacaoPageState extends State<TimeEscalacaoPage> {
  _getJogadores() {
    return Firestore.instance
        .collection('jogadores')
        .where('jogtime', isEqualTo: this.widget.timid)
        .where('jogano', isEqualTo: this.widget.ano)
        .orderBy("jogusual", descending: false)
        .snapshots();
  }

  Map<String, DocumentReference> _escalados = {};

  @override
  void initState() {
    // TODO: implement initState
    _onloadEscalacao();
    super.initState();
  }

  _onloadEscalacao(){
    Firestore.instance
        .collection('torneios')
        .document(widget.torneioId)
        .collection("jogos")
        .document(widget.jogoId)
        .collection("escalacoes")
        .document("escalacao" + widget.timid)
        .collection("jogadores")
        .getDocuments().then((query) => {
        query.documents.forEach( (f) {
          _escalados.putIfAbsent(f.documentID, () => f.data["jogador"]);
        })
    });
  }

  _escalar(DocumentSnapshot jogador) {
    setState(() {
      if (_escalados.containsKey(jogador.data["jogid"].toString())) {
        _escalados.remove(jogador.data["jogid"].toString());
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(jogador.data["jogusual"] + " removido da escalação"),
          backgroundColor: Colors.red[400],
          duration: Duration(seconds: 1),
        ));
      } else {
        _escalados.putIfAbsent(
            jogador.data["jogid"].toString(), () => jogador.reference);
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(jogador.data["jogusual"] + " escalado"),
          backgroundColor: Colors.green[400],
          duration: Duration(seconds: 1),
        ));
      }
      print(_escalados);
    });
  }
  Future _salvarEscalacao() {
    setState(() {
        Firestore.instance
            .collection('torneios')
            .document(widget.torneioId)
            .collection("jogos")
            .document(widget.jogoId)
            .collection("escalacoes")
            .document("escalacao" + widget.timid)
            .collection("jogadores")
            .getDocuments().then((query) => {
              query.documents.forEach( (f) {
                f.reference.delete();
              })
             })
            .then((onValue) => {
          _escalados.forEach((key, reference) {
            Firestore.instance
                .collection('torneios')
                .document(widget.torneioId)
                .collection("jogos")
                .document(widget.jogoId)
                .collection("escalacoes")
                .document("escalacao" + widget.timid)
                .collection("jogadores")
                .document(key)
                .setData({"jogador": reference});
          })
        });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
            stream: _getJogadores(),
            builder: (context, snap) {
              List itens = [];
              if (snap.data == null) return CircularProgressIndicator();
              if (snap.hasData &&
                  !snap.hasError &&
                  snap.data.documents.length > 0) {
                snap.data.documents.forEach((doc) {
                  itens.add(doc);
                });
              }

              return Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: itens.length > 0
                    ? ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: itens.length,
                        itemBuilder: (BuildContext ctxt, int index) {
                          DocumentSnapshot jogador = itens[index];
                          return GestureDetector(
                            child: Card(
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Icon(Icons.person),
                                          flex: 1,
                                        ),
                                        Expanded(
                                            child:
                                                Text(jogador.data["jogusual"]),
                                            flex: 3),
                                        Expanded(
                                          child: _escalados.containsKey(jogador
                                                  .data["jogid"]
                                                  .toString())
                                              ? Icon(
                                                  Icons.check,
                                                  color: Colors.green,
                                                )
                                              : Text(""),
                                          flex: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onDoubleTap: () {
                              _escalar(jogador);
                            },
                          );
                          ;
                        })
                    : Text(
                        "NAO POSSUI DADOS",
                        style: TextStyle(fontSize: 10),
                      ),
              );
            },
          ),
        ],
      ),
      Positioned(
        right: 30.0,
        bottom: 30.0,
        child: FloatingActionButton(
          onPressed: () async {
            await _salvarEscalacao();
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Escalação Salva"),
              backgroundColor: Colors.green[400],
              duration: Duration(seconds: 1),
            ));
          },
          tooltip: 'Salvar Escalação',
          child: Icon(Icons.check_box),
          elevation: 4.0,
        ),
      ),
    ]);
  }
}
