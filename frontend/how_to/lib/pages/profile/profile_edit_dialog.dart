import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:how_to/pages/widgets.dart';
import 'package:how_to/providers/api/file_ctrls.dart';
import 'package:how_to/providers/api/user_ctrls.dart';
import 'package:how_to/providers/constants.dart';
import 'package:how_to/providers/models.dart';
import 'package:how_to/providers/utils.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ProfileEditDialog extends StatefulWidget {
  final User user;
  final UserProfile userProfile;

  const ProfileEditDialog({
    Key? key,
    required this.user,
    required this.userProfile,
  }) : super(key: key);

  @override
  State<ProfileEditDialog> createState() => _ProfileEditDialogState();
}

class _ProfileEditDialogState extends State<ProfileEditDialog> {
  final _formKey = GlobalKey<FormState>();

  final _displayNameCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _birthDateCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  DateTime _birthDate = DateTime(2008, 09, 11);
  DateTime _changeBirthDate = DateTime(2008, 09, 11);
  String _errMsg = "";

  final ImagePicker _picker = ImagePicker();
  File? _image;
  bool _isLoading = false;

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
    return CustomDialog(
      title: "Edit Profile",
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --------------- Avatar
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 70,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    child: CircleAvatar(
                      maxRadius: 25,
                      child: ClipOval(
                        child: _image != null
                            ? Image.file(
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                _image!,
                              )
                            : widget.userProfile.imageUrl != ""
                                ? Image.network(
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                    "${Constants.domainHttp}${widget.userProfile.imageUrl}",
                                  )
                                : const Icon(Icons.person, size: 25),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0.0,
                    right: 0.0,
                    child: SizedBox(
                      width: 25,
                      height: 25,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(0),
                        ),
                        child: const Icon(Icons.edit, size: 16),
                        onPressed: () async {
                          try {
                            final image = await _picker.pickImage(
                                source: ImageSource.gallery);
                            if (image == null) return;
                            _image = File(image.path);
                            setState(() {});
                          } catch (e) {
                            debugPrint(e.toString());
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --------------- Display Name
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

            // --------------- Real Name
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

            // --------------- Birthday
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
                      // --------------- Date Roll
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

                      // --------------- OK Btn
                      primaryBtn(
                        context: context,
                        text: "OK",
                        height: 50,
                        onPressed: () {
                          _birthDate = _changeBirthDate;
                          _birthDateCtrl.text = DateFormat("MMMM dd, yyyy")
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

            // --------------- Phone
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

            // --------------- Edit Btn
            primaryBtn(
              context: context,
              text: "Edit",
              isLoading: _isLoading,
              onPressed: () async {
                _errMsg = "";
                if (_formKey.currentState!.validate()) {
                  try {
                    _isLoading = true;
                    setState(() {});

                    // Upload Image
                    var imagUrl = widget.userProfile.imageUrl;
                    if (_image != null) {
                      final imgResp = await FileCtrls.upload(_image!);
                      if (imgResp.errResp.code != 0) {
                        if (!mounted) return;
                        Utils.checkErrorResp(context, imgResp.errResp);
                        return;
                      }
                      imagUrl = imgResp.filePath;
                    }

                    // Edit Profile
                    if (!mounted) return;
                    final errResp = await UserCtrls.editProfile({
                      "displayName": _displayNameCtrl.text,
                      "name": _nameCtrl.text,
                      "birthDate": !_birthDate.toIso8601String().contains('Z')
                          ? "${_birthDate.toIso8601String()}Z"
                          : _birthDate.toIso8601String(),
                      "phone": _phoneCtrl.text,
                      "imagUrl": imagUrl,
                    });
                    if (errResp.code != 0) {
                      if (!mounted) return;
                      Utils.checkErrorResp(context, errResp);
                      return;
                    }
                    if (!mounted) return;
                    Navigator.pop(context);
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
          ],
        ),
      ),
    );
  }
}
