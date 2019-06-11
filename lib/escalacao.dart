import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EscalacaoPage extends StatefulWidget {
  final DocumentSnapshot jogo;

  const EscalacaoPage({Key key, this.jogo}) : super(key: key);

  @override
  _EscalacaoPagePageState createState() => _EscalacaoPagePageState();
}

class _EscalacaoPagePageState extends State<EscalacaoPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageController _pageController = new PageController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: const Text('Escalações'),
        textTheme: TextTheme(body2: TextStyle(color: Colors.black12)),
      ),
      body: Column(
        children: <Widget>[
          CustomCard(document: widget.jogo, idJogo: widget.jogo.documentID),
          Row(
            children: <Widget>[
              TimeScalacaoPage(),
              TimeScalacaoPage(),
            ],
          )
        ],
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  CustomCard({@required this.document, this.idJogo});

  final document;
  final idJogo;

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
                ],
              ))),
      onTap: () {},
    );
  }
}

class TimeScalacaoPage extends StatefulWidget {
  @override
  _TimeScalacaoPageState createState() => _TimeScalacaoPageState();
}

class _TimeScalacaoPageState extends State<TimeScalacaoPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ListView(
          children: <Widget>[
            ListTile(title: Text("adadada"),),
            ListTile(title: Text("adadada"),)
          ],
        )
      ],
    );
  }
}


class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Car', icon: Icons.directions_car),
  const Choice(title: 'Bicycle', icon: Icons.directions_bike),
  const Choice(title: 'Boat', icon: Icons.directions_boat),
  const Choice(title: 'Bus', icon: Icons.directions_bus),
  const Choice(title: 'Train', icon: Icons.directions_railway),
  const Choice(title: 'Walk', icon: Icons.directions_walk),
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return Card(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(choice.icon, size: 128.0, color: textStyle.color),
            Text(choice.title, style: textStyle),
          ],
        ),
      ),
    );
  }
}
