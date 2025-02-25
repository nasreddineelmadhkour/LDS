import 'package:LDS/ViewModel/CoursViewModel.dart';
import 'package:LDS/Views/CoursView/listCoursNow.dart';
import 'package:LDS/Views/CoursView/roomEnse.dart';
import 'package:LDS/Widgets/colorTheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddCours extends StatefulWidget {

  @override
  _AddCoursState createState() => _AddCoursState();
}

class _AddCoursState extends State<AddCours>{

  late dynamic cours;


  CoursViewModel coursViewModel = CoursViewModel();

  bool readOnly = true,isEmail = false;
  TextEditingController       nameController = TextEditingController(text: "");
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ColorTheme.backgroundNormalColor,
      appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Add Course",
            style: TextStyle(color: ColorTheme.titleAppBarColor),
          ),
          backgroundColor: ColorTheme.homeTopColor,
        leading: Padding(
          padding: const EdgeInsets.only(),
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            color: ColorTheme.titleAppBarColor,
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListCoursNow()),
              );
            },
          ),
        ),
      ),
      body:
      Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(),
          ),
          Container(
            width: width,
            height: height,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: width,
                    height: height,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    color: Colors.transparent,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 20,),
                        Text(
                          "What is the course name ?",
                          style: TextStyle(
                              color: ColorTheme.bigTitleColor, fontSize: 20),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          onChanged: (value) => {
                            nameController.text = value,
                          },
                          controller: nameController,
                          readOnly: !readOnly,
                          cursorColor: ColorTheme.firstColor,
                          style: TextStyle(color: ColorTheme.firstColor),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: ColorTheme.colorBackgroundCard,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: ColorTheme.firstColor),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            labelText: "Course name",
                            labelStyle: TextStyle(color: ColorTheme.smalTitleColor),
                            prefixIcon: Icon(
                              Icons.school,
                              color: ColorTheme.firstColor,
                              size: 20,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(
                                width: 2,
                                color: ColorTheme.firstColor, // Blue border when focused
                              ),
                            ),
                            contentPadding: EdgeInsets.only(left: width/2.8, top: 30.0, right: 16.0, bottom: 8.0), // Adjust padding
                          ),
                        ),
                        SizedBox(height: 15),


                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 150,
            child: FloatingActionButton(
              backgroundColor: ColorTheme.secColor,
              onPressed: () async {

                  cours = await coursViewModel.addCours(nameController.text);
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            RoomEnse(cours)),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: ColorTheme.secColor,
                      content: Row(
                        children: [
                          Icon(
                            Icons.verified,
                            size: 30,
                          ),
                          Text(
                            "Your cours started now.",
                            style: TextStyle(fontSize: 15),
                          )
                        ],

                      ),
                    ),
                  );

              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: 20,),

                  Text(
                    "START",
                    style: TextStyle(
                      color: ColorTheme.backgroundNormalColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 15,),
                  Icon(Icons.play_circle, color: ColorTheme.backgroundNormalColor),
                ],
              ),
            ),

          )


        ],
      )
      ,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}