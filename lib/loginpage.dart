import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageSate createState() => _LoginPageSate();
}

class _LoginPageSate extends State<LoginPage> {
  String _email;
  String _password;
  FirebaseUser mCurrentUser;
  GoogleSignInAccount _currentUser;
  FirebaseAuth _auth;
  String accountStatus = '******';

  //google sign
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  final formkey = new GlobalKey<FormState>();

  checkFields() {
    final form = formkey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
    _getCurrentUser();
    print('here outside async');

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      setState(() {
        _currentUser = account;
      });
      if (_currentUser != null) {
        print("signed in as ${_currentUser.displayName}");
        Navigator.of(context).pushReplacementNamed('/userpage');
      }
    });
    _googleSignIn.signInSilently();
  }

  Future<void> _getCurrentUser() async {
    mCurrentUser = await _auth.currentUser();
    print('Hello ' + mCurrentUser.displayName.toString());
    setState(() {
      mCurrentUser != null ? accountStatus = 'Signed In' : 'Not Signed In';
    });
    if (mCurrentUser != null) {
      print("signed in as ${mCurrentUser.displayName}");
      Navigator.of(context).pushReplacementNamed('/userpage');
    }
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  LoginUser() {
    if (checkFields()) {
      _auth
          .signInWithEmailAndPassword(email: _email, password: _password)
          .then((user) {
        print("signed in as ${user.uid}");
        Navigator.of(context).pushReplacementNamed('/userpage');
      }).catchError((e) {
        print(e);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
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
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          Container(
            height: 220.0,
            width: 110.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/app.png'), fit: BoxFit.cover),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(500.0),
                  bottomRight: Radius.circular(500.0)),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Center(
                  child: Form(
                key: formkey,
                child: Center(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      _input("email é obrigatório", false, "Email",
                          'Digite Seu email', (value) => _email = value),
                      SizedBox(
                        width: 20.0,
                        height: 20.0,
                      ),
                      _input("senha é obrigatório", true, "Senha", 'Senha',
                          (value) => _password = value),
                      new Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: OutlineButton(
                                          child: Text("Login ",  style: TextStyle(color: Colors.green[600]),),
                                          onPressed: LoginUser),
                                      flex: 1,
                                    ),
                                    Expanded(
                                      child: OutlineButton(
                                          child: Text("Início", style: TextStyle(color: Colors.orangeAccent),),
                                          onPressed: () {
                                            Navigator.of(context).pushReplacementNamed('/prelogin');
                                          }),
                                      flex: 1,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15.0)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
            ),
          ),
        ],
      ),
    );
  }

  Widget _input(String validation, bool, String label, String hint, save) {
    return new TextFormField(
      decoration: InputDecoration(
        hintText: hint,
        labelText: label,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 20.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
      obscureText: bool,
      validator: (value) => value.isEmpty ? validation : null,
      onSaved: save,
    );
  }
}
