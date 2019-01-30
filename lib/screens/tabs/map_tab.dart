import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as LocationManager;

class MapTab extends StatefulWidget {
  @override
  _MapTabState createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  GoogleMapController mapController;

  void refresh() async {
    final center = await getUserLocation();

    print(center);

    mapController.moveCamera(CameraUpdate.newCameraPosition(

      CameraPosition(
          target: center == null ? LatLng(0, 0) : center,
          zoom: 15.0,
      ),
    ));
  }

  Future<LatLng> getUserLocation() async {
    var currentLocation = <String, double>{};
    final location = LocationManager.Location();
    try {
      currentLocation = await location.getLocation();
      final lat = currentLocation["latitude"];
      final lng = currentLocation["longitude"];
      final center = LatLng(lat, lng);

      print("silio");
      return center;
    } on Exception catch (e) {
      print(e.toString());
      currentLocation = null;
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        myLocationEnabled: true,
//        compassEnabled: false,
//      trackCameraPosition: false,
//      tiltGesturesEnabled: false,
        initialCameraPosition: CameraPosition(`
          target: LatLng(-5.082618, -42.790596),
          zoom: 11,
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) async {
    setState(() {
      mapController = controller;
    });

    refresh();
  }
}
