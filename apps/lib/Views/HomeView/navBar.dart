import 'package:LDS/Views/CoursView/listCours.dart';
import 'package:LDS/Views/CoursView/listCoursNow.dart';
import 'package:LDS/Views/ProfileView/profile.dart';
import 'package:LDS/Views/SettingView/settings.dart';
import 'package:LDS/Widgets/colorTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  DateTime? currentBackPressTime;

  final List<Widget> _pages = [
   // HomePage(),
    Center(
      child: ListCours(),
    ), // Replace with your Livraison content
    Center(
      child: ListCoursNow(),

    ),
    Center(
      child: Profile(),
    ),
    Center(
        child: Settings(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Minimize the app instead of going back
        if (currentBackPressTime == null ||
            DateTime.now().difference(currentBackPressTime!) >
                Duration(seconds: 2)) {
          currentBackPressTime = DateTime.now();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Appuyez de nouveau pour quitter"),
            ),
          );
          return false;
        }
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: ColorTheme.homeTopColor,
        body:


        _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              backgroundColor:  ColorTheme.colorBackgroundCard,
              icon: Icon(Icons.school ),
              label: 'Courses',
            ),
            BottomNavigationBarItem(
              backgroundColor: ColorTheme.colorBackgroundCard,
              icon: Icon(Icons.menu_book ),
              label: "Now!",
            ),
            BottomNavigationBarItem(
              backgroundColor:  ColorTheme.colorBackgroundCard,

              icon: Icon(Icons.account_circle),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              backgroundColor:  ColorTheme.colorBackgroundCard,
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: ColorTheme.IconNavBarSelected,
          unselectedItemColor: ColorTheme.colorIconNav,
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 1) {
        /*Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddOrder()),
        );*/
      }/* else if (_selectedIndex == 3) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Settings()),
        );
      }*/
    });
  }
}
