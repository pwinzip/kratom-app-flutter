import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../commons/farmer_collapsing_navigation_drawer.dart';

class FarmerHistoryPage extends StatefulWidget {
  const FarmerHistoryPage({Key? key}) : super(key: key);

  @override
  State<FarmerHistoryPage> createState() => _FarmerHistoryPageState();
}

class _FarmerHistoryPageState extends State<FarmerHistoryPage> {
  String? _username;
  int? _farmerid;
  String? _enterprisename;
  String? _agentname;
  String? _token;

  Future<void> getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString("username")!;
      _farmerid = prefs.getInt('farmerid')!;
      _enterprisename = prefs.getString("enterprisename")!;
      _agentname = prefs.getString("agentname")!;
      _token = prefs.getString("token")!;
    });
  }

  @override
  void initState() {
    super.initState();
    getSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          plantsContent(),
          FarmerCollapsingNavigationDrawer(
            name: _username!,
            menuIndex: 1,
          ),
        ],
      )),
    );
  }

  Widget plantsContent() {
    return Container(
      margin: const EdgeInsets.only(left: 70),
      color: const Color(0xFF21BFBD),
      child: ListView(
        children: [
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Row(
              children: const [
                Text(
                  "ประวัติการปลูก",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
                SizedBox(width: 10),
                Text(
                  "พืชกระท่อม",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
