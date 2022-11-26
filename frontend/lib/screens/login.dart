import 'package:flutter/material.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/screens/home.dart';
import 'package:frontend/screens/register.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  static const routeName = "/login";

  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailOrDispNameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _isEmailOrDispNameNotExisted = false;
  bool _isPasswordWrong = false;
  bool _isPasswordHidden = true;

  @override
  void initState() {
    super.initState();

    Future(() async {});

    _emailOrDispNameCtrl.text = "creator@gmail.com";
    _passwordCtrl.text = "Creator2000@";
  }

  @override
  void dispose() {
    super.dispose();
    _emailOrDispNameCtrl.dispose();
    _passwordCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Login',
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -------------------------------- Email Or DispName
                const Text("Email or Display Name"),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _emailOrDispNameCtrl,
                  decoration: const InputDecoration(
                    isDense: true,
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
                if (_isEmailOrDispNameNotExisted)
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
                const Text("Password"),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _passwordCtrl,
                  maxLength: 30,
                  obscureText: _isPasswordHidden,
                  decoration: InputDecoration(
                    isDense: true,
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordHidden
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordHidden = !_isPasswordHidden;
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
                if (_isPasswordWrong)
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: Text(
                      'Password is wrong',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red[800],
                      ),
                    ),
                  ),
                const SizedBox(height: 20),

                // -------------------------------- Login Btn
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    child: const Text("Login"),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (!await Provider.of<UserProvider>(context,
                                listen: false)
                            .checkUserDisplayName({
                          "displayName": _emailOrDispNameCtrl.text,
                        })) {
                          if (!await Provider.of<UserProvider>(context,
                                  listen: false)
                              .checkEmail({
                            "email": _emailOrDispNameCtrl.text,
                          })) {
                            setState(() {
                              _isEmailOrDispNameNotExisted = true;
                            });
                            return;
                          } else {
                            setState(() {
                              _isEmailOrDispNameNotExisted = false;
                            });
                          }
                        } else {
                          setState(() {
                            _isEmailOrDispNameNotExisted = false;
                          });
                        }

                        final loginData = await Provider.of<UserProvider>(
                                context,
                                listen: false)
                            .loginUser({
                          "emailOrDispName": _emailOrDispNameCtrl.text,
                          "password": _passwordCtrl.text,
                        });
                        if (loginData.isLoggedIn) {
                          setState(() {
                            _isPasswordWrong = false;
                          });
                          await Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                            (route) => false,
                          );
                        } else {
                          setState(() {
                            _isPasswordWrong = true;
                          });
                        }
                      }
                    },
                  ),
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
