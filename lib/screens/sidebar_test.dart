import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kratomapp/theme.dart';

import '../commons/farmer_collapsing_navigation_drawer.dart';
import '../commons/card_info.dart';

class SideBarTest extends StatefulWidget {
  const SideBarTest({Key? key}) : super(key: key);

  @override
  State<SideBarTest> createState() => _SideBarTestState();
}

class _SideBarTestState extends State<SideBarTest> {
  final _farmerFormKey = GlobalKey<FormState>();
  final TextEditingController _remainController = TextEditingController();
  final TextEditingController _addonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Collaping Navigation drawer'),
      //   backgroundColor: drawerBackgroundColor,
      //   elevation: 0.0,
      // ),
      body: SafeArea(
        child: Stack(
          children: [
            firstPage(),
            // testPage(),
            FarmerCollapsingNavigationDrawer(
              name: "ณภัทร",
              menuIndex: 0,
            ),
          ],
        ),
      ),
      // drawer: const CollapsingNavigationDrawer(),
    );
  }

  Widget firstPage() {
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
                Text(
                  "พืชกระท่อม",
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
                  padding: EdgeInsets.only(top: 35),
                  child: Text(
                    'ข้อมูลบันทึกล่าสุดวันที่ 05/06/2022',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 15),
                Container(
                  margin: const EdgeInsets.only(left: 40),
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: const [
                      CardItem(
                          title: "คงอยู่",
                          amount: "150",
                          suffix: "ต้น",
                          icon: FontAwesomeIcons.seedling,
                          bgColor: Color(0xFFFFE9C6),
                          textColor: Color(0xFFDA9551)),
                      CardItem(
                          title: "ปลูกเพิ่ม",
                          suffix: "ต้น",
                          amount: "200",
                          icon: FontAwesomeIcons.handHoldingDroplet,
                          bgColor: Color(0xFFC2E3FE),
                          textColor: Color(0xFF6A8CAA)),
                      // _buildItemList("ปลูกเพิ่ม", "150", Color(0xFFD7FADA),
                      //     Color(0xFF56CC7E)),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'บันทึกวันที่ 05/06/2022',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
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
                          "จำนวนต้นกระท่อมที่ปลูกเพิ่ม",
                          style: labelInputStyle,
                        ),
                        addonInput(),
                        const SizedBox(height: 16),
                        Text(
                          "ปริมาณใบกระท่อมที่คาดว่าจะเก็บเกี่ยวได้",
                          style: labelInputStyle,
                        ),
                        addonInput(),
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

  Widget savePlantBtn() {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: 250,
        height: 50,
        child: ElevatedButton(
          onPressed: () {},
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

  Widget testPage() {
    return Container(
      margin: const EdgeInsets.only(left: 70),
      color: const Color(0xFF7A9BEE),
      child: ListView(
        children: [
          Stack(
            children: [
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
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
                          Text(
                            "พืชกระท่อม",
                            style: TextStyle(color: Colors.white, fontSize: 25),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 90,
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(75),
                      topRight: Radius.circular(75),
                    ),
                    color: Colors.white,
                  ),
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width - 70,
                ),
              ),
              Positioned(
                top: 50,
                left: (MediaQuery.of(context).size.width / 2) - 140,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF4E70C5),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  width: 250,
                  height: 60,
                  child: const Center(
                      child: Text(
                    'ณภัทร แก้วภิบาล',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  )),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
