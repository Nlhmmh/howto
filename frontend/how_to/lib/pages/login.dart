import 'package:flutter/material.dart';
import 'package:how_to/pages/bottom_navi.dart';
import 'package:how_to/pages/widgets.dart';
import 'package:how_to/providers/user_provider.dart';
import 'package:how_to/pages/register.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static const routeName = "/login";

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  bool _isPwHidden = true;

  String _errMsg = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailCtrl.text = "test@gmail.com";
    _pwCtrl.text = "Nlhtester@8";
    // _emailCtrl.text = "";
    // _passwordCtrl.text = "";
  }

  @override
  void dispose() {
    super.dispose();
    _emailCtrl.dispose();
    _pwCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Login'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
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
                      // floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Required';
                      }
                      if (!RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                      ).hasMatch(v)) {
                        return 'Email is not valid';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  // -------------------------------- Password
                  // const Text("Password"),
                  // const SizedBox(height: 5),
                  TextFormField(
                    controller: _pwCtrl,
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
                          _isPwHidden = !_isPwHidden;
                          setState(() {});
                        },
                      ),
                      // floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Required';
                      }
                      if (v.length < 8 || v.length > 30) {
                        return 'Pasword must be between 8 and 30 characters';
                      }
                      if (!RegExp(
                        r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~])+",
                      ).hasMatch(v)) {
                        return 'Pasword must have at least one upper case, one lower case, one digit, one special character';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 10),

                  // -------------------------------- Error Msg
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

                  const SizedBox(height: 10),

                  // -------------------------------- Login Btn
                  primaryBtn(
                    context: context,
                    text: "Login",
                    isLoading: _isLoading,
                    onPressed: () async {
                      _errMsg = "";
                      if (_formKey.currentState!.validate()) {
                        try {
                          _isLoading = true;
                          setState(() {});

                          final resp = await Provider.of<UserProvider>(
                            context,
                            listen: false,
                          ).userLogin({
                            "email": _emailCtrl.text,
                            "password": _pwCtrl.text,
                          });
                          if (resp.code == 0) {
                            if (!mounted) return;
                            await Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const BottomNaviPage(pageIndex: 0),
                              ),
                              (route) => false,
                            );
                          } else {
                            _errMsg = resp.message;
                          }
                        } catch (e) {
                          debugPrint(e.toString());
                        } finally {
                          _isLoading = false;
                          setState(() {});
                        }
                      }
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 20),

                  // -------------------------------- Create New Account Btn
                  secondaryBtn(
                    text: "Create new account",
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        Registor.routeName,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
