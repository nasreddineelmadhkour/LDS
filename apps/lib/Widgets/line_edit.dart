import 'package:LDS/Widgets/colorTheme.dart';
import 'package:flutter/material.dart';

class LineEdit extends StatelessWidget{
  final String title;
  final IconData icon;
  final bool readOnly;

  const LineEdit({
    super.key,
    required this.title,
    required this.icon,
    required this.readOnly

  });

  @override
  Widget build(BuildContext context) {

    return TextFormField(

      readOnly: readOnly,
      cursorColor: ColorTheme.principalTeal,
      style: TextStyle(color: ColorTheme.principalTeal),
      decoration: InputDecoration(
        filled: true,
        fillColor: ColorTheme.colorBackgroundCard,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: ColorTheme.firstColor),
          borderRadius: BorderRadius.circular(30),),
        label: Text(
          title,
          style: TextStyle(color: ColorTheme.smalTitleColor),
        ),
        prefixIcon: Icon(icon, color: ColorTheme.firstColor,size: 20),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(width: 2, color: ColorTheme.firstColor), // Bordure bleue quand en focus
        ),

      ),
    );
  }
}