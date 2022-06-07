import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import '../../commons/admin_collapsing_navigation_drawer.dart';
import '../../services/enterprise_service.dart';

class AdminShowEnterpriseSalePage extends StatefulWidget {
  final int? entid;
  const AdminShowEnterpriseSalePage({Key? key, this.entid}) : super(key: key);

  @override
  State<AdminShowEnterpriseSalePage> createState() =>
      _AdminShowEnterpriseSalePageState();
}

class _AdminShowEnterpriseSalePageState
    extends State<AdminShowEnterpriseSalePage> {
  String? username;
  String? token;

  bool isLoading = true;

  Future<void> getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("username")!;
      token = prefs.getString("token")!;
    });
    setState(() {
      isLoading = false;
    });
  }

  Future<String?> getEnterpriseSale() async {
    var response = await getSales(widget.entid, token);
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
            adminShowEnterpriseSaleContent(),
            AdminCollapsingNavigationDrawer(name: username!, menuIndex: 1),
          ],
        ),
      ),
    );
  }

  Widget adminShowEnterpriseSaleContent() {
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
                    )),
                const SizedBox(width: 10),
                const Text(
                  "ข้อมูล",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
                const SizedBox(width: 10),
                const Text(
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
            child: isLoading ? loading() : showEnterpriseSaleLists(),
          ),
        ],
      ),
    );
  }

  Widget showEnterpriseSaleLists() {
    return FutureBuilder(
      future: getEnterpriseSale(),
      builder: (context, snapshot) {
        List<Widget> myWidgetList = [];

        if (snapshot.hasData) {
          Map<String, dynamic> data = jsonDecode(snapshot.data.toString());
          print(data);
          var jsonEnterprise = data['enterprise'];
          var jsonAgent = data['agent'];
          List? sales = data['sale'];

          myWidgetList.add(entNameHeader(jsonEnterprise, jsonAgent));
          myWidgetList.add(const SizedBox(height: 8));

          if (sales!.isEmpty) {
            myWidgetList.add(const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text('ไม่พบข้อมูล'),
            ));
          } else {
            myWidgetList.add(
              Column(
                children: sales.map((item) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListTile(
                      title: const Text("วันที่ทำรายการ"),
                      subtitle: Text(DateFormat('dd/MM/yyyy')
                          .format(DateTime.parse(item['created_at']))),
                      trailing: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.calendar_month),
                              Text(DateFormat('dd/MM/yyyy').format(
                                  DateTime.parse(item['date_for_sale']))),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.numbers),
                              Text("${item['quantity_for_sale']} กิโลกรัม"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
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

  Widget entNameHeader(jsonEnterprise, jsonAgent) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                jsonEnterprise['regist_no'],
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 10),
              Text(
                jsonEnterprise['enterprise_name'],
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                jsonEnterprise['address'],
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                'ชื่อตัวแทน',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 10),
              Text(
                jsonAgent['name'],
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
              ),
            ],
          ),
          Row(
            children: [
              const Text(
                'เบอร์โทรศัพท์',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 10),
              Text(
                jsonAgent['tel'],
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Divider(),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text("ประวัติการแจ้งความต้องการขาย"),
          ),
        ],
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
