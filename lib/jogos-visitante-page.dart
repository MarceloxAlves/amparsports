 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'jogo-view-page.dart';
import 'jogodatapage.dart';
import 'model/tdata.dart';

class JogosVisitantePage extends StatefulWidget {

  DocumentSnapshot _torneio;

   @override
   _JogosVisitantePageState createState() => _JogosVisitantePageState();
 }
 
 class _JogosVisitantePageState extends State<JogosVisitantePage> {


   Future<dynamic> _timData(String time) async {
     DocumentSnapshot dtime;
     await Firestore.instance
         .collection("times")
         .where("timid", isEqualTo: time)
         .getDocuments()
         .then((doc) {
       dtime =  doc.documents.first;
     });

     return dtime;
   }

   @override
   Widget build(BuildContext context) {
     return Scaffold(
         body: Center(
           child: Container(
               padding: const EdgeInsets.all(10.0),
               child: StreamBuilder<QuerySnapshot>(
                 stream: Firestore.instance.collection("torneios").snapshots(),
                 builder:(BuildContext context, AsyncSnapshot<QuerySnapshot> torneios) {
                   if (torneios.hasError)
                   return new Text('Error: ${torneios.error}');
                   if (torneios.hasData) {
                    DocumentSnapshot torneio  = torneios.data.documents.first;
                     return StreamBuilder<QuerySnapshot>(
                       stream: Firestore.instance
                           .collection('torneios')
                           .document(torneio.documentID)
                           .collection('jogos')
                           .where('jogfase', isEqualTo: torneio.data["jogfase"])
                           .where('jogdata', isLessThanOrEqualTo: DateTime.now().toString())
                           .orderBy("jogdata", descending: true)
                           .snapshots(),
                       builder:
                           (BuildContext context,
                           AsyncSnapshot<QuerySnapshot> snapshot) {
                         if (snapshot.hasError)
                           return new Text('Error: ${snapshot.error}');
                         if (snapshot.hasData) {
                           return new ListView(
                             children:
                             snapshot.data.documents.map((DocumentSnapshot document) {
                               return FutureBuilder(
                                   future: _timData(document.data["jogtime1"]),
                                   builder: (BuildContext context,
                                       AsyncSnapshot<dynamic> timeCasa) {
                                     return Center(
                                       child: timeCasa.hasData ?
                                       FutureBuilder(
                                           future: _timData(document.data["jogtime2"]),
                                           builder: (BuildContext context,
                                               AsyncSnapshot<dynamic> timeFora) {
                                             return timeFora.hasData ?
                                             new CustomCard(
                                                 document: document,
                                                 idJogo: document.documentID,
                                                 idTorneio: torneio.documentID,
                                                 timecasa: timeCasa,
                                                 timefora: timeFora): new RefreshProgressIndicator(
                                               backgroundColor: Colors.blue[900],
                                               valueColor:AlwaysStoppedAnimation<Color>(Colors.white),
                                             );
                                           }
                                       ) : new Text(""),
                                     );
                                   });
                             }).toList(),
                           );
                         } else {
                           return new CircularProgressIndicator();
                         }
                       },
                     );
                   }else{
                     return Center(
                       child: new CircularProgressIndicator(),
                     );
                   }
                 },
               )),
         ));
   }
 }


 Widget placar() {
    return Container();
 }


 class CustomCard extends StatelessWidget {
   CustomCard({@required this.document, this.idJogo, this.idTorneio, this.timecasa, this.timefora});

   final document;
   final idJogo;
   final idTorneio;
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
                             child: Text(document?.data["jogvaltime1"] ?? ""),
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
                             child: Text(document?.data["jogvaltime2"] ?? ""),
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
       onTap: () {
         Navigator.push(
             context,
             new MaterialPageRoute(
                 builder: (context) => JogoViewPage(jogoId: idJogo, torneioId: idTorneio)));
       },
     );
   }
 }

 