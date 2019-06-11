import 'package:amparsports/jogospage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
          padding: const EdgeInsets.all(10.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('torneios').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError)
                return new Text('Error: ${snapshot.error}');
              if (snapshot.hasData) {
                return new ListView(
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    return new CustomCard(
                      title: document['tornome'],
                      description: document['torid'],
                      torid: document.documentID,
                      imagem: document['torlogo'],
                    );
                  }).toList(),
                );
              }else{
                return new CircularProgressIndicator();
              }
            },
          )),
    ));
  }
}

class CustomCard extends StatelessWidget {
  CustomCard({@required this.title, this.description, this.torid, this.imagem});

  final title;
  final description;
  final torid;
  final imagem;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: Card(
          child: Container(
              padding: const EdgeInsets.only(top: 5.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(title),
                  ),
                  Image.network(
                    imagem,
                  ),
                ],
              ))),
      onTap: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new JogosPage(torneioID: torid)));
      },
    );
  }
}
