import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

void main() {
  runApp(const TranslatorApp());
}

class TranslatorApp extends StatelessWidget {
  const TranslatorApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'RPMTranslator',
        theme: ThemeData(
            brightness: Brightness.dark,
            fontFamily: 'font',
            useMaterial3: true),
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
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leadingWidth: 48,
          leading: SvgPicture.asset("assets/images/logo.svg"),
          titleSpacing: 0,
          title: const Text("RPMTranslator")),
      body: Row(
        children: [
          NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              labelType: NavigationRailLabelType.all,
              destinations: const <NavigationRailDestination>[
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('HOME'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.translate),
                  label: Text('Translate'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.article),
                  label: Text('Report'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.info),
                  label: Text('About'),
                ),
              ]),
          const Text("test"),
        ],
      ),
    );
  }
}
