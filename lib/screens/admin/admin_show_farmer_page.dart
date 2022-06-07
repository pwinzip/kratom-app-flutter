import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../commons/admin_collapsing_navigation_drawer.dart';
import '../../commons/card_info.dart';
import '../../services/admin_service.dart';
import 'admin_add_farmer_page.dart';
import 'admin_edit_farmer_page.dart';
import 'admin_show_farmer_plant_page.dart';

class AdminShowFarmerPage extends StatefulWidget {
  const AdminShowFarmerPage({Key? key}) : super(key: key);

  @override
  State<AdminShowFarmerPage> createState() => _AdminShowFarmerPageState();
}

class _AdminShowFarmerPageState extends State<AdminShowFarmerPage> {
  String? username;
  String? token;

  String? _numPlant;
  String? _numFarmer;

  bool isLoading = true;

  Future<void> getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("username")!;
      token = prefs.getString("token")!;
    });
    await getFarmersNum();
    await getPlantsNum();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getFarmersNum() async {
    var response = await getFarmerNumber(token);
    print(response.body);
    setState(() {
      _numFarmer = jsonDecode(response.body)['num'].toString();
    });
  }

  Future<void> getPlantsNum() async {
    var response = await getPlantNumber(token);
    print(response.body);
    setState(() {
      _numPlant = jsonDecode(response.body)['num'].toString();
    });
  }

  Future<String?> getFarmerList() async {
    var response = await getAllFarmers(token);
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
            adminShowFarmerContent(),
            AdminCollapsingNavigationDrawer(name: username!, menuIndex: 2),
          ],
        ),
      ),
    );
  }

  Widget adminShowFarmerContent() {
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
                  "เกษตรกร",
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
            child: ListView(
              primary: false,
              padding: const EdgeInsets.only(left: 25, right: 20),
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Text(
                    'ข้อมูลผู้ใช้งาน',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  margin: const EdgeInsets.only(left: 40),
                  height: 200,
                  child: isLoading
                      ? loading()
                      : ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            CardItem(
                                title: "เกษตรกร",
                                suffix: "คน",
                                amount: _numFarmer!,
                                icon: FontAwesomeIcons.person,
                                bgColor: const Color(0xFFD7FADA),
                                textColor: const Color(0xFF56CC7E)),
                            CardItem(
                                title: "ต้นกระท่อม",
                                suffix: "ต้น",
                                amount: _numPlant!,
                                icon: FontAwesomeIcons.handHoldingDroplet,
                                bgColor: const Color(0xFFFFE9C6),
                                textColor: const Color(0xFFDA9551)),
                          ],
                        ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Expanded(
                        child: Text(
                          'รายชื่อเกษตรกร',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AdminAddFarmerPage(),
                                )).then((_) => setState(() {}));
                          },
                          icon: const Icon(Icons.add_circle_outline))
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: showFarmerLists(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget showFarmerLists() {
    return FutureBuilder(
      future: getFarmerList(),
      builder: (context, snapshot) {
        List<Widget> myList = [];

        if (snapshot.hasData) {
          List? farmers = jsonDecode(snapshot.data.toString())['farmers'];

          if (farmers!.isEmpty) {
            myList = [
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('ไม่พบข้อมูล'),
              )
            ];
          } else {
            myList = [
              Column(
                children: farmers.map((item) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListTile(
                      leading: IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AdminEditFarmerPage(
                                      farmerid: item['farmer_id']),
                                )).then((value) => setState(() {}));
                          },
                          icon: const Icon(Icons.edit)),
                      title: Text(item['name']),
                      subtitle: Text(item['ent_name']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("คงอยู่ ${item['remain']} ต้น"),
                          IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AdminShowFarmerPlantPage(
                                              farmerid: item['farmer_id']),
                                    ));
                              },
                              icon: const Icon(Icons.info)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ];
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          myList = [
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

        return Center(
          child: Column(
            children: myList,
          ),
        );
      },
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
