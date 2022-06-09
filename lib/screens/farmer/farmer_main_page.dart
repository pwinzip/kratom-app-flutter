import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kratomapp/commons/format_buddhist_year.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

import '../../commons/card_info.dart';
import '../../commons/farmer_collapsing_navigation_drawer.dart';
import '../../services/farmer_service.dart';
import '../../theme.dart';
import 'farmer_plant_page.dart';

class FarmerMainPage extends StatefulWidget {
  const FarmerMainPage({Key? key}) : super(key: key);

  @override
  State<FarmerMainPage> createState() => _FarmerMainPageState();
}

class _FarmerMainPageState extends State<FarmerMainPage> {
  final _farmerFormKey = GlobalKey<FormState>();
  final TextEditingController _remainController = TextEditingController();
  final TextEditingController _addonController = TextEditingController();
  final TextEditingController _speciesController = TextEditingController();
  final TextEditingController _harvestDateController = TextEditingController();
  final TextEditingController _harvestController = TextEditingController();

  final DateRangePickerController _harvestDatePickerController =
      DateRangePickerController();

  String? _username;
  int? _farmerid;
  // String? _enterprisename;
  // String? _agentname;
  String? _token;

  String? _remainPlants;
  String? _addonPlants;
  bool isLoading = true;

  Future<void> getSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString("username")!;
      _farmerid = prefs.getInt('farmerid')!;
      // _enterprisename = prefs.getString("enterprisename")!;
      // _agentname = prefs.getString("agentname")!;
      _token = prefs.getString("token")!;
    });
    await getPlants();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> getPlants() async {
    var response = await getPlantAmount(_farmerid, _token!);
    setState(() {
      _remainPlants = jsonDecode(response.body)['remain'].toString();
      _addonPlants = jsonDecode(response.body)['addon'].toString();
    });
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
            mainContent(),
            FarmerCollapsingNavigationDrawer(
              name: _username!,
              menuIndex: 0,
              maxWidth: MediaQuery.of(context).size.width * 0.55,
            ),
          ],
        ),
      ),
    );
  }

  Widget mainContent() {
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
                  "บันทึกการปลูก",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "พืชกระท่อม",
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
                  padding: EdgeInsets.only(top: 35),
                  child: Text(
                    'ข้อมูลการปลูกของเกษตรกร',
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
                                title: "คงอยู่",
                                suffix: "ต้น",
                                amount: _remainPlants!,
                                icon: FontAwesomeIcons.seedling,
                                bgColor: const Color(0xFFFFE9C6),
                                textColor: const Color(0xFFDA9551)),
                            CardItem(
                                title: "ปลูกเพิ่ม",
                                suffix: "ต้น",
                                amount: _addonPlants!,
                                icon: FontAwesomeIcons.handHoldingDroplet,
                                bgColor: const Color(0xFFC2E3FE),
                                textColor: const Color(0xFF6A8CAA)),
                            // _buildItemList("ปลูกเพิ่ม", "150", Color(0xFFD7FADA),
                            //     Color(0xFF56CC7E)),
                          ],
                        ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    'บันทึกข้อมูลวันที่ ${formatBuddhistYear(DateFormat('dd MMMM yyyy'), DateTime.now())}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Form(
                    key: _farmerFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "จำนวนต้นกระท่อมที่เหลืออยู่",
                          style: labelInputStyle,
                        ),
                        remainInput(),
                        const SizedBox(height: 16),
                        Text(
                          "จำนวนต้นกระท่อมที่ปลูกเพิ่ม",
                          style: labelInputStyle,
                        ),
                        addonInput(),
                        const SizedBox(height: 16),
                        Text(
                          "สายพันธุ์ที่ปลูกเพิ่ม",
                          style: labelInputStyle,
                        ),
                        speciesInput(),
                        const SizedBox(height: 16),
                        Text(
                          "วันที่คาดว่าจะเก็บเกี่ยว",
                          style: labelInputStyle,
                        ),
                        harvestDateInput(),
                        const SizedBox(height: 16),
                        Text(
                          "ปริมาณใบกระท่อมที่คาดว่าจะเก็บเกี่ยวได้",
                          style: labelInputStyle,
                        ),
                        harvestInput(),
                        const SizedBox(height: 16),
                        savePlantBtn()
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget remainInput() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        width: MediaQuery.of(context).size.width * 0.65,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          controller: _remainController,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.isEmpty) {
              return "กรุณาใส่จำนวนต้นที่เหลืออยู่";
            }
            return null;
          },
          decoration: InputDecoration(
            suffixText: "ต้น",
            border: InputBorder.none,
            errorBorder: errorBorder,
          ),
        ),
      ),
    );
  }

  Widget addonInput() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        width: MediaQuery.of(context).size.width * 0.65,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          controller: _addonController,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.isEmpty) {
              return "กรุณาใส่จำนวนต้นที่ปลูกเพิ่ม";
            }
            return null;
          },
          decoration: InputDecoration(
            suffixText: "ต้น",
            border: InputBorder.none,
            errorBorder: errorBorder,
          ),
        ),
      ),
    );
  }

  Widget speciesInput() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        width: MediaQuery.of(context).size.width * 0.65,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          controller: _speciesController,
          maxLines: 3,
          minLines: 2,
          validator: (value) {
            if (value!.isEmpty) {
              return "กรุณาระบุสายพันธุ์ที่ปลูกเพิ่ม";
            }
            return null;
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            errorBorder: errorBorder,
          ),
        ),
      ),
    );
  }

  Widget harvestInput() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        width: MediaQuery.of(context).size.width * 0.65,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          controller: _harvestController,
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value!.isEmpty) {
              return "กรุณาใส่ปริมาณที่คาดว่าจะเก็บเกี่ยวได้";
            }
            return null;
          },
          decoration: InputDecoration(
            suffixText: "กิโลกรัม",
            border: InputBorder.none,
            errorBorder: errorBorder,
          ),
        ),
      ),
    );
  }

  Widget harvestDateInput() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16),
        width: MediaQuery.of(context).size.width * 0.65,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextFormField(
          controller: _harvestDateController,
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
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget datePicker() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width * 0.75,
      child: SfDateRangePicker(
          controller: _harvestDatePickerController,
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
          initialDisplayDate: DateTime.now(),
          initialSelectedDate: DateTime.now()),
    );
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      // _harvestDateController.text = DateFormat('dd/MM/yyyy').format(args.value);
      _harvestDateController.text =
          formatBuddhistYear(DateFormat("dd/MM/yyyy"), args.value);
    });
    Navigator.pop(context);
  }

  Widget savePlantBtn() {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: 250,
        height: 50,
        child: ElevatedButton(
          onPressed: () async {
            if (_farmerFormKey.currentState!.validate()) {
              var json = jsonEncode({
                "remain": int.parse(_remainController.text),
                "addonAmount": int.parse(_addonController.text),
                "addonSpecies": _speciesController.text,
                "expectedDate": _harvestDateController.text,
                "expectedAmount": double.parse(_harvestController.text),
              });

              var response = await saveFarmerPlant(json, _farmerid, _token);
              if (response.statusCode == 200) {
                print("add new plant");
                await Future.delayed(const Duration(seconds: 1));

                if (!mounted) return;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FarmerPlantPage(),
                    ));
              }
            }
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              const Color(0xFF21BFBD),
            ),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
            ),
          ),
          child: const Text("บันทึกข้อมูล"),
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
