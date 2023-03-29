import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);
  @override
  _LocationScreenState createState() => _LocationScreenState();
}
class _LocationScreenState extends State<LocationScreen> {
  String locationLat ='Null';
  String locationLong ='Null';
  String Address = 'search';




  Future<Position> _getGeoLocationPosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error( 'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> GetAddressFromLatLong(Position position)async {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    Address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(()  {
    });
  }

  @override
  Future<void> initState()  async {
    // TODO: implement initState
    super.initState();
    locationDataaa();
  }

  locationDataaa() async {
    Position position = await _getGeoLocationPosition();
    setState(()  {
      locationLat ='${position.latitude}';
      locationLong = ' ${position.longitude}';
      GetAddressFromLatLong(position);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          //  Text('Coordinates Points',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
            Text(locationLat,style: TextStyle(color: Colors.black,fontSize: 16),),
            Text(locationLong,style: TextStyle(color: Colors.black,fontSize: 16),),
            SizedBox(height: 10,),
            Text('$Address'),
            // ElevatedButton(onPressed: () async{
            //   Position position = await _getGeoLocationPosition();
            //   location ='Lat: ${position.latitude} , Long: ${position.longitude}';
            //   GetAddressFromLatLong(position);
            // }, child: Text('Get Location'))
          ],
        ),
      ),
    );
  }
}