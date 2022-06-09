import 'package:flutter/material.dart';
import 'package:kratomapp/models/navigation_model.dart';
import 'package:kratomapp/screens/enterprise/enterprise_main_page.dart';
import 'package:kratomapp/screens/enterprise/enterprise_member_page.dart';
import 'package:kratomapp/screens/login_page.dart';
import 'package:kratomapp/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme.dart';
import 'collapsing_listtile.dart';

class EnterpriseCollapsingNavigationDrawer extends StatefulWidget {
  final String name;
  final int menuIndex;
  final double maxWidth;
  const EnterpriseCollapsingNavigationDrawer({
    Key? key,
    required this.name,
    required this.menuIndex,
    required this.maxWidth,
  }) : super(key: key);

  @override
  State<EnterpriseCollapsingNavigationDrawer> createState() =>
      _EnterpriseCollapsingNavigationDrawerState();
}

class _EnterpriseCollapsingNavigationDrawerState
    extends State<EnterpriseCollapsingNavigationDrawer>
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
                itemCount: enterpriseNavigationItems.length,
                itemBuilder: (context, counter) {
                  return CollapsingListTile(
                    onTap: () async {
                      if (counter == currentSelectedIndex) {
                      } else if (counter == 0) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const EnterpriseMainPage()));
                      } else if (counter == 1) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const EnterpriseMemberPage()));
                      } else if (counter == 2) {
                        userLogout();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      }
                    },
                    isSelected: currentSelectedIndex == counter,
                    title: enterpriseNavigationItems[counter].title,
                    icon: enterpriseNavigationItems[counter].icon,
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
