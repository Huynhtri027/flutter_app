import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool isLoading = false;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    Size mySize = MediaQuery.of(context).size;

    return Material(
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomPadding: true,
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Container(
              height: mySize.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // To add space between widgets in row
                    children: <Widget>[
                      IconButton(
                        onPressed: () {},
                        icon: Icon(Icons.arrow_back),
                      ),
                      isLoading ? CircularProgressIndicator() : Center(),

                      /// This is called [Ternary Expression] we said if isLoading is true
                      /// then show loader otherwise show Center() Widget.
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Welcome back ,login to continue',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 8),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'example@company.com',
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          validator: (String value) {
                            if (value.isEmpty ||
                                !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                    .hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                          },
                          onSaved: (String value) {
                            // here we get the value user is typing in the current field
                            email = value;
                          },
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          obscureText: true, // This will hide the text
                          decoration: InputDecoration(
                            hintText: 'Your password',
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                          validator: (String value) {
                            // here we check if the current password field value is not null
                            // its size is loner than 8 characters
                            if (value.isEmpty || value.length < 8) {
                              return 'Password must be 8 characters long';
                            }
                          },
                          onSaved: (String value) {
                            password = value;
                          },
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: mySize.width * .7,
                          height: 50,
                          child: RaisedButton(
                            onPressed: () {
                              _signinUser();
                              print('clicked');
                            },
                            color: Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Login me in',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: mySize.width * .7,
                          height: 50,
                          margin: EdgeInsets.only(top: 8),
                          child: FlatButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/toSignup');
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Create new account',
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _signinUser() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      isLoading = true;
    });

    FirebaseUser user;
    String uid;
    String userToken;


    auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((FirebaseUser user) {
      if (user != null) {
        // User is not null means we successfully registered the user to firebase
        user = user;
        uid = user.uid;

        //Getting the user token
        user.getIdToken().then((token) {
          userToken = token;
          setState(() {
            isLoading = false;
          });
          Navigator.pushReplacementNamed(context, '/toHome');
        }).catchError((error) {
          print('Error fetching token');
          setState(() {
            isLoading = false;
          });
        });
      }
    }).catchError((error) {
      print('Something went wrong! $error');
      setState(() {
        isLoading = false;
      });
    });
  }
}
