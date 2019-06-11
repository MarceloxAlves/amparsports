import 'package:amparsports/drawer.dart';
import 'package:amparsports/people.dart';
import 'package:amparsports/popup_menu.dart';
import 'package:amparsports/torneios.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:toast/toast.dart';

class Page extends StatefulWidget {
  @override
  _FlutterPageState createState() => _FlutterPageState();
}

List<MPopupMenu> choices = <MPopupMenu>[
  MPopupMenu(title: ' ', icon: Icons.home),
  MPopupMenu(title: 'Bookmarks', icon: Icons.bookmark),
  MPopupMenu(title: 'Settings', icon: Icons.settings),
];

class _FlutterPageState extends State<Page>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  Animation animation;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  PageController _pageController  = new PageController();

  @override
  void initState() {
    animationController =
        new AnimationController(duration: Duration(seconds: 10), vsync: this);
    animation =
        IntTween(begin: 0, end: photos.length - 1).animate(animationController)
          ..addListener(() {
            setState(() {
              photoindex = animation.value;
            });
          });
    animationController.repeat();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  int photoindex = 0;
  List<String> photos = [
    "images/flutter1.png",
    "images/Logomark.png",
    "images/google1.png",
    "images/dart.png",
    "images/bird.jpg"
  ];

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

  void _nextImage() {
    setState(() {
      photoindex = photoindex < photos.length - 1 ? photoindex + 1 : photoindex;
    });
  }

  MPopupMenu _selectedChoices = choices[0];

  void _select(MPopupMenu choice) {
    setState(() {
      _selectedChoices = choice;
    });

    Toast.show(choice.title, context);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      drawer: MDrawer(),
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
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: PageView(
          physics: new NeverScrollableScrollPhysics(),
          children: <Widget>[MyApp(), People()],
          controller: _pageController,
        ),
      ),
    );
  }
}
