import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size mySize = MediaQuery.of(context).size;
    // MediaQuery is a class which gives us information about the
    // Current Mobile Phone, information includes the phone size and etc etc
    // We created variable name 'mySize' you can name anything. Its just a variable
    // to save the value of ' MediaQuery.of(context).size' got it?yes
    // Now you must be thinking how i know the type of the data, when you hover over the
    // .size
    // This Size contains the total height and width of the screen
    return Material(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              height: mySize.height * .4,
              width: mySize.width * .8,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/art.png'),
                ),
              ),
            ),
            Expanded(child: Center()),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              child: Text(
                'Welcome ',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              child: Text(
                'We provide cabs 24x7\nFast. Efficient.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ),
            Expanded(child: Center()),
            Container(
              width: mySize.width * .7,
              height: 50,
              child: RaisedButton(
                onPressed: () {

                 // _checkPermission(context, '/toLogin');
                  Navigator.pushReplacementNamed(context, '/toLogin');

                },
                color: Colors.deepPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Sign in',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Container(
              width: mySize.width * .7,
              height: 50,
              margin: EdgeInsets.only(top: 8),
              child: FlatButton(
                onPressed: () {
                 // _checkPermission(context, '/toSignup');
                  Navigator.pushReplacementNamed(context, '/toSignup');

                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Create a new account',
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Expanded(child: Center()),
          ],
        ),
      ),
    );
  }

  /* void _checkPermission(BuildContext context, String path) async {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.contacts);
    if (permission != PermissionStatus.granted) {
      Map<PermissionGroup, PermissionStatus>
      permissions = await PermissionHandler().requestPermissions(
        [PermissionGroup.location],
      ).then((permission) {
        Navigator.pushReplacementNamed(context, path);
      });
    }
  }
  */

  }

