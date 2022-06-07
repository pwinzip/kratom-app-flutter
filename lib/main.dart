import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kratomapp/screens/admin/admin_main_page.dart';
import 'package:kratomapp/screens/farmer/farmer_main_page.dart';
import 'package:kratomapp/screens/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'สมาคมพืชกระท่อมแห่งประเทศไทย',
      theme: ThemeData(
        textTheme: GoogleFonts.ibmPlexSansThaiTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: Colors.lightGreen,
      ),
      home: const LoginPage(),
    );
  }
}
