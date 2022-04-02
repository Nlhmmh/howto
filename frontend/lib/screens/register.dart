import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/screens/home.dart';
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
  final _passwordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();
  final _displayNameCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _birthDateCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();

  DateTime _birthDate = DateTime(2008, 09, 11);
  String _accountType = "viewer";

  bool _isDispNameExisted = false;
  bool _isEmailExisted = false;
  bool _isPasswordHidden = true;
  bool _isConfirmPasswordHidden = true;

  @override
  void initState() {
    super.initState();
    _emailCtrl.text = "test@gmail.com";
    _passwordCtrl.text = "Nay2000@";
    _confirmPasswordCtrl.text = "Nay2000@";
    _displayNameCtrl.text = "david2000";
    _nameCtrl.text = "David";
    _birthDateCtrl.text =
        DateFormat("yyyy-MM-dd").format(_birthDate).toString();
  }

  @override
  void dispose() {
    super.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    _displayNameCtrl.dispose();
    _nameCtrl.dispose();
    _birthDateCtrl.dispose();
    _phoneCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Register',
          ),
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
                // -------------------------------- Email
                const Text("Email"),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _emailCtrl,
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
                    if (!RegExp(
                      r"^[a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                    ).hasMatch(value)) {
                      return 'Not valid email';
                    }
                    return null;
                  },
                ),
                if (_isEmailExisted)
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: Text(
                      'Email alreay exists',
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
                    if (!RegExp(
                      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
                    ).hasMatch(value)) {
                      return 'Password is not strong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // -------------------------------- Confirm Password
                const Text("Confirm Password"),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _confirmPasswordCtrl,
                  maxLength: 30,
                  obscureText: _isConfirmPasswordHidden,
                  decoration: InputDecoration(
                    isDense: true,
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordHidden
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordHidden = !_isConfirmPasswordHidden;
                        });
                      },
                    ),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    if (value != _passwordCtrl.text) {
                      return 'Confirm password and password do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // -------------------------------- Display Name
                const Text("Display Name"),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _displayNameCtrl,
                  decoration: const InputDecoration(
                    isDense: true,
                    hintText: 'mgmg18',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(),
                  ),
                  autovalidateMode: AutovalidateMode.always,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
                if (_isDispNameExisted)
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 5),
                    child: Text(
                      'Display name alreay exists',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.red[800],
                      ),
                    ),
                  ),
                const SizedBox(height: 20),

                // -------------------------------- Real Name
                const Text("Real Name"),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(
                    isDense: true,
                    hintText: 'Mg Mg',
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
                const SizedBox(height: 20),

                // -------------------------------- Birthday
                const Text('Birthday'),
                const SizedBox(height: 5),
                TextFormField(
                  readOnly: true,
                  controller: _birthDateCtrl,
                  decoration: const InputDecoration(
                    isDense: true,
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
                      height: 300,
                      color: Colors.white,
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child: CupertinoDatePicker(
                              initialDateTime: _birthDate,
                              mode: CupertinoDatePickerMode.date,
                              use24hFormat: true,
                              onDateTimeChanged: (DateTime newDate) {
                                setState(() {
                                  _birthDate = newDate;
                                  _birthDateCtrl.text =
                                      DateFormat("MMMM dd, yyyy")
                                          .format(newDate)
                                          .toString();
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("OK"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // -------------------------------- Account Type
                const Text('Account Type'),
                const SizedBox(height: 5),
                DropdownButtonFormField<String>(
                  value: _accountType,
                  items: ['viewer', 'creator'].map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _accountType = newValue!;
                    });
                  },
                  icon: const Icon(Icons.arrow_drop_down_outlined),
                  decoration: const InputDecoration(
                    isDense: true,
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
                const SizedBox(height: 30),

                // -------------------------------- Register Btn
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    child: const Text("Register"),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (await Provider.of<UserProvider>(context,
                                listen: false)
                            .checkUserDisplayName({
                          "displayName": _displayNameCtrl.text,
                        })) {
                          setState(() {
                            _isDispNameExisted = true;
                          });
                        } else {
                          setState(() {
                            _isDispNameExisted = false;
                          });
                        }

                        if (await Provider.of<UserProvider>(context,
                                listen: false)
                            .checkEmail({
                          "email": _emailCtrl.text,
                        })) {
                          setState(() {
                            _isEmailExisted = true;
                          });
                        } else {
                          setState(() {
                            _isEmailExisted = false;
                          });
                        }

                        if (_isDispNameExisted || _isEmailExisted) return;

                        final user = await Provider.of<UserProvider>(context,
                                listen: false)
                            .registerUser({
                          "displayName": _displayNameCtrl.text,
                          "name": _nameCtrl.text,
                          "birthDate": DateFormat("yyyy-MM-dd")
                              .format(_birthDate)
                              .toString(),
                          "email": _emailCtrl.text,
                          "password": _passwordCtrl.text,
                          "accountType": _accountType,
                        });
                        if (user.isLoggedIn) {
                          await Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomePage(),
                            ),
                            (route) => false,
                          );
                        }
                      }
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
