import 'package:flutter/material.dart';
import 'package:flutter_lovers/model/mesaj.dart';
import 'package:flutter_lovers/model/user.dart';
import 'package:flutter_lovers/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

class Konusma extends StatefulWidget {
  final User currentUser;
  final User sohbetEdilenUser;

  Konusma({this.currentUser, this.sohbetEdilenUser});

  @override
  _KonusmaState createState() => _KonusmaState();
}

class _KonusmaState extends State<Konusma> {
  var _mesajController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    User _currentUser = widget.currentUser;
    User _sohbetEdilenUser = widget.sohbetEdilenUser;
    final _userModel = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Sohbet"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: StreamBuilder<List<Mesaj>>(
                  stream: _userModel.getMessages(
                      _currentUser.userID, _sohbetEdilenUser.userID),
                  builder: (context, streamMesajlarListesi) {
                    if (!streamMesajlarListesi.hasData) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    List<Mesaj> tumMesajlar = streamMesajlarListesi.data;
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return Text(tumMesajlar[index].mesaj);
                      },
                      itemCount: tumMesajlar.length,
                    );
                  }),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 8, left: 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _mesajController,
                      cursorColor: Colors.blueGrey,
                      style: new TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Mesajınızı Yazın",
                        border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                            borderSide: BorderSide.none),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 4,
                    ),
                    child: FloatingActionButton(
                      elevation: 0,
                      backgroundColor: Colors.blue,
                      child: Icon(
                        Icons.navigation,
                        size: 35,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
