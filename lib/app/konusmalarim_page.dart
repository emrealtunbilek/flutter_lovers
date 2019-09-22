import 'package:flutter/material.dart';

class KonusmalarimPage extends StatefulWidget {
  @override
  _KonusmalarimPageState createState() => _KonusmalarimPageState();
}

class _KonusmalarimPageState extends State<KonusmalarimPage> {
  @override
  Widget build(BuildContext context) {
    _konusmalarimiGetir();
    return Scaffold(
      appBar: AppBar(
        title: Text("Konusmalarım"),
      ),
      body: Center(
        child: Text("Konusmalarımın listesi"),
      ),
    );
  }

  void _konusmalarimiGetir() async {
    /*var konusmalarim =
        await Firestore.instance.collection("konusmalar").where("")getDocuments();*/
  }
}
