import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../../commons/card_plant.dart';
import '../../commons/farmer_collapsing_navigation_drawer.dart';
import '../../services/farmer_service.dart';

class FarmerPlantPage extends StatefulWidget {
  const FarmerPlantPage({Key? key}) : super(key: key);

  @override
  State<FarmerPlantPage> createState() => _FarmerPlantPageState();
}

class _FarmerPlantPageState extends State<FarmerPlantPage> {
  String? username;
  int? farmerid;
  String? enterprisename;
  String? agentname;
  String? token;

  bool isLoading = true;

  Future<void> getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("username")!;
      farmerid = prefs.getInt('farmerid')!;
      enterprisename = prefs.getString("enterprisename")!;
      agentname = prefs.getString("agentname")!;
      token = prefs.getString("token")!;

      isLoading = false;
    });
  }

  Future<String?> getFarmerPlant() async {
    var response = await getAllPlants(farmerid, token);
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
          plantsContent(),
          FarmerCollapsingNavigationDrawer(
            name: username!,
            menuIndex: 1,
            maxWidth: MediaQuery.of(context).size.width * 0.55,
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
        shrinkWrap: true,
        children: [
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Row(
              children: const [
                Text(
                  "ประวัติ",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
                SizedBox(width: 10),
                Text(
                  "บันทึกการปลูก",
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
            child: isLoading ? loading() : showFarmerPlants(),
          ),
        ],
      ),
    );
  }

  Widget showFarmerPlants() {
    return FutureBuilder(
      future: getFarmerPlant(),
      builder: (context, snapshot) {
        List<Widget> myWidgetList = [];

        if (snapshot.hasData) {
          Map<String, dynamic> data = jsonDecode(snapshot.data.toString());
          print(data);
          var jsonFarmer = data['farmer'];
          var jsonUser = data['user'];
          var jsonEnterprise = data['enterprise'];
          List? plants = data['plant'];

          myWidgetList.add(farmerProfile(jsonFarmer, jsonUser, jsonEnterprise));
          myWidgetList.add(const Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: Divider(),
          ));
          myWidgetList.add(const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              "ประวัติการบันทึกการปลูก",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ));

          if (plants!.isEmpty) {
            myWidgetList.add(const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('ไม่พบข้อมูล'),
            ));
          } else {
            myWidgetList.add(
              ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: plants.map((item) {
                  return Container(
                    padding: const EdgeInsets.only(top: 15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              "วันที่บันทึก",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 5),
                            Text(DateFormat('dd MMMM yyyy', 'th').format(
                                DateTime.parse(item['created_at']).toLocal())),
                            const SizedBox(width: 10),
                            const Text(
                              "เวลา",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 5),
                            Text(DateFormat('Hms', 'th').format(
                                DateTime.parse(item['created_at']).toLocal())),
                          ],
                        ),
                        Row(
                          children: [
                            CardPlant(
                              width: 80,
                              title: "คงอยู่",
                              suffix: "ต้น",
                              value: item['remain_plant'].toString(),
                              icon: FontAwesomeIcons.seedling,
                              bgColor: const Color.fromRGBO(255, 233, 198, 1),
                              textColor: const Color.fromRGBO(218, 149, 81, 1),
                            ),
                            CardPlant(
                              width: 80,
                              title: "ปลูกเพิ่ม",
                              suffix: "ต้น",
                              value: item['addon_plant'].toString(),
                              icon: FontAwesomeIcons.handHoldingDroplet,
                              bgColor: const Color.fromRGBO(194, 227, 254, 1),
                              textColor: const Color.fromRGBO(106, 140, 170, 1),
                            ),
                            CardPlant(
                              width: 95,
                              title: "เก็บเกี่ยว",
                              value: DateFormat('dd/MM/yyyy').format(
                                  DateTime.parse(item['date_for_sale'])),
                              icon: FontAwesomeIcons.envira,
                              bgColor: const Color.fromRGBO(215, 250, 218, 1),
                              textColor: const Color.fromRGBO(86, 204, 126, 1),
                            ),
                            CardPlant(
                              width: 95,
                              title: "ปริมาณที่ได้",
                              suffix: "กก.",
                              value: item['quantity_for_sale'].toString(),
                              icon: FontAwesomeIcons.envira,
                              bgColor: const Color.fromRGBO(233, 215, 250, 1),
                              textColor: const Color.fromRGBO(161, 86, 204, 1),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: Row(
                              children: [
                                const Text(
                                  "สายพันธุ์ที่ปลูกเพิ่ม",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                                const SizedBox(width: 15),
                                Text(
                                  item['addon_species'].toString(),
                                  softWrap: true,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 16),
                                )
                              ],
                            ),
                          ),
                        ),
                        item == plants.last
                            ? Container(height: 16)
                            : const Divider(),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          myWidgetList = [loading()];
        }

        return Container(
          child: ListView(
            // primary: false,
            shrinkWrap: true,
            padding: const EdgeInsets.only(left: 25, right: 20),
            children: myWidgetList,
          ),
        );
      },
    );
  }

  Widget farmerProfile(jsonFarmer, jsonUser, jsonEnterprise) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        decoration: const BoxDecoration(
          // color: Color(0xFFECFBD1),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                const Icon(Icons.account_box),
                const SizedBox(width: 20),
                Text(
                  jsonUser['name'],
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.call),
                const SizedBox(width: 20),
                Text(
                  "${jsonUser['tel']}",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w300),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.home),
                const SizedBox(width: 20),
                Text(
                  "ที่อยู่: ${jsonFarmer['address']}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w300),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.location_on),
                const SizedBox(width: 20),
                Text(
                  "(${jsonFarmer['lat']}, ${jsonFarmer['long']})",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w300),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                const Icon(Icons.info_outline),
                const SizedBox(width: 20),
                Text(
                  "พื้นที่: ${jsonFarmer['area']} ไร่",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w300),
                ),
                const SizedBox(width: 30),
                Text(
                  "จำนวนที่ได้รับ: ${jsonFarmer['received_amount']} ต้น",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w300),
                ),
              ],
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Text(
                    "สังกัดกลุ่ม: ${jsonEnterprise['enterprise_name']}",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
