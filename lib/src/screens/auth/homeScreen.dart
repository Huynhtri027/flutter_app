import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_app/requests/google_maps_requests.dart';
import 'package:flutter_app/src/screens/auth/signupScreen.dart';
import 'package:flutter_app/utils/core.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title ,this.userToken,}) : super(key: key);
  final String title;
  final String userToken;


 @override
  _MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser user;
  @override
  void initState() {
    super.initState();
    initUser();
//    getcurrentuser();
  }
  String name,email,token;
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
        token =dt["token"];
        print(name);
        print(email);
        print(token);

      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              AppBar(
                automaticallyImplyLeading: false,
                title: Text(""),
              ),
           // Text(name.toString()),
           // Text(email == null? "" : email),



              UserAccountsDrawerHeader(
                accountName: Text(name.toString()),
                accountEmail: Text(email.toString()),


              ),

              ListTile(
                title: Text('profile'),
                onTap: () {
                  Navigator
                        .of(context)
                        .pushReplacementNamed('/toProfile');
                },
              ),
              ListTile(
                title: Text('settings'),
                onTap: () {},
              ),
              ListTile(
                title: Text('Logout'),
                onTap: () {
                  FirebaseAuth.instance.signOut().then((action) {
                    Navigator
                        .of(context)
                        .pushReplacementNamed('/toWelcome');
                  });
                },
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: Text('Home'),
        ),
        body: Map()
    );
  }
/*
  Future<User> getcurrentuser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DocumentSnapshot snap = await Firestore.instance.collection('users').document().get();
    setState(() {
      widget.user = new User.fromDocument(snap); });
    new User.fromDocument(snap);
    print(snap);
  }
  */
}




class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  //
  Firestore firestore = Firestore.instance;
  Geoflutterfire geo = Geoflutterfire();


  GoogleMapController mapController;
  GoogleMapsServices _googleMapsServices = GoogleMapsServices();
  TextEditingController locationController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  static LatLng _initialPosition;
  LatLng _lastPosition = _initialPosition;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polyLines = {};


  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {
    return _initialPosition == null? Container(
      alignment: Alignment.center,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    ) : Stack(
      children: <Widget>[
        GoogleMap(
          initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 10.0),
          onMapCreated: onCreated,
          myLocationEnabled: true,
          mapType: MapType.normal,
          compassEnabled: true,
          markers: _markers,
          onCameraMove: _onCameraMove,
          polylines: _polyLines,
        ),
        //
        Positioned(
            bottom: 50,
            right: 10,
            child:
            FlatButton(
                child: Icon(Icons.pin_drop),
                color: Colors.lightBlue,
                onPressed: _addGeoPoint
            )
        ),
        //
        Positioned(
            bottom: 50,
            left: 110,
            right: 110,
            child:
            RaisedButton(
              onPressed: () {
                //_makeRequest();

                getUserDoc();

                   print('clicked');
              },

              color: Colors.lightBlue,
                shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),

                ),

              child: Text(
                'Find driver',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
        ),


        Positioned(
          top: 50.0,
          right: 15.0,
          left: 15.0,
          child: Container(
            height: 50.0,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    offset: Offset(1.0, 5.0),
                    blurRadius: 10,
                    spreadRadius: 3)
              ],
            ),
            child: TextField(
              cursorColor: Colors.black,
              controller: locationController,
              decoration: InputDecoration(
                icon: Container(margin: EdgeInsets.only(left: 20, top: 5), width: 10, height: 10, child: Icon(Icons.location_on, color: Colors.black,),),
                hintText: "pick up",
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
              ),
            ),
          ),
        ),

        Positioned(
          top: 105.0,
          right: 15.0,
          left: 15.0,
          child: Container(
            height: 50.0,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.grey,
                    offset: Offset(1.0, 5.0),
                    blurRadius: 10,
                    spreadRadius: 3)
              ],
            ),
            child: TextField(
              cursorColor: Colors.black,
              controller: destinationController,
              textInputAction: TextInputAction.go,
              onSubmitted: (value){
                sendRequest(value);
              },
              decoration: InputDecoration(
                icon: Container(margin: EdgeInsets.only(left: 20, top: 5), width: 10, height: 10, child: Icon(Icons.local_taxi, color: Colors.black,),),
                hintText: "destination?",
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 15.0, top: 16.0),
              ),
            ),
          ),
        ),

//        Positioned(
//          top: 40,
//          right: 10,
//          child: FloatingActionButton(onPressed: _onAddMarkerPressed,
//          tooltip: "aadd marker",
//          backgroundColor: black,
//          child: Icon(Icons.add_location, color: white,),
//          ),
//        )
      ],
    );
  }

  void onCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _lastPosition = position.target;
    });
  }

  void _addMarker(LatLng location, String address){
    setState(() {
      _markers.add(Marker(markerId: MarkerId(_lastPosition.toString()),
          position: location,
          infoWindow: InfoWindow(
              title: address,
              snippet: "go here"
          ),
          icon: BitmapDescriptor.defaultMarker
      ));
    });
  }

  void createRoute(String encondedPoly){
    setState(() {
      _polyLines.add(Polyline(polylineId: PolylineId(_lastPosition.toString()),
          width: 10,
          points: convertToLatLng(decodePoly(encondedPoly)),
          color: Colors.black));
    });
  }

/*
* [12.12, 312.2, 321.3, 231.4, 234.5, 2342.6, 2341.7, 1321.4]
* (0-------1-------2------3------4------5-------6-------7)
* */

//  this method will convert list of doubles into latlng
  List<LatLng> convertToLatLng(List points){
    List<LatLng> result = <LatLng>[];
    for(int i = 0; i < points.length; i++){
      if(i % 2 != 0){
        result.add(LatLng(points[i - 1], points[i]));
      }
    }
    return result;
  }

  List decodePoly(String poly){
    var list=poly.codeUnits;
    var lList=new List();
    int index=0;
    int len= poly.length;
    int c=0;
// repeating until all attributes are decoded
    do
    {
      var shift=0;
      int result=0;

      // for decoding value of one attribute
      do
      {
        c=list[index]-63;
        result|=(c & 0x1F)<<(shift*5);
        index++;
        shift++;
      }while(c>=32);
      /* if value is negetive then bitwise not the value */
      if(result & 1==1)
      {
        result=~result;
      }
      var result1 = (result >> 1) * 0.00001;
      lList.add(result1);
    }while(index<len);

/*adding to previous value as done in encoding */
    for(var i=2;i<lList.length;i++)
      lList[i]+=lList[i-2];

    print(lList.toString());

    return lList;
  }

  void _getUserLocation() async{
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    //
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      //
locationController.text = placemark[0].name;
    });
  }


  void sendRequest(String intendedLocation)async{
    List<Placemark> placemark = await Geolocator().placemarkFromAddress(intendedLocation);
    double latitude = placemark[0].position.latitude;
    double longitude = placemark[0].position.longitude;
    LatLng destination = LatLng(latitude, longitude);
    _addMarker(destination, intendedLocation);

    String route = await _googleMapsServices.getRouteCoordinates(_initialPosition, destination);
    createRoute(route);

  }
  Future<DocumentReference> _addGeoPoint() async {

    var pos = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    GeoFirePoint point = geo.point(latitude: pos.latitude, longitude: pos.longitude);
    return firestore.collection('locations').add({
      'position': point.data,

    });
  }

 Future<DocumentReference> _makeRequest() async {

   var where  =destinationController.value;
    return firestore.collection('user destination').add({
      'destination':where.text,


    });
  }
  Future<DocumentReference> _logout() async {
    FirebaseAuth.instance.signOut().then((action) {
      Navigator
          .of(context)
          .pushReplacementNamed('/toWelcome');
    }).catchError((e) {
      print(e);
    });
  }

  Future<DocumentReference> getUserDoc() async {
    //user location
    var pos = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    GeoFirePoint point = geo.point(latitude: pos.latitude, longitude: pos.longitude);
    //get current user id
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final Firestore _firestore = Firestore.instance;
    FirebaseUser user = await _auth.currentUser();
    DocumentReference ref = _firestore.collection('users').document(user.uid);

    var userLocation = {
      'position': point,
      'id': ref,
    };
    return firestore.collection('locations').add(userLocation);

}
}

