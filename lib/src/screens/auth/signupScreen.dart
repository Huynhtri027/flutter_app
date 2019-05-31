// First we import material class
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Then we create stategful widget
class SignupScreen extends StatefulWidget {
  // We need to add createState method
  @override
  State<StatefulWidget> createState() {
    return _SignupScreenState();
  }
}

// Then we create state of the widget
class _SignupScreenState extends State<SignupScreen> {
  // We meed to add builder function

  // We create FirebaseAuth variable
  final FirebaseAuth auth = FirebaseAuth.instance;

  // We create the formKey, it will help to get the values from FormInputField
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // We are going to create boolean value to hide and show progress loader
  // By default it is false because we dont want to show loader, we want to show
  // only after user tap signup button.
  bool isLoading = false;
  // Lets create the variables to save the text field values
  //String name;
  //String email;
  //String password;
  String name;
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    Size mySize = MediaQuery.of(context).size;
    // We need to do this inside build function because we need 'context',

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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .spaceBetween, // To add space between widgets in row
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/toWelcome');
                        },
                        icon: Icon(Icons.arrow_back),
                      ),
                      isLoading ? CircularProgressIndicator() : Center(),

                      /// This is called [Ternary Expression] we said if isLoading is true
                      /// then show loader otherwise show Center() Widget
                    ],
                  ),
                  SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Let\'s start something fresh',
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
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Your full name',
                            labelText: 'Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Enter a valid name';
                            }
                          },
                          onSaved: (String value) {
                            name = value;
                          },
                        ),
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
                              _signupUser();
                            },
                            color: Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Create a new account',
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
                              Navigator.pushNamed(context, '/toLogin');
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Already have an account? Login',
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
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
  void _signupUser() async {
    // Check if all the formms have valid inputs
    if (!_formKey.currentState.validate()) {
      return;
    }
    // then we saved all the values to those variables-
    _formKey.currentState.save();
    // and set the loading to true
    setState(() {
      isLoading = true;
    });
    // Here we will register the user to firebase
    FirebaseUser user;
    String uid;
    String userToken;
    auth
        .createUserWithEmailAndPassword(
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
          // here after we fetch the user token, then we will upload the data to database
          userToken = token;
          setState(() {
            isLoading = false;
          });
          // Uploading the data to firebase firestore
          FirebaseAuth.instance.currentUser().then((user) {
            String uid = user.uid;

            // First we created Firestore resference, its just a path where we want to put data
            DocumentReference documentReference =
                Firestore.instance.document("Users/$uid");
            Map<String, String> userData = {
              'name': name,
              'email': email,
              'token': userToken,
            };

            documentReference.setData(userData).then((_) {
              setState(() {
                isLoading = false;
              });

              Navigator.pushReplacementNamed(context, '/toHome');
            }).catchError((error) {
              setState(() {
                isLoading = false;
              });
              print(error);
            });
          });
        }).catchError((error) {
          print('Error fetching token');
          setState(() {
            isLoading = false;
          });
        });
      }
    }).catchError((error) {
      print('Something went wrong!');
      setState(() {
        isLoading = false;
      });
    });
  }
}
