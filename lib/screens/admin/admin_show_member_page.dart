import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../commons/admin_collapsing_navigation_drawer.dart';
import '../../commons/card_info.dart';
import '../../services/enterprise_service.dart';
import '../../theme.dart';

class AdminShowMemberPage extends StatefulWidget {
  final int? entid;

  const AdminShowMemberPage({Key? key, this.entid}) : super(key: key);

  @override
  State<AdminShowMemberPage> createState() => _AdminShowMemberPageState();
}

class _AdminShowMemberPageState extends State<AdminShowMemberPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String? username;
  String? token;

  String _numMember = "";
  String _numPlant = "";
  Map<String, dynamic> _enterprise = {};
  List<dynamic> _members = [];

  bool isLoading = true;

  Future<void> getSharedPreferences() async {
    SharedPreferences prefs = await _prefs;
    setState(() {
      username = prefs.getString("username");
      token = prefs.getString("token");
    });
    await getMembers();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getMembers() async {
    var response = await getEnterpriseMembers(widget.entid, token);
    if (response.statusCode == 200) {
      setState(() {
        _enterprise = jsonDecode(response.body)['enterprise'];
        _members = jsonDecode(response.body)['members'];
        _numMember = jsonDecode(response.body)['memberAmount'].toString();
        _numPlant = jsonDecode(response.body)['plantAmount'].toString();
      });
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
            adminMemberContent(),
            AdminCollapsingNavigationDrawer(
              name: username!,
              menuIndex: 1,
              maxWidth: MediaQuery.of(context).size.width * 0.55,
            ),
          ],
        ),
      ),
    );
  }

  Widget adminMemberContent() {
    return Container(
      margin: const EdgeInsets.only(left: 70),
      color: const Color(0xFF21BFBD),
      child: ListView(
        children: [
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.chevron_left,
                      color: Colors.white,
                      size: 28,
                    )),
                const SizedBox(width: 10),
                const Text(
                  "??????????????????",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    "???????????????????????????????????????",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
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
                      const Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: Text(
                          '?????????????????????????????????????????????????????????',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
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
                                title: "??????????????????",
                                suffix: "??????",
                                amount: _numMember,
                                icon: FontAwesomeIcons.peopleGroup,
                                bgColor: const Color(0xFFD7FADA),
                                textColor: const Color(0xFF56CC7E)),
                            CardItem(
                                title: "??????????????????????????????",
                                suffix: "?????????",
                                amount: _numPlant,
                                icon: FontAwesomeIcons.handHoldingDroplet,
                                bgColor: const Color(0xFFFFE9C6),
                                textColor: const Color(0xFFDA9551)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          _enterprise['enterprise_name'],
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                          "?????????????????????????????????  ${_enterprise['users']['name']}",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w300),
                        ),
                      ),
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

    if (_members.isEmpty) {
      myList = [notFoundWidget];
    } else {
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
                    Text("?????????????????? ${item['remain']} ?????????"),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ];
    }

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
          child: Text('?????????????????????????????????????????????????????????'),
        )
      ],
    );
  }
}
