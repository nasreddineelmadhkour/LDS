
import 'package:LDS/Models/StaticAccount.dart';
import 'package:LDS/Widgets/colorTheme.dart';
import 'package:LDS/Widgets/logout_button.dart';
import 'package:LDS/Views/SettingView/setting_item.dart';
import 'package:LDS/Views/SettingView/setting_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _darkMode = false;
  bool _loading = false; // Add a loading indicator variable

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return

      Scaffold(

          appBar: AppBar(
            automaticallyImplyLeading: false, // This hides the back button
            title: Row(
              children: [
                // Add spacer to push the title to the right
                Padding(
                  padding: const EdgeInsets.only(left:10 ,top: 10),
                  child: Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: ColorTheme.appBarBigTitleColor,
                    ),
                  ),
                ),
              ],
            ),
            backgroundColor: ColorTheme.backgroundNormalColor,
          ),
        body: _loading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 20),
                    Text("Logging out..."),
                  ],
                ),
              ) // Show loading indicator if loading is true
            : Container(
              height: height,
              width: width,
              color: ColorTheme.backgroundNormalColor,
                child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20, bottom: 30, left: 30, right: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text(
                            "Account",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                                color: ColorTheme.bigTitleColor
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: ClipOval(
                                    child: Image.asset(
                                      'assets/images/icons/avatar.png',
                                      width: 120,
                                      height: 120,
                                      fit: BoxFit.cover,
                                    )
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Row(
                                  children: [
                                    SizedBox(
                                        width:
                                            10), // Add some space between the icon and the column
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          StaticAccount.staticAccount.role,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                              color: ColorTheme.smalTitleColor
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        Text(
                                          StaticAccount
                                              .staticAccount.name,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                LogoutButton(
                                  onTap: () async {
                                    setState(() {
                                      _loading = true; // Show loading indicator
                                    });

                                    await Future.delayed(Duration(seconds: 3));

                                    SystemNavigator.pop(); // Ferme l'application
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                           Text(
                            "Settings",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                                color: ColorTheme.bigTitleColor
                            ),
                          ),
                          const SizedBox(height: 20),
                          SettingItem(
                            title: "Language",
                            icon: Icons.language,
                            bgColor: ColorTheme.foorColor,
                            iconColor: ColorTheme.firstColor,
                            value: "English",
                            onTap: () {},
                          ),
                          const SizedBox(height: 20),
                          SettingItem(
                            title: "Notifications",
                            icon: Icons.notifications,
                            bgColor: ColorTheme.foorColor,
                            iconColor: ColorTheme.firstColor,
                            onTap: () {},
                          ),
                          const SizedBox(height: 20),
                          SettingSwitch(
                            title: "Dark Mode",
                            icon: Icons.dark_mode_rounded,
                            bgColor: ColorTheme.foorColor,
                            iconColor: ColorTheme.firstColor,
                            value: _darkMode,
                            onTap: (value) {
                              setState(() {
                                _darkMode=value;
                              });

                            },
                          ),
                          const SizedBox(height: 20),
                          SettingItem(
                            title: "Help",
                            icon: Icons.help,
                            bgColor: ColorTheme.foorColor,
                            iconColor: ColorTheme.firstColor,
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
              ));
  }
}
