import 'package:flutter/material.dart';
import 'package:itp/models/stop.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class StopScreen extends StatefulWidget {
  final Stop _stop;

  StopScreen(this._stop);

  @override
  _StopScreenState createState() => _StopScreenState(this._stop);
}

class _StopScreenState extends State<StopScreen> {
  GoogleMapController _mapController;
  final Stop _stop;

  _StopScreenState(this._stop);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Parada ${_stop.code}"),
            Text(
              _stop.nickname,
              style: TextStyle(fontSize: 12),
            ),
          ],
        )),
        body: SingleChildScrollView(
            child: Column(
          children: <Widget>[
            Container(
              height: 300,
              child: GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target:
                      LatLng(this._stop.longititude, this._stop.longititude),
                  zoom: 11,
                ),
              ),
            ),
            Divider(
              height: 1,
            ),
            Container(
              margin: EdgeInsets.all(16),
              child: Text(
                _stop.address,
                style: TextStyle(fontSize: 20),
              ),
            )
          ],
        )));
  }

  String _titleInfowindow(Stop stop) {
    return 'Parada ${stop.code} • ${stop.nickname}';
  }

  void _addStopOnMap(Stop stop) {
    var latlng = LatLng(stop.latitude, stop.longititude);
    _mapController.addMarker(
      MarkerOptions(
        position: latlng,
        infoWindowText: InfoWindowText(
          _titleInfowindow(stop),
          stop.address,
        ),
        icon: Theme.of(context).platform == TargetPlatform.iOS
            ? BitmapDescriptor.fromAsset("assets/ios/stopbus_green.png")
            : BitmapDescriptor.fromAsset("assets/android/stopbus_green.png"),
      ),
    );

    _mapController.moveCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: latlng,
        zoom: 15.0,
      ),
    ));
  }

  void _onMapCreated(GoogleMapController controller) async {
    setState(() {
      _mapController = controller;
      _addStopOnMap(_stop);
    });
  }
}
