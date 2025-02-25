import 'package:LDS/ViewModel/AccountViewModel.dart';
import 'package:LDS/Views/LoginView/login.dart';
import 'package:LDS/Widgets/colorTheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AccountViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(), // Démarre avec le SplashScreen
      ),
    ),
  );
}

/// Splash Screen avec animation
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();

    // Après l'animation, on va vers la page Login
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()), // Va vers la page Login
      );
    });

/*
    Future.delayed(const Duration(seconds: 4), () {
      final coursData = {
        'id': 4,
        'name': "gestion",
        'nameprofessor': "nasr",
        'description': " ", // Assuming 'description' is updated dynamically
        'date': "2025-02-20T11:41:57Z",
      };

      StaticAccount.staticAccount.name = "nasr";
      StaticAccount.staticAccount.role = "Enseignant";

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RoomEnse(coursData)),
      );
    });
*/
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorTheme.principalTeal,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: const Text(
              "Langue des signes",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
