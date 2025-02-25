import 'package:LDS/Widgets/colorTheme.dart';
import 'package:flutter/material.dart';

class LineEditdiv2 extends StatelessWidget{
  final String title;
  final IconData icon;
  final bool readOnly;
  final String title2;
  final IconData icon2;
  final bool readOnly2;


  const LineEditdiv2({
    super.key,
    required this.title,
    required this.icon,
    required this.readOnly,
    required this.title2,
    required this.icon2,
    required this.readOnly2

  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width/2.3;
    return

      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: width, // set your desired width
            child: TextFormField(
              readOnly: readOnly,
              cursorColor: ColorTheme.firstColor,
              style: TextStyle(color: ColorTheme.firstColor),
              decoration: InputDecoration(
                filled: true,
                fillColor: ColorTheme.colorBackgroundCard,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorTheme.firstColor),
                  borderRadius: BorderRadius.circular(30),
                ),
                label: Text(
                  title,
                  style: TextStyle(color: ColorTheme.smalTitleColor),
                ),
                prefixIcon: Icon(icon, color: ColorTheme.firstColor, size: 25),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(width: 2, color: ColorTheme.firstColor),
                ),
              ),
            ),
          ),
          Container(
            width: width, // set your desired width
            child: TextFormField(
              readOnly: readOnly2,
              cursorColor: ColorTheme.firstColor,
              style: TextStyle(color: ColorTheme.firstColor),
              decoration: InputDecoration(
                filled: true,
                fillColor: ColorTheme.colorBackgroundCard,
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: ColorTheme.firstColor),
                  borderRadius: BorderRadius.circular(30),
                ),
                label: Text(
                  title2,
                  style: TextStyle(color: ColorTheme.smalTitleColor),
                ),
                prefixIcon: Icon(icon2, color: ColorTheme.firstColor, size: 25),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(width: 2, color: ColorTheme.firstColor),
                ),
              ),
            ),
          ),

        ],
      )
      ;
  }
}