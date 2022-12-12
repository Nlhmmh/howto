import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:how_to/pages/login.dart';
import 'package:how_to/pages/widgets.dart';
import 'package:how_to/providers/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Registor extends StatefulWidget {
  static const routeName = "/register";

  const Registor({Key? key}) : super(key: key);

  @override
  State<Registor> createState() => _RegistorState();
}

class _RegistorState extends State<Registor> {
  final _formKey = GlobalKey<FormState>();

  final _emailCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  bool _isPwHidden = true;
  final _confirmPWCtrl = TextEditingController();
  bool _isConfirmPWHidden = true;
  final _displayNameCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _birthDateCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  DateTime _birthDate = DateTime(2008, 09, 11);
  DateTime _changeBirthDate = DateTime(2008, 09, 11);
  String _type = "viewer";
  String _errMsg = "";

  @override
  void initState() {
    super.initState();
    // _emailCtrl.text = "testnlh@gmail.com";
    // _pwCtrl.text = "Nay2000@";
    // _confirmPWCtrl.text = "Nay2000@";
    // _displayNameCtrl.text = "david2000";
    // _nameCtrl.text = "David";
    // _birthDateCtrl.text =
    //     DateFormat("yyyy-MM-dd").format(_birthDate).toString();
    // _phoneCtrl.text = "08099997777";
  }

  @override
  void dispose() {
    super.dispose();
    _emailCtrl.dispose();
    _pwCtrl.dispose();
    _confirmPWCtrl.dispose();
    _displayNameCtrl.dispose();
    _nameCtrl.dispose();
    _birthDateCtrl.dispose();
    _phoneCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Register'),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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

                  const SizedBox(height: 20),

                  // -------------------------------- Confirm Password
                  TextFormField(
                    controller: _confirmPWCtrl,
                    maxLength: 30,
                    obscureText: _isConfirmPWHidden,
                    decoration: InputDecoration(
                      isDense: true,
                      labelText: "Confirm Password",
                      labelStyle: const TextStyle(fontSize: 16),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPWHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          _isConfirmPWHidden = !_isConfirmPWHidden;
                          setState(() {});
                        },
                      ),
                      // floatingLabelBehavior: FloatingLabelBehavior.always,
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Required';
                      }
                      if (v != _pwCtrl.text) {
                        return 'Confirm pasword must be equal to password';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // -------------------------------- Display Name
                  TextFormField(
                    controller: _displayNameCtrl,
                    maxLength: 100,
                    decoration: const InputDecoration(
                      isDense: true,
                      labelText: "Display Name",
                      labelStyle: TextStyle(fontSize: 16),
                      hintText: 'mgmg18',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (value.length > 100) {
                        return 'Display name must be less than 100';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // -------------------------------- Real Name
                  TextFormField(
                    controller: _nameCtrl,
                    maxLength: 100,
                    decoration: const InputDecoration(
                      isDense: true,
                      labelText: "Real Name",
                      labelStyle: TextStyle(fontSize: 16),
                      hintText: 'Mg Mg',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (value.length > 100) {
                        return 'Real name must be less than 100';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // -------------------------------- Birthday
                  TextFormField(
                    readOnly: true,
                    controller: _birthDateCtrl,
                    decoration: const InputDecoration(
                      isDense: true,
                      labelText: "Birthday",
                      labelStyle: TextStyle(fontSize: 16),
                      border: OutlineInputBorder(),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                    onTap: () => showCupertinoModalPopup(
                      context: context,
                      builder: (BuildContext context) => Container(
                        height: 280,
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        child: Column(
                          children: [
                            // -------------------------------- Date Roll
                            SizedBox(
                              height: 200,
                              child: CupertinoDatePicker(
                                initialDateTime: _birthDate,
                                mode: CupertinoDatePickerMode.date,
                                use24hFormat: true,
                                onDateTimeChanged: (DateTime newDate) {
                                  _changeBirthDate = newDate;
                                  setState(() {});
                                },
                              ),
                            ),

                            // -------------------------------- OK Btn
                            primaryBtn(
                              context: context,
                              text: "OK",
                              height: 50,
                              onPressed: () {
                                _birthDate = _changeBirthDate;
                                _birthDateCtrl.text =
                                    DateFormat("MMMM dd, yyyy")
                                        .format(_changeBirthDate)
                                        .toString();
                                setState(() {});
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // -------------------------------- Phone
                  TextFormField(
                    controller: _phoneCtrl,
                    maxLength: 30,
                    decoration: const InputDecoration(
                      isDense: true,
                      labelText: "Phone",
                      labelStyle: TextStyle(fontSize: 16),
                      hintText: '08099992222',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (value.length > 30) {
                        return 'Phone must be less than 30';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // -------------------------------- Account Type
                  DropdownButtonFormField<String>(
                    value: _type,
                    decoration: const InputDecoration(
                      isDense: true,
                      labelText: "Type",
                      labelStyle: TextStyle(fontSize: 16),
                      border: OutlineInputBorder(),
                    ),
                    icon: const Icon(Icons.arrow_drop_down_outlined),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    items: ['viewer', 'creator'].map((value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _type = newValue!;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 30),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      "By Creating an account, you agree to our User Agreement and acknowledge reading our User Privacy Notice.",
                    ),
                  ),

                  const SizedBox(height: 30),

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

                  // -------------------------------- Register Btn
                  primaryBtn(
                    context: context,
                    text: "Register",
                    onPressed: () async {
                      _errMsg = "";
                      if (_formKey.currentState!.validate()) {
                        final resp = await Provider.of<UserProvider>(
                          context,
                          listen: false,
                        ).registerUser({
                          "email": _emailCtrl.text,
                          "password": _pwCtrl.text,
                          "displayName": _displayNameCtrl.text,
                          "name": _nameCtrl.text,
                          "birthDate": "${_birthDate.toIso8601String()}Z",
                          "phone": _phoneCtrl.text,
                          "imagUrl": "",
                          "type": _type,
                        });
                        if (resp.code == 0) {
                          if (!mounted) return;
                          await Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                            (route) => false,
                          );
                        } else {
                          _errMsg = resp.message;
                        }
                      }
                      setState(() {});
                    },
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
