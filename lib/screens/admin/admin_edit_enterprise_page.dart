import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../commons/admin_collapsing_navigation_drawer.dart';
import '../../services/enterprise_service.dart';
import '../../theme.dart';

class AdminEditEnterprisePage extends StatefulWidget {
  final int? entid;
  const AdminEditEnterprisePage({Key? key, this.entid}) : super(key: key);

  @override
  State<AdminEditEnterprisePage> createState() =>
      _AdminEditEnterprisePageState();
}

class _AdminEditEnterprisePageState extends State<AdminEditEnterprisePage> {
  final _editEnterpriseFormKey = GlobalKey<FormState>();
  final TextEditingController _registController = TextEditingController();
  final TextEditingController _entNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _telController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  String? username;
  String? token;

  bool isLoading = true;
  bool? _status;

  Future<void> getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("username")!;
      token = prefs.getString("token")!;
    });
    await getEnterpriseData();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getEnterpriseData() async {
    var response = await getEnterpriseMembers(widget.entid, token);
    var jsonEnterprise = jsonDecode(response.body)['enterprise'];
    var jsonAgent = jsonDecode(response.body)['agent'];
    print(response.body);

    setState(() {
      _registController.text = jsonEnterprise['regist_no'];
      _entNameController.text = jsonEnterprise['enterprise_name'];
      _addressController.text = jsonEnterprise['address'];
      _nameController.text = jsonAgent['name'];
      _telController.text = jsonAgent['tel'];
      _status = jsonEnterprise['is_active'] == 1 ? true : false;
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
            adminEditEnterpriseConter(),
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

  Widget adminEditEnterpriseConter() {
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
                  "แก้ไข",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
                const SizedBox(width: 10),
                const Text(
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
            child: isLoading
                ? loading()
                : ListView(
                    primary: false,
                    padding: const EdgeInsets.only(left: 25, right: 20),
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          'แก้ไขกลุ่มวิสาหกิจ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Form(
                        key: _editEnterpriseFormKey,
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
                            SwitchListTile(
                              title: const Text('เปิดใช้งาน'),
                              value: _status!,
                              onChanged: (bool value) {
                                setState(() {
                                  _status = value;
                                });
                              },
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
                                  if (_editEnterpriseFormKey.currentState!
                                      .validate()) {
                                    var json = jsonEncode({
                                      "registNo": _registController.text,
                                      "enterpriseName": _entNameController.text,
                                      "enterpriseAddress":
                                          _addressController.text,
                                      "agentName": _nameController.text,
                                      "agentTel": _telController.text,
                                      "agentPassword": _passController.text,
                                      "isActive": _status! ? 1 : 0,
                                    });
                                    var response = await editEnterprise(
                                        json, widget.entid, token);
                                    if (response.statusCode == 200) {
                                      await Future.delayed(
                                          const Duration(seconds: 1));

                                      if (!mounted) return;
                                      Navigator.pop(context);
                                    }
                                  }
                                },
                                child: const Text("บันทึกข้อมูล")),
                          ],
                        ),
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
          decoration: InputDecoration(
            hintText: "รหัสผ่าน",
            helperText: "เว้นว่าง หากไม่ต้องการเปลี่ยนรหัสผ่าน",
            helperStyle: TextStyle(color: Colors.blue[600]),
            border: InputBorder.none,
            errorBorder: errorBorder,
          ),
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
