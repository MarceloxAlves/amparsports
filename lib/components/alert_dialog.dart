
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class AlertDialogJogadores extends StatefulWidget {
  final DocumentSnapshot jogo;
  final String  time;


  const AlertDialogJogadores({Key key, this.jogo, this.time}) : super(key: key);

  @override
  _AlertDialogState createState() => _AlertDialogState();
}

class _AlertDialogState extends State<AlertDialogJogadores> {

  String _currVal = "";


  @override
  Widget build(BuildContext context) {
          return AlertDialog(
              title: Text('Escolha o jogador | ${_currVal}'),
              content: StreamBuilder<QuerySnapshot>(
                stream: Firestore.instance.collection('jogadores').where(
                    'jogtime', isEqualTo: widget.time).snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  if (snapshot.hasData) {
                    return new ListView(
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        return new RadioListTile(
                          title: Text("${document["jognome"]}"),
                          groupValue: _currVal,
                          value: document["jogid"],
                          onChanged: (val) {
                            setState(() {
                              _currVal = val;
                            });
                          },

                        );
                      }).toList(),
                    );
                  } else {
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
  }

}