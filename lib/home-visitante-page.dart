import 'package:amparsports/drawer.dart';
import 'package:amparsports/pclassificacao.dart';
import 'package:amparsports/people.dart';
import 'package:amparsports/popup_menu.dart';
import 'package:amparsports/ptable-jogos.dart';
import 'package:amparsports/torneios.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:toast/toast.dart';

import 'drawer-visitante.dart';

class HomeVisitantePage extends StatefulWidget {
  @override
  _HomeVisitantePageState createState() => _HomeVisitantePageState();
}

List<MPopupMenu> choices = <MPopupMenu>[
  MPopupMenu(title: ' ', icon: Icons.home),
  MPopupMenu(title: 'Bookmarks', icon: Icons.bookmark),
  MPopupMenu(title: 'Settings', icon: Icons.settings),
];

class _HomeVisitantePageState extends State<HomeVisitantePage>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation animation;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageController _pageController  = new PageController();
  MPopupMenu _selectedChoices = choices[0];

  @override
  void initState() {

  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  int photoindex = 0;

  void _previousImage() {
    setState(() {
      photoindex = photoindex > 0 ? photoindex - 1 : 0;
    });
  }

  void _setPage(int page){
    setState(() {
       _pageController.jumpToPage(page);
    });
  }

  void _select(MPopupMenu choice) {
    setState(() {
      _selectedChoices = choice;
    });

    Toast.show(choice.title, context);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: new Scaffold(
        key: _scaffoldKey,
        drawer: MDrawerVisitante(),
        appBar: AppBar(
          leading: new IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.grey,
              ),
              onPressed: () => _scaffoldKey.currentState.openDrawer()),

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
          bottom: TabBar(tabs: [
            Tab(icon: Icon(Icons.blur_circular), text:"Jogos",),
            Tab(icon: Icon(Icons.grid_on),text:"Classificação",),
            Tab(icon: Icon(Icons.check_box), text: "Disciplinado",),
          ],
          labelColor: Colors.blue[900],),
        ),
        body: TabBarView(
          children: <Widget>[
            PTableJogos(),
            PClassificacao(),
            Text("cafa"),
          ],
        ),
      ),
    );
  }
}
