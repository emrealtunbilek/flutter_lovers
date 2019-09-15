import 'package:flutter/material.dart';
import 'package:flutter_lovers/model/user.dart';

class Konusma extends StatefulWidget {
  final User currentUser;
  final User sohbetEdilenUser;

  Konusma({this.currentUser, this.sohbetEdilenUser});

  @override
  _KonusmaState createState() => _KonusmaState();
}

class _KonusmaState extends State<Konusma> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sohbet"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text("Current user:" + widget.currentUser.userName),
            Text("Sohbet edilen user:" + widget.sohbetEdilenUser.userName),
          ],
        ),
      ),
    );
  }
}
