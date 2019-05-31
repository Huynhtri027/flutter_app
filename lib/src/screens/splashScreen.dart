import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreen();
  }
}

class _SplashScreen extends State<SplashScreen> with TickerProviderStateMixin {
  AnimationController _controller;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );

    _timers();
  }

  void _timers() {
    Timer(
      const Duration(milliseconds: 500),
      () => _controller.forward(),
    );
    _checkLogin();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FractionallySizedBox(
        widthFactor: 0.3,
        child: ScaleTransition(
          scale: CurvedAnimation(
            parent: _controller,
            curve: Interval(0.0, 1.0, curve: Curves.elasticOut),
            reverseCurve: Interval(0.0, 1.0, curve: Curves.elasticOut),
          ),
          child: Image.asset('assets/images/taxi.png'),
        ),
      ),
    );
  }

  void _checkLogin() {
    firebaseAuth.currentUser().then((user) {
      if (user != null) {
        Timer(
          const Duration(seconds: 2),
          () => _controller.reverse().then(
                (_) {
                  Future.delayed(Duration(milliseconds: 300), () {
                    if (mounted) {
                      Navigator.pushReplacementNamed(context, '/toHome');
                    }
                  });
                },
              ),
        );
      } else {
        Timer(
          const Duration(seconds: 2),
          () => _controller.reverse().then(
                (_) {
                  Future.delayed(Duration(milliseconds: 300), () {
                    if (mounted) {
                      Navigator.pushReplacementNamed(context, '/toWelcome');
                    }
                  });
                },
              ),
        );
      }
    }).catchError((error) {
      print(error);
    });
  }
}
