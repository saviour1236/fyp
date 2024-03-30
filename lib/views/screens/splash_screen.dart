import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:tikstore/views/screens/auth/login_screen.dart';
import 'package:tikstore/views/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => HomeScreen()));
        return;
      } else {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 25),
            SizedBox(
              width: 264,
              child: Text(
                'Loading...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF482800),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  height: 0,
                ),
              ),
            ),
            const SizedBox(height: 200),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFED3B65)),
            ),
          ],
        ),
      ),
    );
  }
}
