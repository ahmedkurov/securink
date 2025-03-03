import 'package:flutter/material.dart';
import 'package:securinfinal/screens/Firstpage/firstpage.dart';
import 'package:securinfinal/screens/createaccount/createaccount.dart';
import 'package:securinfinal/screens/govthome/govthome.dart';
import 'package:securinfinal/screens/mainscreen.dart';
import 'package:securinfinal/screens/welcomeback/welcomeback.dart';
import 'package:securinfinal/screens/userhome/userhome.dart'; // Import your HomePage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Set the initial route
      routes: {
        '/': (context) => FirstPage(), // First page as the initial route
        '/home': (context) => HomePage(), // Add your HomePage route
        '/createaccount': (context) => CreateAccountPage(),
        '/welcomeback': (context) => Welcomeback(),
        '/govhome': (context) => HomeScreenPolice(),
      },
    );
  }
}