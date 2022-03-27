import 'package:flutter/material.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'RPMTranslator - RPMTW 模組專屬翻譯器',
        theme: ThemeData(brightness: Brightness.dark, fontFamily: 'font'),
        debugShowCheckedModeBanner: false,
        initialRoute: HomePage.route,
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
            settings: settings,
            builder: (context) => const HomePage(),
          );
        });
  }
}

class HomePage extends StatefulWidget {
  static String route = "/";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("RPMTranslator")),
    );
  }
}
