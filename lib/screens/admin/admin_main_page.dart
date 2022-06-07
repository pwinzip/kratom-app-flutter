import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../commons/admin_collapsing_navigation_drawer.dart';
import '../../commons/card_info.dart';
import '../../services/admin_service.dart';
import '../../theme.dart';

class AdminMainPage extends StatefulWidget {
  const AdminMainPage({Key? key}) : super(key: key);

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  final _addAdminFormKey = GlobalKey<FormState>();
  final TextEditingController _telController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  String? username;
  String? token;

  String? _numEnterprise;
  String? _numMember;
  String? _numAgent;

  bool isLoading = true;

  Future<void> getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("username")!;
      token = prefs.getString("token")!;
    });
    await getEnterprise();
    await getMember();
    await getAgent();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getEnterprise() async {
    var response = await getEnterpriseNumber(token);
    setState(() {
      _numEnterprise = jsonDecode(response.body)['num'].toString();
    });
  }

  Future<void> getMember() async {
    var response = await getFarmerNumber(token);
    setState(() {
      _numMember = jsonDecode(response.body)['num'].toString();
    });
  }

  Future<void> getAgent() async {
    var response = await getAgentNumber(token);
    setState(() {
      _numAgent = jsonDecode(response.body)['num'].toString();
    });
  }

  Future<String?> getAdminList() async {
    var response = await getAllAdmins(token);

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
            adminContent(),
            AdminCollapsingNavigationDrawer(name: username!, menuIndex: 0),
          ],
        ),
      ),
    );
  }

  Widget adminContent() {
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
                  "หน้าหลัก",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
                SizedBox(width: 10),
                Text(
                  "ผู้ดูแลระบบ",
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
                                amount: _numMember!,
                                icon: FontAwesomeIcons.person,
                                bgColor: const Color(0xFFD7FADA),
                                textColor: const Color(0xFF56CC7E)),
                            CardItem(
                                title: "กลุ่มวิสาหกิจ",
                                suffix: "กลุ่ม",
                                amount: _numEnterprise!,
                                icon: FontAwesomeIcons.peopleGroup,
                                bgColor: const Color(0xFFFFE9C6),
                                textColor: const Color(0xFFDA9551)),
                            CardItem(
                                title: "ตัวแทน",
                                suffix: "คน",
                                amount: _numAgent!,
                                icon: FontAwesomeIcons.briefcase,
                                bgColor: const Color(0xFFC2E3FE),
                                textColor: const Color(0xFF6A8CAA)),
                          ],
                        ),
                ),
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    'รายชื่อผู้ดูแลระบบ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 15),
                Form(
                  key: _addAdminFormKey,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          nameInput(),
                          telInput(),
                          passInput(),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                          onPressed: () async {
                            if (_addAdminFormKey.currentState!.validate()) {
                              var json = jsonEncode({
                                "tel": _telController.text,
                                "password": _passController.text,
                                "name": _nameController.text,
                                "role": 0,
                              });
                              var response = await addAdmin(json, token);
                              if (response.statusCode == 200) {
                                _telController.text = "";
                                _passController.text = "";
                                _nameController.text = "";
                                print("successful");
                                setState(() {});
                              }
                            }
                          },
                          child: const Text("เพิ่มผู้ดูแล"))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: showAdminLists(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget nameInput() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        width: MediaQuery.of(context).size.width * 0.3,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          controller: _nameController,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.isEmpty) {
              return "กรุณาใส่ชื่อ นามสกุล";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "ชื่อ นามสกุล",
            border: InputBorder.none,
            errorBorder: errorBorder,
          ),
        ),
      ),
    );
  }

  Widget telInput() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        width: MediaQuery.of(context).size.width * 0.2,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          controller: _telController,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.isEmpty) {
              return "กรุณาใส่เบอร์โทรศัพท์";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "เบอร์โทรศัพท์",
            border: InputBorder.none,
            errorBorder: errorBorder,
          ),
        ),
      ),
    );
  }

  Widget passInput() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        width: MediaQuery.of(context).size.width * 0.2,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          controller: _passController,
          validator: (value) {
            if (value!.isEmpty) {
              return "กรุณาใส่รหัสผ่าน";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "รหัสผ่าน",
            border: InputBorder.none,
            errorBorder: errorBorder,
          ),
        ),
      ),
    );
  }

  Widget showAdminLists() {
    return FutureBuilder(
      future: getAdminList(),
      builder: (context, snapshot) {
        List<Widget> myList = [];

        if (snapshot.hasData) {
          List? admins = jsonDecode(snapshot.data.toString());

          if (admins!.isEmpty) {
            myList = [
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('ไม่พบข้อมูล'),
              )
            ];
          } else {
            myList = [
              Column(
                children: admins.map((item) {
                  // bool adminStatus =
                  //     item['is_active'].toString() == "1" ? true : false;
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(item['name']),
                      subtitle: Text(item['tel']),
                      // trailing: Row(
                      //   mainAxisSize: MainAxisSize.min,
                      //   children: [
                      //     Switch(
                      //         value: adminStatus,
                      //         onChanged: (val) async {
                      //           setState(() {
                      //             adminStatus = val;
                      //           });

                      //           await changeUserStatus(item['id'], token);
                      //         }),
                      //   ],
                      // ),
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
