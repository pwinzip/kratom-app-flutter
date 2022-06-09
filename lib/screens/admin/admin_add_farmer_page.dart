import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../commons/admin_collapsing_navigation_drawer.dart';
import '../../models/listitem_model.dart';
import '../../services/admin_service.dart';
import '../../theme.dart';

class AdminAddFarmerPage extends StatefulWidget {
  const AdminAddFarmerPage({Key? key}) : super(key: key);

  @override
  State<AdminAddFarmerPage> createState() => _AdminAddFarmerPageState();
}

class _AdminAddFarmerPageState extends State<AdminAddFarmerPage> {
  final _addFarmerFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _longController = TextEditingController();
  final TextEditingController _receivedController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _telController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String? username;
  String? token;

  List<ListItems>? dropdownItems;
  List<DropdownMenuItem<ListItems>>? dropdownMenuItems;
  ListItems? _selectedItem;

  bool isLoading = true;
  bool _noEnterpriseAdded = false;

  Future<void> getSharedPreferences() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    SharedPreferences prefs = await _prefs;
    setState(() {
      username = prefs.getString("username")!;
      token = prefs.getString("token")!;
    });
    await getEnterpriseList();
  }

  Future<void> getEnterpriseList() async {
    var response = await getAllEnterprises(token);

    if (response.statusCode == 200) {
      List<dynamic> json = jsonDecode(response.body);

      if (json.isEmpty) {
        setState(() {
          _noEnterpriseAdded = true;
          isLoading = false;
        });
      } else {
        setState(() {
          dropdownItems = json.map<ListItems>((item) {
            return ListItems(item['id'], item['enterprise_name']);
          }).toList();

          dropdownMenuItems = buildDropdownMenuItem(dropdownItems);
          _selectedItem = dropdownMenuItems![0].value;

          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    getSharedPreferences();
    super.initState();
  }

  List<DropdownMenuItem<ListItems>> buildDropdownMenuItem(
      List<ListItems>? listItems) {
    List<DropdownMenuItem<ListItems>> items = [];
    for (ListItems listitem in listItems!) {
      items.add(
        DropdownMenuItem(
          value: listitem,
          child: Text(listitem.value!),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            addFarmerContent(),
            AdminCollapsingNavigationDrawer(
              name: username!,
              menuIndex: 2,
              maxWidth: MediaQuery.of(context).size.width * 0.55,
            ),
          ],
        ),
      ),
    );
  }

  Widget addFarmerContent() {
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
                      size: 28,
                      color: Colors.white,
                    )),
                const SizedBox(width: 10),
                const Text(
                  "เพิ่ม",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    "เกษตรกร",
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
            child: ListView(
              primary: false,
              padding: const EdgeInsets.only(left: 25, right: 20),
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Text(
                    'เพิ่มข้อมูลเกษตรกร',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 15),
                _noEnterpriseAdded
                    ? noEnterpriseList()
                    : isLoading
                        ? loading()
                        : Form(
                            key: _addFarmerFormKey,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    nameInput(),
                                    addressInput(),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    telInput(),
                                    passInput(),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    latInput(),
                                    longInput(),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    areaInput(),
                                    receivedInput(),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    dropdownEnterprise(),
                                    ElevatedButton(
                                        onPressed: () async {
                                          if (_addFarmerFormKey.currentState!
                                              .validate()) {
                                            var json = jsonEncode({
                                              "farmerName":
                                                  _nameController.text,
                                              "farmerTel": _telController.text,
                                              "farmerPassword":
                                                  _passController.text,
                                              "farmerAddress":
                                                  _addressController.text,
                                              "farmerArea":
                                                  _areaController.text,
                                              "farmerLat": _latController.text,
                                              "farmerLong":
                                                  _longController.text,
                                              "farmerReceived":
                                                  _receivedController.text,
                                              "enterpriseId": _selectedItem!.id,
                                              "isActive": 1,
                                            });
                                            var response =
                                                await addFarmer(json, token);
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

  Widget dropdownEnterprise() {
    return DropdownButton(
      value: _selectedItem,
      items: dropdownMenuItems,
      onChanged: (ListItems? value) {
        setState(() {
          _selectedItem = value;
        });
        print(_selectedItem!.id);
      },
    );
  }

  Widget nameInput() {
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
          controller: _nameController,
          validator: (value) {
            if (value!.isEmpty) {
              return "กรุณาใส่ชื่อ นามสกุล";
            }
            return null;
          },
          decoration: defaultInputDecoration("ชื่อ นามสกุล"),
        ),
      ),
    );
  }

  Widget addressInput() {
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
          controller: _addressController,
          validator: (value) {
            if (value!.isEmpty) {
              return "กรุณาใส่ที่อยู่";
            }
            return null;
          },
          decoration: defaultInputDecoration("ที่อยู่"),
        ),
      ),
    );
  }

  Widget telInput() {
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
          controller: _telController,
          validator: (value) {
            if (value!.isEmpty) {
              return "กรุณาใส่เบอร์โทรศัพท์";
            }
            return null;
          },
          decoration: defaultInputDecoration("เบอร์โทรศัพท์"),
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
          decoration: defaultInputDecoration("รหัสผ่าน"),
        ),
      ),
    );
  }

  Widget latInput() {
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
          controller: _latController,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.isEmpty) {
              return "กรุณาใส่ละติจูด";
            }
            return null;
          },
          decoration: defaultInputDecoration("ละติจูด"),
        ),
      ),
    );
  }

  Widget longInput() {
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
          controller: _longController,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.isEmpty) {
              return "กรุณาใส่ลองติจูด";
            }
            return null;
          },
          decoration: defaultInputDecoration("ลองติจูด"),
        ),
      ),
    );
  }

  Widget areaInput() {
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
          controller: _areaController,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.isEmpty) {
              return "กรุณาใส่พื้นที่ปลูก";
            }
            return null;
          },
          decoration: defaultInputDecoration("พื้นที่ปลูก", suffix: "ไร่"),
        ),
      ),
    );
  }

  Widget receivedInput() {
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
          controller: _receivedController,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.isEmpty) {
              return "กรุณาใส่จำนวนที่ได้รับ";
            }
            return null;
          },
          decoration: defaultInputDecoration("จำนวนที่ได้รับ", suffix: "ต้น"),
        ),
      ),
    );
  }

  Widget noEnterpriseList() {
    return Center(
        child: Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Text(
        "โปรดเพิ่มข้อมูลกลุ่มวิสาหกิจก่อน !!",
        style: TextStyle(
            color: Colors.green[800],
            fontSize: 18,
            fontWeight: FontWeight.w600),
      ),
    ));
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
