import 'package:cinema/theme.dart';
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
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        backgroundColor: CinemaTheme.backgroundColor,
        body: const Home(),
      ),
    );
  }
}
