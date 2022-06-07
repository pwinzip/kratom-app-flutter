import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../../commons/admin_collapsing_navigation_drawer.dart';
import '../../services/farmer_service.dart';

class AdminShowFarmerPlantPage extends StatefulWidget {
  final int? farmerid;
  const AdminShowFarmerPlantPage({Key? key, this.farmerid}) : super(key: key);

  @override
  State<AdminShowFarmerPlantPage> createState() =>
      _AdminShowFarmerPlantPageState();
}

class _AdminShowFarmerPlantPageState extends State<AdminShowFarmerPlantPage> {
  String? username;
  String? token;
  bool isLoading = true;

  Future<void> getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("username")!;
      token = prefs.getString("token")!;

      isLoading = false;
    });
  }

  Future<String?> getFarmerPlant() async {
    var response = await getAllPlants(widget.farmerid, token);
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
            adminShowFarmerPlantContent(),
            AdminCollapsingNavigationDrawer(name: username!, menuIndex: 2),
          ],
        ),
      ),
    );
  }

  Widget adminShowFarmerPlantContent() {
    return Container(
      margin: const EdgeInsets.only(left: 70),
      color: const Color(0xFF21BFBD),
      child: ListView(
        children: [
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.chevron_left,
                    size: 28,
                    color: Colors.white,
                  ),
                ),
                const Text(
                  "ประวัติ",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
                const SizedBox(width: 10),
                const Text(
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
            child: isLoading ? loading() : showFarmerPlantLists(),
          ),
        ],
      ),
    );
  }

  Widget showFarmerPlantLists() {
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
              SizedBox(
                width: double.infinity,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("วันที่บันทึก")),
                        DataColumn(label: Text("คงอยู่ (ต้น)")),
                        DataColumn(label: Text("ปลูกเพิ่ม (ต้น)")),
                        DataColumn(label: Text("คาดว่าเก็บเกี่ยว")),
                        DataColumn(label: Text("ปริมาณที่จะได้ (กิโลกรัม)")),
                      ],
                      rows: plants.map((item) {
                        return DataRow(cells: [
                          DataCell(Text(DateFormat('dd/MM/yyyy')
                              .format(DateTime.parse(item['created_at'])))),
                          DataCell(Text("${item['remain_plant']}")),
                          DataCell(Column(
                            children: [
                              Text("${item['addon_plant']}"),
                              Text("${item['addon_species']}")
                            ],
                          )),
                          DataCell(Text(DateFormat('dd/MM/yyyy')
                              .format(DateTime.parse(item['date_for_sale'])))),
                          DataCell(Text("${item['quantity_for_sale']}")),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            );
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          myWidgetList = [loading()];
        }

        return ListView(
          primary: false,
          padding: const EdgeInsets.only(left: 25, right: 20),
          children: myWidgetList,
        );
      },
    );
  }

  Widget farmerProfile(jsonFarmer, jsonUser, jsonEnterprise) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: const BoxDecoration(
          // color: Color(0xFFECFBD1),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Text(
                  jsonUser['name'],
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 50),
                const Text(
                  "เบอร์โทรศัพท์: ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
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
                Text(
                  "ละติจูด: ${jsonFarmer['lat']}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w300),
                ),
                const SizedBox(width: 50),
                Text(
                  "ลองติจูด: ${jsonFarmer['long']}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w300),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Text(
                  "พื้นที่: ${jsonFarmer['area']} ไร่",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w300),
                ),
                const SizedBox(width: 50),
                Text(
                  "จำนวนที่ได้รับ: ${jsonFarmer['received_amount']} ต้น",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w300),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Text(
                  "สังกัดกลุ่ม: ${jsonEnterprise['enterprise_name']}",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w300),
                ),
              ],
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
