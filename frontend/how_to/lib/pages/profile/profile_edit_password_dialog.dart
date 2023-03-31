import 'package:flutter/material.dart';
import 'package:how_to/pages/widgets.dart';
import 'package:how_to/providers/api/user_ctrls.dart';

class ProfileEditPasswordDialog extends StatefulWidget {
  const ProfileEditPasswordDialog({Key? key}) : super(key: key);

  @override
  State<ProfileEditPasswordDialog> createState() =>
      _ProfileEditPasswordDialogState();
}

class _ProfileEditPasswordDialogState extends State<ProfileEditPasswordDialog> {
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
            // --------------- Password
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

            // --------------- New Password
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

            // --------------- New Confirm Password
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

            // --------------- Error Msg
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

            // --------------- Save Btn
            primaryBtn(
              context: context,
              text: "Edit",
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final resp = await UserCtrls.passwordEdit({
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
