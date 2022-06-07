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
  String? username;
  String? token;

  final _addFarmerFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _longController = TextEditingController();
  final TextEditingController _receivedController = TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _telController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  List<ListItems>? dropdownItems;
  List<DropdownMenuItem<ListItems>>? dropdownMenuItems;
  ListItems? _selectedItem;

  bool isLoading = true;

  Future<void> getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("username")!;
      token = prefs.getString("token")!;
    });
    await getEnterpriseList();
  }

  Future<void> getEnterpriseList() async {
    var response = await getAllEnterprises(token);
    var json = jsonDecode(response.body);
    print(json);

    setState(() {
      dropdownItems = json.map<ListItems>((item) {
        return ListItems(item['id'], item['enterprise_name']);
      }).toList();
      print(dropdownItems![0].value);

      dropdownMenuItems = buildDropdownMenuItem(dropdownItems);
      _selectedItem = dropdownMenuItems![0].value;

      isLoading = false;
    });
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
            AdminCollapsingNavigationDrawer(name: username!, menuIndex: 2),
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
            padding: const EdgeInsets.only(left: 40),
            child: Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.chevron_left)),
                const SizedBox(width: 10),
                const Text(
                  "เพิ่ม",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
                const SizedBox(width: 10),
                const Text(
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
                    'เพิ่มข้อมูลเกษตรกร',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 15),
                isLoading
                    ? loading()
                    : Form(
                        key: _addFarmerFormKey,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                nameInput(),
                                addressInput(),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                telInput(),
                                passInput(),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                latInput(),
                                longInput(),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                areaInput(),
                                receivedInput(),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                dropdownEnterprise(),
                                ElevatedButton(
                                    onPressed: () async {
                                      if (_addFarmerFormKey.currentState!
                                          .validate()) {
                                        var json = jsonEncode({
                                          "farmerName": _nameController.text,
                                          "farmerTel": _telController.text,
                                          "farmerPassword":
                                              _passController.text,
                                          "farmerAddress":
                                              _addressController.text,
                                          "farmerArea": _areaController.text,
                                          "farmerLat": _latController.text,
                                          "farmerLong": _longController.text,
                                          "farmerReceived":
                                              _receivedController.text,
                                          "enterpriseId": _selectedItem!.id,
                                          "isActive": 1,
                                        });
                                        var response =
                                            await addFarmer(json, token);
                                        if (response.statusCode == 200) {
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
          decoration: InputDecoration(
            hintText: "ชื่อ นามสกุล",
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
          decoration: InputDecoration(
            hintText: "ที่อยู่",
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
          validator: (value) {
            if (value!.isEmpty) {
              return "กรุณาใส่ละติจูด";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "ละติจูด",
            border: InputBorder.none,
            errorBorder: errorBorder,
          ),
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
          validator: (value) {
            if (value!.isEmpty) {
              return "กรุณาใส่ลองติจูด";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "ลองติจูด",
            border: InputBorder.none,
            errorBorder: errorBorder,
          ),
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
          validator: (value) {
            if (value!.isEmpty) {
              return "กรุณาใส่พื้นที่ปลูก";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "พื้นที่ปลูก",
            suffixText: "ไร่",
            border: InputBorder.none,
            errorBorder: errorBorder,
          ),
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
          validator: (value) {
            if (value!.isEmpty) {
              return "กรุณาใส่จำนวนที่ได้รับ";
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: "จำนวนที่ได้รับ",
            suffixText: "ต้น",
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
