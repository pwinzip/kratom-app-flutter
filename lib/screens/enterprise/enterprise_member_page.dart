import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../commons/card_info.dart';
import '../../commons/enterprise_collapsing_navigation_drawer.dart';
import '../../services/enterprise_service.dart';

class EnterpriseMemberPage extends StatefulWidget {
  const EnterpriseMemberPage({Key? key}) : super(key: key);

  @override
  State<EnterpriseMemberPage> createState() => _EnterpriseMemberPageState();
}

class _EnterpriseMemberPageState extends State<EnterpriseMemberPage> {
  String? username;
  int? enterpriseid;
  String? enterprisename;
  String? token;

  String _registNo = "";
  String _numMember = "";
  String _numPlant = "";
  List<dynamic> _members = [];

  bool isLoading = true;

  Future<void> getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("username")!;
      enterpriseid = prefs.getInt("enterpriseid")!;
      enterprisename = prefs.getString("username")!;
      token = prefs.getString("token")!;
    });
    await getEnterpriseInfo();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getEnterpriseInfo() async {
    var response = await getEnterpriseMembers(enterpriseid, token);
    setState(() {
      _registNo = jsonDecode(response.body)['enterprise']['regist_no'];
      _members = jsonDecode(response.body)['members'];
      _numMember = jsonDecode(response.body)['memberAmount'].toString();
      _numPlant = jsonDecode(response.body)['plantAmount'].toString();
    });
  }

  Future<String?> getMembers() async {
    var response = await getSales(enterpriseid, token);
    print(response.statusCode);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
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
            enterpriseMemberContent(),
            EnterpriseCollapsingNavigationDrawer(name: username!, menuIndex: 1),
          ],
        ),
      ),
    );
  }

  Widget enterpriseMemberContent() {
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
                  "แจ้งความต้องการขาย",
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
            child: isLoading
                ? loading()
                : ListView(
                    primary: false,
                    padding: const EdgeInsets.only(left: 25, right: 20),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              _registNo,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              enterprisename!,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        margin: const EdgeInsets.only(left: 40),
                        height: 200,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            CardItem(
                                title: "สมาชิก",
                                suffix: "คน",
                                amount: _numMember,
                                icon: FontAwesomeIcons.peopleGroup,
                                bgColor: const Color(0xFFD7FADA),
                                textColor: const Color(0xFF56CC7E)),
                            CardItem(
                                title: "ต้นกระท่อม",
                                suffix: "ต้น",
                                amount: _numPlant,
                                icon: FontAwesomeIcons.handHoldingDroplet,
                                bgColor: const Color(0xFFFFE9C6),
                                textColor: const Color(0xFFDA9551)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: showMemberLists(),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget showMemberLists() {
    List<Widget> myList = [];
    myList = [
      Column(
        children: _members.map((item) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(item['name']),
              subtitle: Text(item['address']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("คงอยู่ ${item['remain']} ต้น"),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    ];

    return Column(
      children: myList,
    );
  }

  Widget loading() {
    return Column(
      children: const [
        SizedBox(
          width: 60,
          height: 60,
          child: CircularProgressIndicator(),
        ),
        Padding(
          padding: EdgeInsets.only(top: 16),
          child: Text('อยู่ระหว่างประมวลผล'),
        )
      ],
    );
  }
}