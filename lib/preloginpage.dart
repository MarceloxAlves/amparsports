import 'package:flutter/material.dart';

class PreLoginPage extends StatefulWidget {
  @override
  _PreLoginPageState createState() => _PreLoginPageState();
}

class _PreLoginPageState extends State<PreLoginPage> {
  final formkey = new GlobalKey<FormState>();

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
                      new Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 30.0),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: _button("Visitante", Colors.blue[900],  () {
                                      Navigator.of(context).pushReplacementNamed('/home-visitante');
                                    }),
                                    flex: 1,
                                  ),
                                ],
                              ),
                              SizedBox(height: 30.0),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: _button("Delegado", Colors.green[300], () {
                                      Navigator.of(context).pushReplacementNamed('/loginpage');
                                    }),
                                    flex: 1,
                                  ),
                                ],
                              ),
                              SizedBox(height: 30.0)
                            ],
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
  
  Widget _button (String label, Color bgcolor, press) {
    return  Container(
      color: Colors.transparent,
      width:
      MediaQuery.of(context).size.width,
      height: 60,
      child: FlatButton(
        shape: new RoundedRectangleBorder(
          borderRadius:
          new BorderRadius.circular(20.0),
        ),
        onPressed: press,
        color: bgcolor,
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Raleway',
            fontSize: 22.0,
          ),
        ),
      ),
    );
  }
}
