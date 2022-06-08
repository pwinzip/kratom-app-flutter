import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kratomapp/screens/login_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

void main() {
  Intl.defaultLocale = 'th';
  // initializeDateFormatting();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('th'),
      ],
      locale: const Locale('th'),
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
