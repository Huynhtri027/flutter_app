import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new MyProfilePage(),
    );
  }
}
class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => new _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  @override
  void initState() {
    super.initState();
    initUser();
//    getcurrentuser();
  }
  String name,email;
  initUser() async {
    user = await _auth.currentUser();
    print(user.uid);
    var res = await  Firestore.instance.collection('Users').document(user.uid);
    print("----");
    res.snapshots().listen((data){
      var dt = data.data;
      print(dt);
      setState(() {
        name = dt["name"];
        email =dt["email"];
        print(name);
        print(email);
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Stack(
      children: <Widget>[
        ClipPath(
          child: Container(color: Colors.deepPurpleAccent.withOpacity(0.8)),
          clipper: getClipper(),
        ),
        Positioned(
            width: 350.0,
            top: MediaQuery.of(context).size.height / 5,
            child: Column(
              children: <Widget>[
                Container(
                    width: 150.0,
                    height: 150.0,
                    decoration: BoxDecoration(
                        color: Colors.deepPurpleAccent,
                        image: DecorationImage(
                            image: NetworkImage(
                                ''),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.all(Radius.circular(75.0)),
                        boxShadow: [
                          BoxShadow(blurRadius: 7.0, color: Colors.black)
                        ])),
                SizedBox(height: 90.0),
                Text(name.toString(),style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat'),),
                SizedBox(height: 15.0),
                Text(email.toString(), style: TextStyle(
                    fontSize: 17.0,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Montserrat'),),

                SizedBox(height: 25.0),
                Container(
                    height: 30.0,
                    width: 95.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: Colors.deepPurpleAccent,
                      color: Colors.deepPurpleAccent,
                      elevation: 7.0,
                      child: GestureDetector(
                        onTap: () {},
                        child: Center(
                          child: Text(
                            'Edit Name',
                            style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                          ),
                        ),
                      ),
                    )),
                    SizedBox(height: 25.0),
                Container(
                    height: 30.0,
                    width: 95.0,
                    child: Material(
                      borderRadius: BorderRadius.circular(20.0),
                      shadowColor: Colors.deepPurpleAccent,
                      color: Colors.deepPurpleAccent,
                      elevation: 7.0,
                      child: GestureDetector(
                        onTap: () {},
                        child: Center(
                          child: Text(
                            'Edit password',
                            style: TextStyle(color: Colors.white, fontFamily: 'Montserrat'),
                          ),
                        ),
                      ),
                    ))
              ],
            ))
      ],
    ));
  }
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 1.9);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}