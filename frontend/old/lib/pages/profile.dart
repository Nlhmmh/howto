import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/providers/models.dart';
import 'package:frontend/providers/user_provider.dart';
import 'package:frontend/pages/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  static const routeName = "/profile";

  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User _user = User();

  @override
  void initState() {
    super.initState();
    Future(() async {
      final user =
          await Provider.of<UserProvider>(context, listen: false).fetchUser();
      setState(() {
        _user = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          children: [
            const Expanded(
              flex: 8,
              child: Center(
                child: Text(
                  'Profile',
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) => _EditDialog(
                      user: _user,
                    ),
                  );
                  final user =
                      await Provider.of<UserProvider>(context, listen: false)
                          .fetchUser();
                  setState(() {
                    _user = user;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              _ProfileRow(
                title: "Email",
                value: _user.email,
              ),
              _ProfileRow(
                title: "Password",
                value: "",
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "*****",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      child: const Icon(Icons.edit),
                      onTap: () async {
                        await showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              _EditPasswordDialog(
                            user: _user,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              _ProfileRow(
                title: "Display Name",
                value: _user.displayName,
              ),
              _ProfileRow(
                title: "Real Name",
                value: _user.name,
              ),
              _ProfileRow(
                title: "Birthday",
                value:
                    DateFormat("yyyy-MM-dd").format(_user.birthDate).toString(),
              ),
              _ProfileRow(
                title: "Account Type",
                value: _user.accountType,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final String title;
  final String value;
  final Widget? child;

  const _ProfileRow({
    Key? key,
    required this.title,
    required this.value,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: child == null
                ? Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  )
                : child!,
          )
        ],
      ),
    );
  }
}

class _EditDialog extends StatefulWidget {
  final User user;

  const _EditDialog({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<_EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<_EditDialog> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _birthDateCtrl = TextEditingController();

  DateTime _birthDate = DateTime(2008, 09, 11);

  bool _isDispNameExisted = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _displayNameCtrl.text = widget.user.displayName;
      _nameCtrl.text = widget.user.name;
      _birthDate = widget.user.birthDate;
      _birthDateCtrl.text =
          DateFormat("yyyy-MM-dd").format(_birthDate).toString();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _displayNameCtrl.dispose();
    _nameCtrl.dispose();
    _birthDateCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      titlePadding: const EdgeInsets.all(0),
      title: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Edit Profile"),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: Colors.grey[400],
          )
        ],
      ),
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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

                  // -------------------------------- Edit Btn
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      child: const Text("Edit"),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (_displayNameCtrl.text !=
                              widget.user.displayName) {
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
                            if (_isDispNameExisted) return;
                          }

                          final isEdited = await Provider.of<UserProvider>(
                                  context,
                                  listen: false)
                              .editUser({
                            "displayName": _displayNameCtrl.text,
                            "name": _nameCtrl.text,
                            "birthDate": DateFormat("yyyy-MM-dd")
                                .format(_birthDate)
                                .toString(),
                          });
                          if (isEdited) {
                            Navigator.pop(context);
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
      ],
    );
  }
}

class _EditPasswordDialog extends StatefulWidget {
  final User user;

  const _EditPasswordDialog({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<_EditPasswordDialog> createState() => __EditPasswordDialogState();
}

class __EditPasswordDialogState extends State<_EditPasswordDialog> {
  final _formKey = GlobalKey<FormState>();

  final _passwordCtrl = TextEditingController();
  final _newPasswordCtrl = TextEditingController();
  final _newConfirmPasswordCtrl = TextEditingController();

  bool _isPasswordHidden = true;
  bool _isNewPasswordHidden = true;
  bool _isNewConfirmPasswordHidden = true;
  bool _isPasswordWrong = false;
  bool _isNewPasswordWrong = false;

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _passwordCtrl.dispose();
    _newPasswordCtrl.dispose();
    _newConfirmPasswordCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: "Edit Password",
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------------------------------- Password
            const Text("Old Password"),
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
                    _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
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
            if (_isPasswordWrong)
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 5),
                child: Text(
                  'Old password is wrong',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red[800],
                  ),
                ),
              ),
            const SizedBox(height: 20),

            // -------------------------------- New Password
            const Text("New Password"),
            const SizedBox(height: 5),
            TextFormField(
              controller: _newPasswordCtrl,
              maxLength: 30,
              obscureText: _isNewPasswordHidden,
              decoration: InputDecoration(
                isDense: true,
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isNewPasswordHidden
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isNewPasswordHidden = !_isNewPasswordHidden;
                    });
                  },
                ),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                if (value == _passwordCtrl.text) {
                  return 'New password is the same with old password';
                }
                if (!RegExp(
                  r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
                ).hasMatch(value)) {
                  return 'Password is not strong';
                }
                return null;
              },
            ),
            if (_isNewPasswordWrong)
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 5),
                child: Text(
                  'Something wrong in new password',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red[800],
                  ),
                ),
              ),
            const SizedBox(height: 20),

            // -------------------------------- New Confirm Password
            const Text("New Confirm Password"),
            const SizedBox(height: 5),
            TextFormField(
              controller: _newConfirmPasswordCtrl,
              maxLength: 30,
              obscureText: _isNewConfirmPasswordHidden,
              decoration: InputDecoration(
                isDense: true,
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isNewConfirmPasswordHidden
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _isNewConfirmPasswordHidden =
                          !_isNewConfirmPasswordHidden;
                    });
                  },
                ),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }
                if (value != _newPasswordCtrl.text) {
                  return 'Confirm password and password do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),

            // -------------------------------- Save Btn
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                child: const Text("Save"),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final resp =
                        await Provider.of<UserProvider>(context, listen: false)
                            .editPassword({
                      "oldPassword": _passwordCtrl.text,
                      "newPassword": _newPasswordCtrl.text,
                    });
                    if (resp == EditPwResp.ok) {
                      Navigator.pop(context);
                    } else if (resp == EditPwResp.oldPasswordWrong) {
                      setState(() {
                        _isPasswordWrong = true;
                      });
                    } else if (resp == EditPwResp.newPasswordError) {
                      setState(() {
                        _isNewPasswordWrong = true;
                      });
                    } else {
                      setState(() {
                        _isPasswordWrong = false;
                        _isNewPasswordWrong = false;
                      });
                    }
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
