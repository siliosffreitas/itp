import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:itp/screens/stop_screen.dart';
import 'package:itp/util/constants.dart';
import 'package:itp/util/util.dart';
import 'package:location/location.dart' as LocationManager;
import 'package:firebase_database/firebase_database.dart';

class MapTab extends StatefulWidget {
  @override
  _MapTabState createState() => _MapTabState();
}

class _MapTabState extends State<MapTab> {
  GoogleMapController mapController;
  List nextsStops;

  void _refresh() async {
    final center = await _getUserLocation();

    print(center);

    mapController.moveCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: center == null ? LatLng(0, 0) : center,
        zoom: 15.0,
      ),
    ));

    _getStops(center);
  }

  _getStops(LatLng userLocation) {
//    userLocation.
    if (userLocation == null) {
      _showDialog("Erro", "Algum problema ao tentar capturar sua posição");
    } else {
      FirebaseDatabase.instance
          .reference()
          .child('paradas')
          .once()
          .then((DataSnapshot snapshot) {
        for (var stop in snapshot.value) {
          if (stop['Lat'] != null && stop['Long'] != null) {
            if (Util.getDistanceBetween(
                    userLocation.latitude,
                    userLocation.longitude,
                    double.tryParse(stop['Lat'].toString()),
                    double.tryParse(stop['Long'])) <=
                DISTANCE_SEARCH_SOPTS) {
              print(stop);
              if (nextsStops == null) {
                nextsStops = new List();
              }
              nextsStops.add(stop);
              _onAddMarkerButtonPressed(stop);
              
            }
          }
        }
      });
    }
  }

  void _onAddMarkerButtonPressed(stop) {
    mapController.addMarker(
      MarkerOptions(
        position: LatLng(
          double.tryParse(stop['Lat'].toString()),
          double.tryParse(stop['Long'].toString()),
        ),
        infoWindowText: InfoWindowText(
          'Parada ${stop['CodigoParada']} • ${stop['Denomicao']}',
          stop['Endereco'],
        ),
        icon: BitmapDescriptor.fromAsset("assets/stopbus_green.png"),
      ),
    );

  }

  void _showDialog(title, content) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text(title),
          content: SingleChildScrollView(
            child: new Text(content),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Fechar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<LatLng> _getUserLocation() async {
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
        initialCameraPosition: CameraPosition(
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

    mapController.onInfoWindowTapped.add((Marker marker){
      var index = marker.options.zIndex.toInt() - 1;
      Navigator.of(context).push(MaterialPageRoute(
          builder: (BuildContext context) => StopScreen()));
    });

    _refresh();
  }
}
