import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

import '../../commons/card_info.dart';
import '../../commons/enterprise_collapsing_navigation_drawer.dart';
import '../../commons/format_buddhist_year.dart';
import '../../services/enterprise_service.dart';
import '../../theme.dart';

class EnterpriseMainPage extends StatefulWidget {
  const EnterpriseMainPage({Key? key}) : super(key: key);

  @override
  State<EnterpriseMainPage> createState() => _EnterpriseMainPageState();
}

class _EnterpriseMainPageState extends State<EnterpriseMainPage> {
  final _addSaleFormKey = GlobalKey<FormState>();
  final TextEditingController _saleDateController = TextEditingController();
  final TextEditingController _saleAmountController = TextEditingController();
  final DateRangePickerController _saleDatePickerController =
      DateRangePickerController();

  String? username;
  int? enterpriseid;
  String? enterprisename;
  String? token;

  String _registNo = "";
  String _numMember = "";
  String _numPlant = "";
  bool isLoading = true;

  Future<void> getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("username")!;
      enterpriseid = prefs.getInt("enterpriseid")!;
      enterprisename = prefs.getString("enterprisename")!;
      token = prefs.getString("token")!;
    });
    await getMembers();
    await getEnterpriseInfo();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getEnterpriseInfo() async {
    var response = await getEnterpriseMembers(enterpriseid, token);
    setState(() {
      _registNo =
          jsonDecode(response.body)['enterprise']['regist_no'].toString();
    });
  }

  Future<void> getMembers() async {
    var response = await getEnterpriseMembers(enterpriseid, token);
    setState(() {
      _numMember = jsonDecode(response.body)['memberAmount'].toString();
      _numPlant = jsonDecode(response.body)['plantAmount'].toString();
    });
  }

  Future<String?> getEnterpriseSale() async {
    var response = await getSales(enterpriseid, token);
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
            enterpriseMainContent(),
            EnterpriseCollapsingNavigationDrawer(
              name: username!,
              menuIndex: 0,
              maxWidth: MediaQuery.of(context).size.width * 0.55,
            ),
          ],
        ),
      ),
    );
  }

  Widget enterpriseMainContent() {
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
            child: isLoading
                ? loading()
                : ListView(
                    padding: const EdgeInsets.only(left: 25, right: 20),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Row(
                          children: [
                            Text(
                              _registNo,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                enterprisename!,
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        margin: const EdgeInsets.only(left: 20),
                        height: 200,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            CardItem(
                                title: "สมาชิก",
                                suffix: "คน",
                                amount: _numMember,
                                icon: FontAwesomeIcons.peopleGroup,
                                bgColor: const Color(0xFFD7FADA),
                                textColor: const Color(0xFF56CC7E)),
                            CardItem(
                                title: "ต้นกระท่อม",
                                suffix: "ต้น",
                                amount: _numPlant,
                                icon: FontAwesomeIcons.handHoldingDroplet,
                                bgColor: const Color(0xFFFFE9C6),
                                textColor: const Color(0xFFDA9551)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 15),
                      Form(
                        key: _addSaleFormKey,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                saleDateInput(),
                                saleAmountInput(),
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
                                if (_addSaleFormKey.currentState!.validate()) {
                                  var json = jsonEncode({
                                    "saleDate": _saleDateController.text,
                                    "saleAmount": _saleAmountController.text,
                                  });
                                  var response =
                                      await addSale(json, enterpriseid, token);
                                  print(response.statusCode);
                                  if (response.statusCode == 200) {
                                    _saleDateController.clear();
                                    _saleAmountController.clear();
                                    print("successful");
                                    setState(() {});
                                  }
                                }
                              },
                              child: const Text("แจ้งความต้องการขาย"),
                            ),
                          ],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "ประวัติบันทึกการขาย",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: showEnterpriseSale()),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget showEnterpriseSale() {
    return FutureBuilder(
      future: getEnterpriseSale(),
      builder: (context, snapshot) {
        List<Widget> myWidgetList = [];

        if (snapshot.hasData) {
          Map<String, dynamic> data = jsonDecode(snapshot.data.toString());
          print(data);
          List? sales = data['sale'];

          if (sales!.isEmpty) {
            myWidgetList = [
              const Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('ไม่พบข้อมูล'),
              )
            ];
            // myWidgetList.add(const Padding(
            //   padding: EdgeInsets.only(top: 16),
            //   child: Text('ไม่พบข้อมูล'),
            // ));
          } else {
            myWidgetList = [
              Column(
                children: sales.map((item) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: ListTile(
                      title: const Text("วันที่ทำรายการ"),
                      subtitle: Text(formatBuddhistYear(
                          DateFormat('dd/MM/yyyy'),
                          DateTime.parse(item['created_at']))),
                      trailing: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.calendar_month),
                              const SizedBox(width: 10),
                              Text(DateFormat('dd/MM/yyyy').format(
                                  DateTime.parse(item['date_for_sale'])
                                      .toLocal())),
                              //
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.shopping_cart_outlined),
                              const SizedBox(width: 10),
                              Text("${item['quantity_for_sale']} กิโลกรัม"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              )
            ];
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          myWidgetList = [loading()];
        }

        return Center(
          child: Column(
            children: myWidgetList,
          ),
        );
      },
    );
  }

  Widget saleAmountInput() {
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
          controller: _saleAmountController,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.isEmpty) {
              return "กรุณาใส่ปริมาณที่ต้องการขาย";
            }
            return null;
          },
          decoration: InputDecoration(
            suffixText: "กิโลกรัม",
            hintText: "ปริมาณที่ต้องการขาย",
            border: InputBorder.none,
            errorBorder: errorBorder,
          ),
        ),
      ),
    );
  }

  Widget saleDateInput() {
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
          controller: _saleDateController,
          readOnly: true,
          onTap: () {
            var alertDialog = AlertDialog(
              content: datePicker(),
            );
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alertDialog;
                });
          },
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.calendar_month_outlined),
            hintText: "วันที่ต้องการขาย",
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget datePicker() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width * 0.8,
      child: SfDateRangePicker(
        controller: _saleDatePickerController,
        showNavigationArrow: true,
        onSubmit: (value) {
          Navigator.pop(context);
        },
        onCancel: () {
          Navigator.pop(context);
        },
        onSelectionChanged: _onSelectionChanged,
        selectionMode: DateRangePickerSelectionMode.single,
        enablePastDates: false,
        // initialDisplayDate: DateTime.now(),
        initialSelectedDate: DateTime.now().add(const Duration(days: 7)),
        minDate: DateTime.now().add(const Duration(days: 7)),
      ),
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _saleDateController.text =
          formatBuddhistYear(DateFormat("dd/MM/yyyy"), args.value);
      // _saleDateController.text = DateFormat('dd/MM/yyyy').format(args.value);
    });
    Navigator.pop(context);
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
