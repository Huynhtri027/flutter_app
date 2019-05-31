import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/src/screens/auth/homeScreen.dart';
import 'package:flutter_app/src/screens/auth/loginScreen.dart';
import 'package:flutter_app/src/screens/auth/signupScreen.dart';
import 'package:flutter_app/src/screens/auth/welcomeScreen.dart';
import 'package:flutter_app/src/screens/splashScreen.dart';
import 'package:page_transition/page_transition.dart';

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppState();
  }
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    //// [To make the status bar transparent]
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent),
    );

    return MaterialApp(
      title: 'iresen',
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (BuildContext context) => SplashScreen()
      }, // This line means that whenever the app launches, this will be the first screen

      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/toLogin': // I just give the login page this name
            return PageTransition(
                child: LoginScreen(), type: PageTransitionType.fade);
            break;

          case '/toSignup':
            return PageTransition(
                child: SignupScreen(), type: PageTransitionType.fade);
            break;

          case '/toWelcome':
            return PageTransition(
                child: WelcomeScreen(), type: PageTransitionType.fade);
            break;

          case '/toHome':
            return PageTransition(
                child: MyHomePage(), type: PageTransitionType.fade);
            break;

          default:
        }
      },
    );
  }
}
