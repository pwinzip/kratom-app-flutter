import 'package:flutter/material.dart';
import 'package:kratomapp/models/navigation_model.dart';
import 'package:kratomapp/screens/admin/admin_main_page.dart';
import 'package:kratomapp/screens/admin/admin_show_enterprise_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/admin/admin_show_farmer_page.dart';
import '../screens/login_page.dart';
import '../services/auth_service.dart';
import '../theme.dart';
import 'collapsing_listtile.dart';

class AdminCollapsingNavigationDrawer extends StatefulWidget {
  final String name;
  final int menuIndex;
  final double maxWidth;
  const AdminCollapsingNavigationDrawer({
    Key? key,
    required this.name,
    required this.menuIndex,
    required this.maxWidth,
  }) : super(key: key);

  @override
  State<AdminCollapsingNavigationDrawer> createState() =>
      _AdminCollapsingNavigationDrawerState();
}

class _AdminCollapsingNavigationDrawerState
    extends State<AdminCollapsingNavigationDrawer>
    with SingleTickerProviderStateMixin {
  double maxWidth = 250;
  double minWidth = 70;

  bool isCollapsed = true;
  late AnimationController _animationController;
  late Animation<double> widthAnimation;
  int currentSelectedIndex = 0;
  String username = "ผู้ใช้";

  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    setState(() {
      username = widget.name;
      currentSelectedIndex = widget.menuIndex;
      maxWidth = widget.maxWidth;
    });
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    widthAnimation = Tween<double>(begin: minWidth, end: maxWidth)
        .animate(_animationController);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, widget) => getWidget(context, widget));
  }

  Widget getWidget(BuildContext context, Widget? widget) {
    return Material(
      elevation: 80.0,
      child: Container(
        width: widthAnimation.value,
        color: drawerBackgroundColor,
        child: Column(
          children: [
            const SizedBox(height: 50),
            CollapsingListTile(
              title: username,
              icon: Icons.person,
              animationController: _animationController,
            ),
            const Divider(color: Colors.grey, height: 40),
            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) {
                  return const Divider(height: 12);
                },
                itemCount: adminNavigationItems.length,
                itemBuilder: (context, counter) {
                  return CollapsingListTile(
                    onTap: () {
                      if (counter == currentSelectedIndex) {
                      } else if (counter == 0) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AdminMainPage()));
                      } else if (counter == 1) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AdminShowEnterprisePage()));
                      } else if (counter == 2) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const AdminShowFarmerPage()));
                      } else if (counter == 3) {
                        userLogout();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      }
                    },
                    isSelected: currentSelectedIndex == counter,
                    title: adminNavigationItems[counter].title,
                    icon: adminNavigationItems[counter].icon,
                    animationController: _animationController,
                  );
                },
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  isCollapsed = !isCollapsed;
                  isCollapsed
                      ? _animationController.reverse()
                      : _animationController.forward();
                });
              },
              child: AnimatedIcon(
                icon: AnimatedIcons.menu_close,
                color: Colors.white,
                size: 50.0,
                progress: _animationController,
              ),
            ),
            const SizedBox(height: 50)
          ],
        ),
      ),
    );
  }

  void userLogout() async {
    final SharedPreferences preferences = await prefs;
    await logout(preferences.getString('token')!);
  }
}
