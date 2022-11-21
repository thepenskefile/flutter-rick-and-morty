import 'package:flutter/material.dart';
import 'package:rick_and_morty/screens/characters/characters.dart';
import 'package:rick_and_morty/screens/locations/locations.dart';
import 'package:rick_and_morty/widgets/ui/shadow_container.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick & Morty Character App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

final List<Map<String, dynamic>> buttons = [
  {
    "displayName": "Characters",
    "screen": const CharacterScreen(),
  },
  {
    "displayName": "Locations",
    "screen": const LocationsScreen(),
  }
];

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Rick & Morty Character App"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return (const Padding(padding: EdgeInsets.all(10)));
            },
            itemCount: buttons.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                child: ShadowContainer(
                  child: Text(
                    buttons[index]["displayName"],
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => buttons[index]["screen"],
                    ),
                  );
                },
              );
            },
          ),
        ));
  }
}
