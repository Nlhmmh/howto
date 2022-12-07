import 'package:flutter/material.dart';
import 'package:frontend/pages/bottom_navi.dart';
import 'package:frontend/pages/widgets.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/pages/top.dart';
import 'package:frontend/pages/register.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  static const routeName = "/login";

  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isPwHidden = true;

  bool _isEmailNotExisted = false;
  bool _isPwWrong = false;

  String _errMsg = "";

  @override
  void initState() {
    super.initState();

    Future(() async {});

    _emailCtrl.text = "test@gmail.com";
    _passwordCtrl.text = "1111";
  }

  @override
  void dispose() {
    super.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // -------------------------------- Logo
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset("assets/images/logo1.png"),
                  ),
                ),
                const SizedBox(height: 50),

                // -------------------------------- Email
                // const Text("Email"),
                // const SizedBox(height: 10),
                TextFormField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(
                    isDense: true,
                    labelText: "Email",
                    labelStyle: TextStyle(fontSize: 16),
                    hintText: 'example@gmail.com',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
                if (_isEmailNotExisted)
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: Text(
                      'Email or Display Name does not exists',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red[800],
                      ),
                    ),
                  ),
                const SizedBox(height: 20),

                // -------------------------------- Password
                // const Text("Password"),
                // const SizedBox(height: 5),
                TextFormField(
                  controller: _passwordCtrl,
                  maxLength: 30,
                  obscureText: _isPwHidden,
                  decoration: InputDecoration(
                    isDense: true,
                    labelText: "Password",
                    labelStyle: const TextStyle(fontSize: 16),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPwHidden ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPwHidden = !_isPwHidden;
                        });
                      },
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
                if (_errMsg != "")
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: Text(
                      _errMsg,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red[800],
                      ),
                    ),
                  ),
                const SizedBox(height: 20),

                // -------------------------------- Login Btn
                primaryBtn(
                  text: "Login",
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // if (!await Provider.of<UserProvider>(context,
                      //         listen: false)
                      //     .checkUserDisplayName({
                      //   "displayName": _emailCtrl.text,
                      // })) {
                      //   if (!await Provider.of<UserProvider>(context,
                      //           listen: false)
                      //       .checkEmail({
                      //     "email": _emailCtrl.text,
                      //   })) {
                      //     setState(() {
                      //       _isEmailNotExisted = true;
                      //     });
                      //     return;
                      //   } else {
                      //     setState(() {
                      //       _isEmailNotExisted = false;
                      //     });
                      //   }
                      // } else {
                      //   setState(() {
                      //     _isEmailNotExisted = false;
                      //   });
                      // }

                      _errMsg = "";
                      final loginData = await Provider.of<UserProvider>(
                        context,
                        listen: false,
                      ).userLogin({
                        "email": _emailCtrl.text,
                        "password": _passwordCtrl.text,
                      });
                      if (loginData.code == 0) {
                        await Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomNaviPage(pageIndex: 0),
                          ),
                          (route) => false,
                        );
                      } else {
                        print(loginData.code);
                        _errMsg = loginData.error;
                      }
                    }
                    setState(() {});
                  },
                ),
                const SizedBox(height: 20),

                // -------------------------------- Create New Account Btn
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: OutlinedButton(
                    child: const Text("Create new account"),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        Registor.routeName,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
