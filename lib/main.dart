import 'package:cinema/view/home_view.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: const Scaffold(
        backgroundColor: Color.fromRGBO(21, 20, 31, 1),
        body: Home(),
      ),
    );
  }
}