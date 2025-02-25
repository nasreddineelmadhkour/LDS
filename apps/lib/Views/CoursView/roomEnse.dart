import 'dart:convert';
import 'dart:math';
import 'package:LDS/Network/BaseURL.dart';
import 'package:LDS/ViewModel/CoursViewModel.dart';
import 'package:LDS/Views/CoursView/listCoursNow.dart';
import 'package:LDS/Views/HomeView/navBar.dart';
import 'package:LDS/Widgets/colorTheme.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text_continuous/speech_recognition_error.dart';
import 'package:speech_to_text_continuous/speech_recognition_result.dart';
import 'package:speech_to_text_continuous/speech_to_text.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'dart:async';

class RoomEnse extends StatefulWidget {
  final dynamic _cours;
  RoomEnse(this._cours);

  @override
  _RoomEnseState createState() => _RoomEnseState();
}

class _RoomEnseState extends State<RoomEnse> {
  DateTime? _currentTime,
      _startPauseTime,
      _resumeTime; // Store current date-time
  DateTime? _startTime;
  CoursViewModel coursViewModel = CoursViewModel();

  final TextEditingController _timeController = TextEditingController();

  late StompClient _stompClient; // Declare as late
  SpeechToText _speech = SpeechToText();
  bool _isListening = false;
  String _text = "Press the microphone and speak...";
  String _selectedLanguage = "fr-FR"; // Langue par défaut
  Timer? _timer;
  bool _isPaused = false; // Add this flag

  Duration? duration = Duration.zero;

  double level = 0.0;
  double minSoundLevel = 50000;
  double maxSoundLevel = -50000;

  bool _speechEnabled = false;

  final List<Map<String, String>> _languages = [
    {"name": "Français", "code": "fr-FR"},
    {"name": "Anglais", "code": "en-US"},
    {"name": "Espagnol", "code": "es-ES"},
    {"name": "Allemand", "code": "de-DE"},
    {"name": "Arabe", "code": "ar-SA"},
  ];

  String description = "";

  String isP = "false";
  bool editEtat = true;
  int status = 0;

  @override
  void initState() {
    super.initState();
    _requestMicrophonePermission();
    _initializeSpeechRecognizer();
    _connectToWebSocket();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.backgroundNormalColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "ROOM",
          style: TextStyle(
            color: ColorTheme.titleAppBarColor,
          ),
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
        actions: [],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            _buildTimer(),
            SizedBox(height: 40),
            _buildTeacherView(),
            SizedBox(height: 20),
            _buildSubtitles(),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTeacherView() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 20),
            Text(
              "Language :",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold , color: ColorTheme.smalTitleColor),
            ),
            SizedBox(width: 10),
            DropdownButton<String>(
              value: _selectedLanguage,
              padding: EdgeInsets.only(right: 20),
              style: TextStyle(color: ColorTheme.hintTitleColor),
              underline: Container(), // Remove the underline

              items: _languages.map((lang) {
                return DropdownMenuItem(
                  value: lang["code"],
                  child: Text(
                    lang["name"]!,
                    style: TextStyle(fontSize: 20 , color: ColorTheme.firstColor),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
              },
            ),
          ],
        ),
        SizedBox(height: 20),
        Text(
          "Press and speak ...",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold , color: ColorTheme.smalTitleColor),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: GestureDetector(
                onTap: _listen,
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor:
                      _isListening ? Colors.grey : ColorTheme.firstColor,
                  child: Icon(Icons.mic,
                      color: ColorTheme.foorColor, size: 40),
                ),
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        blurRadius: .26,
                        spreadRadius: level * 1.5,
                        color: ColorTheme.firstColor.withOpacity(.05))
                  ],
                  color: Colors.white,
                  borderRadius: const BorderRadius.all(Radius.circular(50))),
            ),
            SizedBox(width: 20),
            if (_isListening)
              ElevatedButton.icon(
                onPressed: _stopListening,
                icon: Icon(Icons.save, color: ColorTheme.firstColor),
                label: Text("Save",
                    style: TextStyle(color: ColorTheme.firstColor)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: ColorTheme.foorColor),
              ),
            if (_isListening) SizedBox(width: 20),
            if (_isListening && !_isPaused)
              ElevatedButton.icon(
                onPressed: _pauseListening,
                icon: Icon(Icons.pause, color: ColorTheme.foorColor),
                label: Text("PAUSE",
                    style: TextStyle(color: ColorTheme.foorColor)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: ColorTheme.firstColor),
              ),
            if (_isPaused) // Show RESUME if paused
              ElevatedButton.icon(
                onPressed: _resumeListening,
                icon:

                    Icon(Icons.play_arrow, color: ColorTheme.foorColor),
                label: Text("RESUME",
                    style: TextStyle(color: ColorTheme.foorColor)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: ColorTheme.firstColor),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildSubtitles() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          _text,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  void _listen() async {
    if (!_isPaused) _startTime = DateTime.now();

    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          print("Status: $status");
          if (status == "notListening") {
            _restartListening(); // Redémarre automatiquement si l'écoute s'arrête
          }
        },
      );

      if (available) {
        setState(() {
          _isListening = true;
        });
        _startTimer();

        _speech.listen(
          onResult: (val) {
            setState(() {
              _text = val.recognizedWords;
              description = _text;
              _sendMessage();
            });
          },
          localeId: _selectedLanguage,
          listenFor: Duration(minutes: 90), // Essaye une durée plus longue
          pauseFor: Duration(
              minutes: 5), // Permet d'attendre plus longtemps avant l'arrêt
          partialResults: true, // Active les résultats intermédiaires
        );
      } else {
        print("Speech recognition not available.");
      }
    }
  }

  void _restartListening() {
    if (_isListening) {
      _speech.stop();
      Future.delayed(Duration(milliseconds: 500), () {
        _listen(); // Relance l'écoute après un petit délai
      });
    }
  }

  Future<void> _requestMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  }

  void _initializeSpeechRecognizer() async {
    bool available = await _speech.initialize(
      onStatus: _onSpeechStatus,
      onError: _onSpeechError,
    );
    if (available) {
      setState(() => _speechEnabled = true);
    } else {
      setState(() => _speechEnabled = false);
    }
  }

  void _startListening() {
    if (_speechEnabled && !_speech.isListening) {
      _speech.listen(
        onResult: _onSpeechResult,
        localeId: _selectedLanguage,
        listenFor: Duration(minutes: 90),
        pauseFor: Duration(minutes: 5),
        onSoundLevelChange: soundLevelListener,
        partialResults: true,
      );
      setState(() => _isListening = true);
    }
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _text = result.recognizedWords;
      description = _text;
      _sendMessage();
    });
  }

  void _onSpeechStatus(String status) {
    if (status == 'notListening' && _isListening) {
      _startListening();
    }
  }

  void _onSpeechError(SpeechRecognitionError error) {
    if (_isListening) {
      _startListening();
    }
  }

  void _stopListening() async{
    _speech.stop();
    setState(() {
      duration = Duration.zero;
      _isListening = false;
      level = 0.0;
      print("stoped");
      _timer?.cancel(); // Stop le timer lorsque l'écoute est arrêtée
    });

    if (await coursViewModel.savedCours(widget._cours['id'])) {
      Navigator.pop(context);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => NavBar()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: ColorTheme.homeTopColor,
          content: Row(
            children: [
              Icon(
                Icons.verified,
                size: 30,
              ),
              Text(
                "Succesful saved !",
                style: TextStyle(fontSize: 15),
              )
            ],
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: ColorTheme.homeTopColor,
          content: Row(
            children: [
              Icon(
                Icons.error,
                size: 30,
              ),
              Text(
                "Your cours not saved !",
                style: TextStyle(fontSize: 15),
              )
            ],
          ),
        ),
      );
    }
  }

  void _pauseListening() {
    _speech.stop();
    _startPauseTime = DateTime.now(); // Update with current time
    setState(() {
      _isListening = false;
      level = 0.0;
      _isPaused = true; // Mark as paused
      print("paused");
    });
  }

  void _resumeListening() {
    if (_isPaused) {
      _resumeTime = DateTime.now();

      duration = (duration ?? Duration.zero) +
          (_resumeTime!.difference(_startPauseTime!));

      print(duration);
      _listen(); // Restart listening
      setState(() {
        _isPaused = false; // Reset paused flag
        _isListening = true;
      });
    }
  }

  void _startTimer() {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!_isListening) {
        timer.cancel(); // Stop the timer if listening stops
      } else {
        setState(() {
          _currentTime = DateTime.now(); // Update with current time
        });
      }
    });
  }

  void soundLevelListener(double level) {
    minSoundLevel = min(minSoundLevel, level);
    maxSoundLevel = max(maxSoundLevel, level);
    // _logEvent('sound level $level: $minSoundLevel - $maxSoundLevel ');
    setState(() {
      this.level = level;
    });
  }

  Widget _buildTimer() {
    if (_startTime == null || _currentTime == null) {
      return Container(
        width: 200, // Fixed width for the timer

        child: TextFormField(
          cursorColor: ColorTheme.principalTeal,
          style: TextStyle(color: ColorTheme.principalTeal),

          textAlign: TextAlign.center, // Center text
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                width: 3,
                color: ColorTheme.principalTeal, // Blue border when focused
              ),
            ),

            filled: true,
            fillColor: Colors.grey.withOpacity(.1),
            hintText: "0:0:0",
            labelText: "Timer",
            labelStyle: TextStyle(color: ColorTheme.smalTitleColor),
            prefixIcon: Icon(
              Icons.access_time,
              color: ColorTheme.iconbackground,
              size: 30,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                width: 3,
                color: ColorTheme.iconbackground, // Blue border when focused
              ),
            ),
            contentPadding: EdgeInsets.only(
                left: 80, top: 30.0, right: 0.0, bottom: 8.0), // Adjust padding
          ),
          readOnly: true, // Ensure the user cannot edit the timer manually
        ),
      );
    }

    // Calculate elapsed time considering pause durations
    Duration elapsed =
        _currentTime!.difference(_startTime!) - (duration ?? Duration.zero);

    // Log for debugging
    print("Total elapsed duration: ${elapsed.toString()}");
    print("Paused duration: ${duration.toString()}");

    // Update the time in the controller
    _timeController.text = _formatDuration(elapsed);

    return Container(
      width: 200, // Fixed width for the timer

      child: TextFormField(
        cursorColor: ColorTheme.principalTeal,
        style: TextStyle(color: ColorTheme.principalTeal),
        controller: _timeController,
        textAlign: TextAlign.center, // Center text
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              width: 3,
              color: ColorTheme.principalTeal, // Blue border when focused
            ),
          ),

          filled: true,
          fillColor: Colors.grey.withOpacity(.1),

          labelText: "Timer",
          labelStyle: TextStyle(color: ColorTheme.smalTitleColor),
          prefixIcon: Icon(
            Icons.access_time,
            color: ColorTheme.iconbackground,
            size: 30,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              width: 3,
              color: ColorTheme.iconbackground, // Blue border when focused
            ),
          ),
          contentPadding: EdgeInsets.only(
              left: 80, top: 30.0, right: 16.0, bottom: 8.0), // Adjust padding
        ),
        readOnly: true, // Ensure the user cannot edit the timer manually
      ),
    );
  }

  String _formatDuration(Duration duration) {
    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);
    return "$hours:$minutes:$seconds";
  }

  void _connectToWebSocket() {
    _stompClient = StompClient(
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
          Map<String, dynamic> result =
              json.decode(frame.body!); // Add null check with '!'
          setState(
            () {
              // messages.add(result['message']);
              description = result['description'];
              print(result);
              //});
            },
          );
        });
  }

  Future<void> _sendMessage() async {
    if (_stompClient.connected) {
      print("hello");
      if (widget._cours['id'].toString().isNotEmpty) {
        _stompClient.send(
          destination:
              '/app/get_from_room/${widget._cours['id']}', // Update with your destination
          body: json.encode({
            'id': widget._cours['id'],
            'name': widget._cours['name'],
            'nameprofessor': widget._cours['name'],
            'description': description,
            'date': widget._cours['date'],
          }),
        );
      } else {
        print("non value hello");
      }
    } else {
      print('WebSocket connection is not established.');
      // You can attempt to reconnect here or display an error message to the user.
    }
  }

  @override
  void dispose() {
    _speech.stop();
    _stompClient.deactivate();
    super.dispose();
  }
}

/*
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
                        padding: EdgeInsets.only(right: 30, left: 45, top: 20),
                        color: Colors.transparent,
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: _nameNotEmpty
                                        ? Colors.teal
                                        : Colors.red),
                                color: ColorTheme.colorBackgroundCard,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TextFormField(

                                readOnly: editEtat,
                                controller: _nameController,
                                style: TextStyle(
                                    color: ColorTheme.smalTitleColor),
                                decoration: InputDecoration(
                                  prefixIcon: Icon(FontAwesomeIcons.bookOpen ,
                                      color: ColorTheme.smalTitleColor),
                                  hintText: "Cours",
                                  hintStyle: TextStyle(
                                      color: ColorTheme.smalTitleColor),

                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  errorText: _nameNotEmpty
                                      ? null
                                      : 'Name cannot be empty',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _nameNotEmpty = value.isNotEmpty;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: _emailNotEmpty
                                        ? Colors.teal
                                        : Colors.red),
                                color: ColorTheme.colorBackgroundCard,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TextFormField(
                                style: TextStyle(
                                    color: ColorTheme.smalTitleColor),

                                readOnly: editEtat,
                                controller: _emailController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.date_range,
                                      color: ColorTheme.smalTitleColor),
                                  hintText: "Date",
                                  hintStyle: TextStyle(
                                      color: ColorTheme.smalTitleColor),

                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  errorText: _emailNotEmpty
                                      ? null
                                      : 'Email cannot be empty',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _emailNotEmpty = value.isNotEmpty;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: _emailNotEmpty
                                        ? Colors.teal
                                        : Colors.red),
                                color: ColorTheme.colorBackgroundCard,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TextFormField(
                                style: TextStyle(
                                    color: ColorTheme.smalTitleColor),

                                readOnly: editEtat,
                                controller: _phoneController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(FontAwesomeIcons.chalkboardTeacher  ,
                                      color: ColorTheme.smalTitleColor),
                                  hintText: "Date",
                                  hintStyle: TextStyle(
                                      color: ColorTheme.smalTitleColor),

                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  errorText: _emailNotEmpty
                                      ? null
                                      : 'Email cannot be empty',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _emailNotEmpty = value.isNotEmpty;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: _serialcodeNotEmpty
                                        ? Colors.teal
                                        : Colors.red),
                                color: ColorTheme.colorBackgroundCard,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TextFormField(
                                style: TextStyle(
                                    color: ColorTheme.smalTitleColor),

                                readOnly: editEtat,
                                controller: _serialcodeController,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(FontAwesomeIcons.trailer,
                                      color: ColorTheme.smalTitleColor),
                                  hintText: "Serial Number",
                                  hintStyle: TextStyle(
                                      color: ColorTheme.smalTitleColor),

                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  errorText: _serialcodeNotEmpty
                                      ? null
                                      : 'Serial number cannot be empty',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _serialcodeNotEmpty = value.isNotEmpty;
                                  });
                                },
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: _cardNotEmpty
                                        ? Colors.teal
                                        : Colors.red),
                                color: ColorTheme.colorBackgroundCard,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: TextFormField(
                                style: TextStyle(
                                    color: ColorTheme.smalTitleColor),

                                readOnly: editEtat,
                                controller: _cardController,
                                decoration: InputDecoration(
                                  prefixIcon:
                                  Icon(FontAwesomeIcons.solidIdCard,
                                      color: ColorTheme.smalTitleColor),
                                  hintText: "Card Number",
                                  hintStyle: TextStyle(
                                      color: ColorTheme.smalTitleColor),

                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none),
                                  errorText: _cardNotEmpty
                                      ? null
                                      : 'Card number cannot be empty',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _cardNotEmpty = value.isNotEmpty;
                                  });
                                },
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
  }*/
