import 'package:flutter/material.dart';
import 'package:flutter_lovers/common_widget/social_log_in_button.dart';

class EmailveSifreLoginPage extends StatefulWidget {
  @override
  _EmailveSifreLoginPageState createState() => _EmailveSifreLoginPageState();
}

class _EmailveSifreLoginPageState extends State<EmailveSifreLoginPage> {
  String _email, _sifre;
  final _formKey = GlobalKey<FormState>();

  _formSubmit(BuildContext context) {
    _formKey.currentState.save();
    debugPrint("email :" + _email + " şifre:" + _sifre);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Giriş / Kayıt"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.mail),
                      hintText: 'Email',
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (String girilenEmail) {
                      _email = girilenEmail;
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.mail),
                      hintText: 'Sifre',
                      labelText: 'Sifre',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (String girilenSifre) {
                      _sifre = girilenSifre;
                    },
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  SocialLoginButton(
                    butonText: "Giriş Yap",
                    butonColor: Theme.of(context).primaryColor,
                    radius: 10,
                    onPressed: () => _formSubmit(context),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
