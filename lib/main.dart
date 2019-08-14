import 'package:flutter/material.dart';
import 'package:flutter_lovers/landing_page.dart';
import 'package:flutter_lovers/locator.dart';
import 'package:flutter_lovers/viewmodel/user_model.dart';
import 'package:provider/provider.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Lovers',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: ChangeNotifierProvider(
          builder: (context) => UserModel(), child: LandingPage()),
    );
  }
}
