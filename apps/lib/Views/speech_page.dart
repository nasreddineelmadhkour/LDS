
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text_continuous/speech_to_text.dart';

class SpeechToTextPage extends StatefulWidget {
  @override
  _SpeechToTextPageState createState() => _SpeechToTextPageState();
}

class _SpeechToTextPageState extends State<SpeechToTextPage> {
  SpeechToText _speech = SpeechToText();
  bool _isListening = false;
  String _text = "Appuyez sur le micro et parlez...";
  String _role = ""; // "teacher" ou "student"
  String _selectedLanguage = "fr-FR"; // Langue par défaut

  Timer? _timer;
  int _seconds = 0;

  final List<Map<String, String>> _languages = [
    {"name": "Français", "code": "fr-FR"},
    {"name": "Anglais", "code": "en-US"},
    {"name": "Espagnol", "code": "es-ES"},
    {"name": "Allemand", "code": "de-DE"},
    {"name": "Arabe", "code": "ar-SA"},
  ];

  @override
  void initState() {
    super.initState();
    _requestMicrophonePermission();
  }

  Future<void> _requestMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      await Permission.microphone.request();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Choisissez votre rôle")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Vous êtes:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => setState(() => _role = "teacher"),
                child: Text("Enseignant"),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () => setState(() => _role = "student"),
                child: Text("Étudiant"),
              ),
            ],
          ),
          SizedBox(height: 40),
          if (_role == "teacher") _buildTeacherView(),
          if (_role == "student") _buildStudentView(),
          SizedBox(height: 20),
          if (_isListening) _buildTimer(),
          SizedBox(height: 20),
          _buildSubtitles(),
        ],
      ),
    );
  }

  Widget _buildTeacherView() {
    return Column(
      children: [
        Text(
          "Sélectionnez la langue :",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        DropdownButton<String>(
          value: _selectedLanguage,
          items: _languages.map((lang) {
            return DropdownMenuItem(
              value: lang["code"],
              child: Text(lang["name"]!),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedLanguage = value!;
            });
          },
        ),
        SizedBox(height: 20),
        Text(
          "Appuyez et parlez...",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _listen,
              child: CircleAvatar(
                radius: 40,
                backgroundColor: _isListening ? Colors.red : Colors.blue,
                child: Icon(Icons.mic, color: Colors.white, size: 40),
              ),
            ),
            SizedBox(width: 20),
            if (_isListening)
              ElevatedButton.icon(
                onPressed: _stopListening,
                icon: Icon(Icons.stop, color: Colors.white),
                label: Text("Stop"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildStudentView() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        "Les sous-titres s'afficheront ici...",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
      ),
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
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildTimer() {
    return Text(
      "Temps: ${_seconds}s",
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (status) {
          if (status == "notListening") {
            _restartListening();
          }
        },
      );

      if (available) {
        setState(() {
          _isListening = true;
          _seconds = 0;
        });
        _startTimer();

        _speech.listen(
          onResult: (val) {
            setState(() => _text = val.recognizedWords);
          },
          localeId: _selectedLanguage, // Apply selected language
          listenFor: Duration(minutes: 60), // Écoute jusqu'à 5 minutes
          pauseFor: Duration(seconds: 10000),  // Attend 5s avant d'arrêter
          partialResults: true,            // Affiche les résultats partiels
        );
      }
    }
  }

// Fonction pour redémarrer automatiquement si l'écoute s'arrête
  void _restartListening() {
    if (_isListening) {
      _speech.stop();
      Future.delayed(Duration(milliseconds: 500), () {
        _listen(); // Relance l'écoute après un petit délai
      });
    }
  }


  void _stopListening() {
    setState(() {
      _isListening = false;
      _text = "Sous-titrage arrêté.";
    });
    _speech.stop();
    _stopTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _seconds = 0;
  }
}
