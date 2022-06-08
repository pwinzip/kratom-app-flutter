import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kratomapp/screens/admin/admin_main_page.dart';
import 'package:kratomapp/screens/enterprise/enterprise_main_page.dart';
import 'package:kratomapp/screens/farmer/farmer_main_page.dart';
import 'package:kratomapp/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _telController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  String? errorText;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/balloon-lg.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                color: Color.fromARGB(180, 255, 255, 255),
              ),
              width: 450,
              height: MediaQuery.of(context).size.height - 100,
              padding: const EdgeInsets.all(24),
              margin: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    logo(),
                    errorText != null
                        ? Text(
                            errorText!,
                            style: const TextStyle(color: Colors.red),
                          )
                        : Container(),
                    telTextInput(),
                    passwordTextInput(),
                    const SizedBox(height: 20),
                    submitBtn(),
                    const SizedBox(height: 20),
                    customerText(),
                    const SizedBox(height: 10),
                    notifyText(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Row submitBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
            ),
          ),
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              var response =
                  await login(_telController.text, _passController.text);

              // print(response.statusCode);
              // print(response.body);

              if (response.statusCode == 200) {
                setState(() {
                  errorText = null;
                });
                SharedPreferences prefs = await SharedPreferences.getInstance();
                print(response.body);
                var useridJson = jsonDecode(response.body)['user']['id'];
                var nameJson = jsonDecode(response.body)['user']['name'];
                var roleJson = jsonDecode(response.body)['user']['role'];
                var tokenJson = jsonDecode(response.body)['token'];

                print(tokenJson);
                print(jsonDecode(response.body)['token']);

                await prefs.setInt('userid', useridJson);
                await prefs.setString('username', nameJson);
                await prefs.setString('token', tokenJson);

                if (roleJson == 2) {
                  var farmeridJson = jsonDecode(response.body)['farmer']['id'];
                  var entnameJson = jsonDecode(response.body)['enterprise']
                      ['enterprise_name'];
                  var agentnameJson =
                      jsonDecode(response.body)['agent']['name'];

                  await prefs.setInt('farmerid', farmeridJson);
                  await prefs.setString('enterprisename', entnameJson);
                  await prefs.setString('agentname', agentnameJson);

                  // go to Farmer Page
                  await Future.delayed(const Duration(seconds: 1));

                  if (!mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FarmerMainPage(),
                    ),
                  );
                } else if (roleJson == 1) {
                  var entidJson = jsonDecode(response.body)['enterprise']['id'];
                  var entnameJson = jsonDecode(response.body)['enterprise']
                      ['enterprise_name'];

                  await prefs.setInt('enterpriseid', entidJson);
                  await prefs.setString('enterprisename', entnameJson);

                  // go to Enterprise Page
                  await Future.delayed(const Duration(seconds: 1));

                  if (!mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EnterpriseMainPage(),
                    ),
                  );
                } else if (roleJson == 0) {
                  // go to Admin Page
                  await Future.delayed(const Duration(seconds: 1));

                  if (!mounted) return;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminMainPage(),
                    ),
                  );
                }
              } else {
                // Toast
                setState(() {
                  errorText = "เบอร์โทรศัพท์ หรือ รหัสผ่านไม่ถูกต้อง";
                });
              }
            }
          },
          child: const Text(
            'เข้าสู่ระบบ',
            style: TextStyle(color: Colors.white),
          ),
        )
      ],
    );
  }

  Widget logo() {
    return Container(
      width: 150,
      height: 150,
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        image: DecorationImage(
          fit: BoxFit.contain,
          image: AssetImage('assets/logos/logo-kt.png'),
        ),
      ),
    );
  }

  Widget telTextInput() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: _telController,
        keyboardType: TextInputType.phone,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณาใส่เบอร์โทรศัพท์';
          }
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.phone_android, color: Colors.grey),
          hintText: "เบอร์โทรศัพท์",
          hintStyle: const TextStyle(fontSize: 14),
          border: InputBorder.none,
          // border: defaultBorder,
          errorBorder: errorBorder,
          fillColor: Colors.grey.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget passwordTextInput() {
    return Container(
      width: MediaQuery.of(context).size.width - 50,
      margin: const EdgeInsets.only(top: 16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        controller: _passController,
        keyboardType: TextInputType.visiblePassword,
        validator: (value) {
          if (value!.isEmpty) {
            return 'กรุณาใส่รหัสผ่าน';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: "รหัสผ่าน",
          hintStyle: const TextStyle(fontSize: 14),
          prefixIcon: const Icon(Icons.key, color: Colors.grey),
          border: InputBorder.none,
          // border: defaultBorder,
          errorBorder: errorBorder,
          fillColor: Colors.grey.withOpacity(0.5),
        ),
      ),
    );
  }

  Widget customerText() {
    return Container(
      margin: const EdgeInsets.all(8),
      child: Column(
        children: [
          const Text('แจ้งความต้องการซื้อผลิตภัณฑ์พืชกระท่อม'),
          TextButton(onPressed: () {}, child: const Text('กดที่นี่'))
        ],
      ),
    );
  }

  Widget notifyText() {
    return Container(
      margin: const EdgeInsets.all(8),
      width: double.infinity,
      child: Text(
        '*** สมาคมพืชกระท่อมแห่งประเทศไทยเป็นเพียงตัวกลางเก็บรวบรวมข้อมูลความต้องการของตลาดเท่านั้น ***',
        softWrap: true,
        style: TextStyle(
          color: Colors.amber[800],
          fontSize: 12,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
