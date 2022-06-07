import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../commons/admin_collapsing_navigation_drawer.dart';
import '../../commons/card_info.dart';
import '../../services/admin_service.dart';
import '../../theme.dart';
import 'admin_edit_enterprise_page.dart';
import 'admin_show_member_page.dart';

class AdminShowEnterprisePage extends StatefulWidget {
  const AdminShowEnterprisePage({Key? key}) : super(key: key);

  @override
  State<AdminShowEnterprisePage> createState() =>
      _AdminShowEnterprisePageState();
}

class _AdminShowEnterprisePageState extends State<AdminShowEnterprisePage> {
  final _addEnterpriseFormKey = GlobalKey<FormState>();
  final TextEditingController _registController = TextEditingController();
  final TextEditingController _entNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _telController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  String? username;
  String? token;

  String? _numEnterprise;
  String? _numMember;

  bool isLoading = true;

  Future<void> getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("username")!;
      token = prefs.getString("token")!;
    });
    await getEnterprise();
    await getMember();
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

  Future<String?> getEnterpriseList() async {
    var response = await getAllEnterprises(token);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
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
            adminShowEnterpriseConter(),
            AdminCollapsingNavigationDrawer(name: username!, menuIndex: 1),
          ],
        ),
      ),
    );
  }

  Widget adminShowEnterpriseConter() {
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
                  "รายการ",
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
                                icon: FontAwesomeIcons.peopleGroup,
                                bgColor: const Color(0xFFD7FADA),
                                textColor: const Color(0xFF56CC7E)),
                            CardItem(
                                title: "กลุ่มวิสาหกิจ",
                                suffix: "กลุ่ม",
                                amount: _numEnterprise!,
                                icon: FontAwesomeIcons.handHoldingHand,
                                bgColor: const Color(0xFFFFE9C6),
                                textColor: const Color(0xFFDA9551)),
                          ],
                        ),
                ),
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'รายชื่อกลุ่มวิสาหกิจ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 15),
                Form(
                  key: _addEnterpriseFormKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          registInput(),
                          entNameInput(),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          addressInput(),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          nameInput(),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          telInput(),
                          passInput(),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                          ),
                          onPressed: () async {
                            if (_addEnterpriseFormKey.currentState!
                                .validate()) {
                              var json = jsonEncode({
                                "registNo": _registController.text,
                                "enterpriseName": _entNameController.text,
                                "enterpriseAddress": _addressController.text,
                                "agentName": _nameController.text,
                                "tel": _telController.text,
                                "password": _passController.text,
                              });
                              var response = await addEnterprise(json, token);
                              if (response.statusCode == 200) {
                                _registController.clear();
                                _entNameController.clear();
                                _addressController.clear();
                                _telController.clear();
                                _passController.clear();
                                _nameController.clear();
                                print("successful");
                                setState(() {});
                              }
                            }
                          },
                          child: const Text("เพิ่มกลุ่มวิสาหกิจ")),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: showEnterpriseLists(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget registInput() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        width: MediaQuery.of(context).size.width * 0.25,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          controller: _registController,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.isEmpty) {
              return "กรุณาใส่รหัสกลุ่มวิสาหกิจ";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "รหัสกลุ่มวิสาหกิจ",
            border: InputBorder.none,
            errorBorder: errorBorder,
          ),
        ),
      ),
    );
  }

  Widget entNameInput() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        width: MediaQuery.of(context).size.width * 0.5,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          controller: _entNameController,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.isEmpty) {
              return "กรุณาใส่ชื่อกลุ่มวิสาหกิจ";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "ชื่อกลุ่มวิสาหกิจ",
            border: InputBorder.none,
            errorBorder: errorBorder,
          ),
        ),
      ),
    );
  }

  Widget addressInput() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        width: MediaQuery.of(context).size.width * 0.75,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          controller: _addressController,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.isEmpty) {
              return "กรุณาใส่ที่อยู่กลุ่มวิสาหกิจ";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "ที่อยู่กลุ่มวิสาหกิจ",
            border: InputBorder.none,
            errorBorder: errorBorder,
          ),
        ),
      ),
    );
  }

  Widget nameInput() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        width: MediaQuery.of(context).size.width * 0.75,
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
        width: MediaQuery.of(context).size.width * 0.35,
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
        width: MediaQuery.of(context).size.width * 0.4,
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

  Widget showEnterpriseLists() {
    return FutureBuilder(
      future: getEnterpriseList(),
      builder: (context, snapshot) {
        List<Widget> myList = [];

        if (snapshot.hasData) {
          List? enterprises = jsonDecode(snapshot.data.toString());

          if (enterprises!.isEmpty) {
            myList = [
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('ไม่พบข้อมูล'),
              )
            ];
          } else {
            myList = [
              Column(
                children: enterprises.map((item) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(item['enterprise_name']),
                      subtitle: Text(item['name']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AdminShowMemberPage(entid: item['id']),
                                  )).then((value) {
                                setState(() {});
                              });
                            },
                            icon: const Icon(
                              Icons.remove_red_eye_rounded,
                              color: Colors.lightBlue,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AdminEditEnterprisePage(
                                            entid: item['id']),
                                  )).then((value) {
                                setState(() {});
                              });
                            },
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.lightGreen,
                            ),
                          ),
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
