import 'dart:convert';
import 'package:LDS/Network/BaseURL.dart';
import 'package:LDS/ViewModel/CoursViewModel.dart';
import 'package:LDS/Views/CoursView/listCoursNow.dart';
import 'package:LDS/Widgets/LineEditdiv2.dart';
import 'package:LDS/Widgets/colorTheme.dart';
import 'package:LDS/Widgets/line_edit.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';


class RoomEleve extends StatefulWidget {
  final dynamic _cours;
  const RoomEleve(this._cours);

  @override
  _RoomEleveState createState() => _RoomEleveState();
}

class _RoomEleveState extends State<RoomEleve> {
  late StompClient _stompClient; // Declare as late

  String description ="";

  String isP = "false";
  bool editEtat = true;
  CoursViewModel coursViewModel = CoursViewModel();
  int status = 0;

  // Define controllers for each text field
  TextEditingController _nameController = TextEditingController(text: '');
  TextEditingController _dateController = TextEditingController(text: '');
  TextEditingController _nameprofessor = TextEditingController(text: '');
  TextEditingController _descriptionController = TextEditingController(text: '');

  @override
  void initState() {
    super.initState();

    _connectToWebSocket();

    _nameController = TextEditingController(text: widget._cours['name']);
    _dateController = TextEditingController(text: widget._cours['date'].toString().substring(0,10));
    _nameprofessor = TextEditingController(text: widget._cours['nameprofessor']);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      backgroundColor: ColorTheme.backgroundNormalColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget._cours['name'],
          style: TextStyle(color: ColorTheme.titleAppBarColor,),
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
        actions: [

        ],
      ),
      body: Stack(
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
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: width,
                        height: height,
                        padding: EdgeInsets.only(right: 20, left: 20, top: 20),
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            LineEdit(title: _nameController.text, icon: FontAwesomeIcons.bookOpen, readOnly: true),

                            SizedBox(height: 15),
                            LineEditdiv2(title: _dateController.text, icon: Icons.date_range, readOnly: true, title2: "title2", icon2: Icons.access_time, readOnly2: true),
                            SizedBox(height: 15),
                            LineEdit(title: _nameprofessor.text, icon: FontAwesomeIcons.chalkboardTeacher, readOnly: true),
                            SizedBox(height: 15),

                            SizedBox(height: 15),
                            TextFormField(
                              onChanged: (value) {
                                _descriptionController.text = value;
                              },
                              controller: _descriptionController,
                              readOnly: true,
                              cursorColor: ColorTheme.firstColor,
                              style: TextStyle(color: ColorTheme.smalTitleColor,fontSize: 20 ,  fontWeight: FontWeight.bold),
                              maxLines: null, // Allows the text to expand vertically
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: ColorTheme.colorBackgroundCard,
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: ColorTheme.firstColor),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                labelText: "Sub-title",
                                labelStyle: TextStyle(color: ColorTheme.smalTitleColor ),
                                floatingLabelBehavior: FloatingLabelBehavior.always, // Keeps label fixed
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(top: 10, left: 0), // Moves icon to top-left
                                  child: Icon(
                                    Icons.subtitles,
                                    color: ColorTheme.firstColor,
                                    size: 25,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                    width: 3,
                                    color: ColorTheme.firstColor, // Blue border when focused
                                  ),
                                ),
                                contentPadding: EdgeInsets.only(
                                  top: 50, // Moves text to start from the top
                                  left: width/2.8, // Adjusts text start position (avoiding icon overlap)
                                  right: 16,
                                  bottom: 8,
                                ),
                              ),
                            ),


                            SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: Row(
              children: [

                SizedBox(width: width - 200), // Add some space between buttons
                IconButton(
                  icon: Icon(
                      Icons.edit, color: ColorTheme.backgroundNormalColor),
                  onPressed: () {
                    // Implement edit functionality here
                    setState(() {
                      editEtat = !editEtat;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),

    );
  }
  void _connectToWebSocket() {
    _stompClient =
        StompClient(
          config: StompConfig(
            url: BaseURL.baseURL_WS,
            onConnect: _onConnect,
            onStompError: (error) {
              print('STOMP Error occurred: $error');
            },
            onWebSocketError: (error) {
              print('WebSocket Error occurred: $error');
            },
          ),
        );

    _stompClient.activate();
  }


  void _onConnect(StompFrame frame) {
    print("connected");
    _stompClient.subscribe(
        destination: '/send_to_room/${widget._cours['id']}',
        // Update with your subscription topic
        callback: (frame) {
          Map<String, dynamic> result = json.decode(
              frame.body!); // Add null check with '!'
          setState(() {
            // messages.add(result['message']);
            _descriptionController.text = result['description'];

            print(result);
            //});
          },
          );
        });
  }


  @override
  void dispose() {
    super.dispose();
    _stompClient.deactivate();
    //  _timer.cancel();
  }

}

