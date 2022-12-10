import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:how_to/providers/constants.dart';
import 'package:how_to/providers/models.dart';
import 'package:how_to/providers/user_provider.dart';
import 'package:how_to/pages/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  static const routeName = "/profile";

  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  LoginData _loginData = LoginData();
  UserProfile _userProfile = UserProfile();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Get Login Data
      final loginData = await Provider.of<UserProvider>(
        context,
        listen: false,
      ).getLoginData();
      _loginData = loginData;

      // Fetch UserProfile
      if (!mounted) return;
      final userProfile = await Provider.of<UserProvider>(
        context,
        listen: false,
      ).fetchProfile();
      _userProfile = userProfile;

      setState(() {});
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
              child: Center(child: Text('Profile')),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) => _EditDialog(
                      user: _loginData.user,
                      userProfile: _userProfile,
                    ),
                  );
                  if (!mounted) return;
                  final user = await Provider.of<UserProvider>(
                    context,
                    listen: false,
                  ).fetchProfile();
                  _userProfile = user;
                  setState(() {});
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: primaryBtn(
          text: "Edit Profile",
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (BuildContext context) => _EditDialog(
                user: _loginData.user,
                userProfile: _userProfile,
              ),
            );
            if (!mounted) return;
            final user = await Provider.of<UserProvider>(
              context,
              listen: false,
            ).fetchProfile();
            _userProfile = user;
            setState(() {});
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              // -------------------------------- Avatar
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ),
                child: CircleAvatar(
                  maxRadius: 25,
                  backgroundColor: _loginData.isLoggedIn
                      ? Constants
                          .avatarColorList[_loginData.user.avatarColorIndex]
                          .color
                      : Colors.white,
                  child: _loginData.isLoggedIn
                      ? Text(
                          _loginData.user.email != ""
                              ? _loginData.user.email.characters.first
                                  .toUpperCase()
                              : "",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 40,
                          ),
                        )
                      : const Icon(Icons.person, size: 25),
                ),
              ),

              const SizedBox(height: 30),

              // -------------------------------- Profile
              Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.grey,
                      width: 1,
                    ),
                    color: Theme.of(context).colorScheme.background,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      // -------------------------------- Email
                      _profileRow(
                        title: "Email",
                        value: _loginData.user.email,
                      ),

                      // -------------------------------- Password
                      Stack(
                        children: [
                          _profileRow(
                            title: "Password",
                            value: "",
                            child: const Text(
                              "*****",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0.0,
                            right: -10.0,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(5),
                              ),
                              child: const Icon(Icons.edit),
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      const _EditPasswordDialog(),
                                );
                                if (!mounted) return;
                                final user = await Provider.of<UserProvider>(
                                  context,
                                  listen: false,
                                ).fetchProfile();
                                _userProfile = user;
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),

                      // -------------------------------- Display Name
                      _profileRow(
                        title: "Display Name",
                        value: _userProfile.displayName,
                      ),

                      // -------------------------------- Real Name
                      _profileRow(
                        title: "Real Name",
                        value: _userProfile.name,
                      ),

                      // -------------------------------- Birthday
                      _profileRow(
                        title: "Birthday",
                        value: DateFormat("yyyy-MM-dd")
                            .format(_userProfile.birthDate)
                            .toString(),
                      ),

                      // -------------------------------- Type
                      _profileRow(
                        title: "Type",
                        value: _loginData.user.type,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileRow({
    required String title,
    required String value,
    Widget? child,
  }) {
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
            child: child ??
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
          ),
        ],
      ),
    );
  }
}

class _EditDialog extends StatefulWidget {
  final User user;
  final UserProfile userProfile;

  const _EditDialog({
    Key? key,
    required this.user,
    required this.userProfile,
  }) : super(key: key);

  @override
  State<_EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<_EditDialog> {
  final _formKey = GlobalKey<FormState>();

  final _displayNameCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _birthDateCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  DateTime _birthDate = DateTime(2008, 09, 11);
  DateTime _changeBirthDate = DateTime(2008, 09, 11);
  String _errMsg = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      _displayNameCtrl.text = widget.userProfile.displayName;
      _nameCtrl.text = widget.userProfile.name;
      _birthDate = widget.userProfile.birthDate;
      _birthDateCtrl.text =
          DateFormat("yyyy-MM-dd").format(_birthDate).toString();
      _phoneCtrl.text = widget.userProfile.phone;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _displayNameCtrl.dispose();
    _nameCtrl.dispose();
    _birthDateCtrl.dispose();
    _phoneCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      insetPadding: const EdgeInsets.all(10),
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
          child: Container(
            width: 400,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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

                  // -------------------------------- Edit Btn
                  primaryBtn(
                    text: "Edit",
                    onPressed: () async {
                      _errMsg = "";
                      if (_formKey.currentState!.validate()) {
                        if (!mounted) return;
                        final resp = await Provider.of<UserProvider>(
                          context,
                          listen: false,
                        ).editProfile({
                          "displayName": _displayNameCtrl.text,
                          "name": _nameCtrl.text,
                          "birthDate":
                              !_birthDate.toIso8601String().contains('Z')
                                  ? "${_birthDate.toIso8601String()}Z"
                                  : _birthDate.toIso8601String(),
                          "phone": _phoneCtrl.text,
                          "imagUrl": "",
                        });
                        if (resp.code == 0) {
                          if (!mounted) return;
                          Navigator.pop(context);
                        } else {
                          _errMsg = resp.error;
                        }
                      }
                      setState(() {});
                    },
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
  const _EditPasswordDialog({Key? key}) : super(key: key);

  @override
  State<_EditPasswordDialog> createState() => __EditPasswordDialogState();
}

class __EditPasswordDialogState extends State<_EditPasswordDialog> {
  final _formKey = GlobalKey<FormState>();

  final _pwCtrl = TextEditingController();
  final _newPWCtrl = TextEditingController();
  final _newConfirmPWCtrl = TextEditingController();

  bool _isPWHidden = true;
  bool _isNewPWHidden = true;
  bool _isNewConfirmPWHidden = true;
  String _errMsg = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pwCtrl.dispose();
    _newPWCtrl.dispose();
    _newConfirmPWCtrl.dispose();
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
            TextFormField(
              controller: _pwCtrl,
              maxLength: 30,
              obscureText: _isPWHidden,
              decoration: InputDecoration(
                isDense: true,
                labelText: "Password",
                labelStyle: const TextStyle(fontSize: 16),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPWHidden ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    _isPWHidden = !_isPWHidden;
                    setState(() {});
                  },
                ),
                // floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return 'Required';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            // -------------------------------- New Password
            TextFormField(
              controller: _newPWCtrl,
              maxLength: 30,
              obscureText: _isNewPWHidden,
              decoration: InputDecoration(
                isDense: true,
                labelText: "New Password",
                labelStyle: const TextStyle(fontSize: 16),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isNewPWHidden ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    _isNewPWHidden = !_isNewPWHidden;
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
                  return 'New Pasword must be between 8 and 30 characters';
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

            // -------------------------------- New Confirm Password
            TextFormField(
              controller: _newConfirmPWCtrl,
              maxLength: 30,
              obscureText: _isNewConfirmPWHidden,
              decoration: InputDecoration(
                isDense: true,
                labelText: "Confirm Password",
                labelStyle: const TextStyle(fontSize: 16),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isNewConfirmPWHidden
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    _isNewConfirmPWHidden = !_isNewConfirmPWHidden;
                    setState(() {});
                  },
                ),
                // floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              validator: (v) {
                if (v == null || v.isEmpty) {
                  return 'Required';
                }
                if (v != _newPWCtrl.text) {
                  return 'Confirm new pasword must be equal to new password';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

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

            // -------------------------------- Save Btn
            primaryBtn(
              text: "Edit",
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final resp =
                      await Provider.of<UserProvider>(context, listen: false)
                          .editPassword({
                    "oldPassword": _pwCtrl.text,
                    "newPassword": _newPWCtrl.text,
                  });
                  if (resp.code == 0) {
                    if (!mounted) return;
                    Navigator.pop(context);
                  } else {
                    _errMsg = resp.message;
                  }
                }
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
