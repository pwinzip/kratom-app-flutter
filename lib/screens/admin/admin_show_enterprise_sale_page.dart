import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../commons/admin_collapsing_navigation_drawer.dart';

class AdminShowEnterpriseSalePage extends StatefulWidget {
  final String? entid;
  const AdminShowEnterpriseSalePage({Key? key, this.entid}) : super(key: key);

  @override
  State<AdminShowEnterpriseSalePage> createState() =>
      _AdminShowEnterpriseSalePageState();
}

class _AdminShowEnterpriseSalePageState
    extends State<AdminShowEnterpriseSalePage> {
  String? username;
  String? token;

  bool isLoading = true;

  Future<void> getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("username")!;
      token = prefs.getString("token")!;
    });
    setState(() {
      isLoading = false;
    });
  }

  Future<String?> getEnterpriseSale() async {
    return null;
  }

  @override
  void initState() {
    getSharedPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            adminShowEnterpriseSaleConter(),
            AdminCollapsingNavigationDrawer(name: username!, menuIndex: 1),
          ],
        ),
      ),
    );
  }

  Widget adminShowEnterpriseSaleConter() {
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
                  "ข้อมูล",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
                SizedBox(width: 10),
                Text(
                  "กลุ่มวิสาหกิจ",
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Container(
            height: MediaQuery.of(context).size.height - 106,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(60),
                topRight: Radius.circular(60),
              ),
            ),
            child: showEnterpriseSaleLists(),
            // ListView(
            //   primary: false,
            //   padding: const EdgeInsets.only(left: 25, right: 20),
            //   children: [
            //     const Padding(
            //       padding: EdgeInsets.only(top: 40),
            //       child: Text(
            //         'ข้อมูลผู้ใช้งาน',
            //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            //       ),
            //     ),
            //     const SizedBox(height: 15),
            // Container(
            //   margin: const EdgeInsets.only(left: 40),
            //   height: 200,
            //   child: isLoading
            //       ? loading()
            //       : ListView(
            //           scrollDirection: Axis.horizontal,
            //           children: [
            //             CardItem(
            //                 title: "เกษตรกร",
            //                 suffix: "คน",
            //                 amount: _numMember!,
            //                 icon: FontAwesomeIcons.peopleGroup,
            //                 bgColor: const Color(0xFFD7FADA),
            //                 textColor: const Color(0xFF56CC7E)),
            //             CardItem(
            //                 title: "กลุ่มวิสาหกิจ",
            //                 suffix: "กลุ่ม",
            //                 amount: _numEnterprise!,
            //                 icon: FontAwesomeIcons.handHoldingHand,
            //                 bgColor: const Color(0xFFFFE9C6),
            //                 textColor: const Color(0xFFDA9551)),
            //           ],
            //         ),
            // ),
            //     const SizedBox(height: 15),
            //     const Padding(
            //       padding: EdgeInsets.only(top: 20),
            //       child: Text(
            //         'รายชื่อกลุ่มวิสาหกิจ',
            //         style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            //       ),
            //     ),
            //     const SizedBox(height: 15),

            //     Padding(
            //       padding: const EdgeInsets.only(top: 10),
            //       child: showEnterpriseSaleLists(),
            //     ),
            //   ],
            // ),
          ),
        ],
      ),
    );
  }

  Widget showEnterpriseSaleLists() {
    return FutureBuilder(
      future: getEnterpriseSale(),
      builder: (context, snapshot) {
        List<Widget> myWidgetList = [];

        if (snapshot.hasData) {
          Map<String, dynamic> data = jsonDecode(snapshot.data.toString());
          print(data);

          myWidgetList.add(entNameHeader());
          myWidgetList.add(const SizedBox(height: 8));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          myWidgetList = [
            const SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('อยู่ระหว่างประมวลผล'),
            )
          ];
        }

        return ListView(
          primary: false,
          padding: const EdgeInsets.only(left: 25, right: 20),
          children: myWidgetList,
        );
      },
    );
  }

  Widget entNameHeader() {
    return const Padding(
      padding: EdgeInsets.only(top: 40),
      child: Text(
        'ข้อมูลผู้ใช้งาน',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }
}
