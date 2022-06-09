import 'package:flutter/material.dart';

class NavigationModel {
  String? title;
  IconData? icon;

  NavigationModel({this.title, this.icon});
}

List<NavigationModel> farmerNavigationItems = [
  NavigationModel(title: 'บันทึกการปลูก', icon: Icons.home),
  NavigationModel(title: 'ประวัติการบันทึกการปลูก', icon: Icons.grass),
  NavigationModel(title: 'ออกจากระบบ', icon: Icons.logout_rounded),
  // NavigationModel(title: 'ข้อมูลส่วนตัว', icon: Icons.settings),
];

List<NavigationModel> enterpriseNavigationItems = [
  NavigationModel(title: 'หน้าแรก', icon: Icons.home),
  NavigationModel(title: 'สมาชิก', icon: Icons.group),
  // NavigationModel(title: 'ออกจากระบบ', icon: Icons.logout_rounded),
  // NavigationModel(
  //     title: 'แจ้งความต้องการขาย', icon: Icons.shopping_cart_outlined),
  // NavigationModel(title: 'ประวัติการแจ้งขาย', icon: Icons.history_outlined),
  // NavigationModel(title: 'ข้อมูลส่วนตัว', icon: Icons.settings),
];

List<NavigationModel> adminNavigationItems = [
  NavigationModel(title: 'หน้าแรก', icon: Icons.home),
  NavigationModel(title: 'จ้ดการกลุ่ม', icon: Icons.add_business),
  NavigationModel(title: 'จัดการเกษตรกร', icon: Icons.person_add_alt_sharp),
  NavigationModel(title: 'ออกจากระบบ', icon: Icons.logout_rounded),
  // NavigationModel(title: 'รายการแจ้งขาย', icon: Icons.monetization_on_outlined),
  // NavigationModel(title: 'รายการแจ้งซื้อ', icon: Icons.shopping_cart_checkout),
];

List<NavigationModel> navigationItems = [
  NavigationModel(
    title: 'Dashboard',
    icon: Icons.insert_chart,
  ),
  NavigationModel(
    title: 'Error',
    icon: Icons.error,
  ),
  NavigationModel(
    title: 'Search',
    icon: Icons.search,
  ),
  // NavigationModel(title: 'Notification', icon: Icons.notifications),
  // NavigationModel(title: 'Setting', icon: Icons.settings),
];
