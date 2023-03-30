import 'package:flutter/material.dart';

import 'package:how_to/pages/profile/profile_edit_dialog.dart';
import 'package:how_to/pages/profile/profile_edit_password_dialog.dart';
import 'package:how_to/providers/api/user.dart';
import 'package:how_to/providers/constants.dart';

import 'package:how_to/providers/models.dart';
import 'package:how_to/pages/widgets.dart';
import 'package:how_to/providers/utils.dart';
import 'package:intl/intl.dart';

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
      final loginData = await UserCtrls.getLoginData();
      _loginData = loginData;

      if (_loginData.isLoggedIn) {
        // Fetch UserProfile
        if (!mounted) return;
        final userProfile = await UserCtrls.fetchProfile(
          context,
          (errResp) {
            if (!mounted) return;
            Utils.checkErrorResp(context, errResp);
          },
        );
        _userProfile = userProfile;
      }

      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profile'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: primaryBtn(
          context: context,
          text: "Edit Profile",
          onPressed: () async {
            await showDialog(
              context: context,
              builder: (BuildContext context) => ProfileEditDialog(
                user: _loginData.user,
                userProfile: _userProfile,
              ),
            );
            if (!mounted) return;
            final userProfile = await UserCtrls.fetchProfile(
              context,
              (errResp) {
                if (!mounted) return;
                Utils.checkErrorResp(context, errResp);
              },
            );
            _userProfile = userProfile;
            setState(() {});
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            children: [
              // --------------- Avatar
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
                    child: _userProfile.imageUrl != ""
                        ? Image.network(
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            "${Constants.domainHttp}${_userProfile.imageUrl}",
                          )
                        : const Icon(Icons.person, size: 25),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // --------------- Profile
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
                      // --------------- Email
                      _profileRow(
                        title: "Email",
                        value: _loginData.user.email,
                      ),

                      // --------------- Password
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
                                      const ProfileEditPasswordDialog(),
                                );
                                if (!mounted) return;
                                final userProfile =
                                    await UserCtrls.fetchProfile(
                                  context,
                                  (errResp) {
                                    if (!mounted) return;
                                    Utils.checkErrorResp(context, errResp);
                                  },
                                );
                                _userProfile = userProfile;
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),

                      // --------------- Display Name
                      _profileRow(
                        title: "Display Name",
                        value: _userProfile.displayName,
                      ),

                      // --------------- Real Name
                      _profileRow(
                        title: "Real Name",
                        value: _userProfile.name,
                      ),

                      // --------------- Birthday
                      _profileRow(
                        title: "Birthday",
                        value: DateFormat("yyyy-MM-dd")
                            .format(_userProfile.birthDate)
                            .toString(),
                      ),

                      // --------------- Type
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
