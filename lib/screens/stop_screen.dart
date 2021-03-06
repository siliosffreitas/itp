import 'package:flutter/material.dart';
import 'package:itp/models/line.dart';
import 'package:itp/models/stop.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:itp/screens/times_screen.dart';
import 'dart:io' show Platform;

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
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 300.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Parada ${_stop.code}",
                      ),
                      Text(
                        _stop.nickname,
                        style: TextStyle(fontSize: 12, color: Colors.grey[70]),
                      ),
                    ],
                  ),
                  background: Stack(
                    children: <Widget>[
                      GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(
                              this._stop.longititude, this._stop.longititude),
                          zoom: 11,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                              Color.fromARGB(125, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter)),
                        height: 80,
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                Color.fromARGB(125, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter)),
                          height: 80,
                        ),
                      ),
                    ],
                  )),
//              actions: <Widget>[
//                IconButton(
//                  icon: Icon(Icons.map),
//                )
//              ],
            ),
          ];
        },
        body: FutureBuilder(
          future: FirebaseDatabase.instance
              .reference()
              .child('linhasDaParada')
              .child("${_stop.code}")
              .once(),
          builder:
              (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return Container(
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    strokeWidth: 5,
                  ),
                );
              default:
                if (snapshot.hasError)
                  return Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(16),
                    child: Text(
                        "Parece que algo deu errado, tente novamente mais tarde"),
                  );
                if (snapshot.data.value == null)
                  return Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "A STRANS não associou nenhuma linha a esta parada.",
                      textAlign: TextAlign.center,
                    ),
                  );

                List _list = List<Line>();
                for (var json in snapshot.data.value) {
                  Line line = Line.fromMap(json);
                  _list.add(line);
                }
                _list.sort((a, b) =>
                    a.code.toLowerCase().compareTo(b.code.toLowerCase()));
                return _returnListResults(context, _list);
            }
          },
        ),
      ),
    );
  }

  ListView _returnListResults(BuildContext context, List<Line> list) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (BuildContext ctxt, int index) {
          return ListTile(
            leading: Icon(Icons.directions_bus),
            title: Text(
              list[index].code,
              style: TextStyle(fontSize: 20),
            ),
            subtitle: Text(
              list[index].nickname ?? "Não informado",
              style: TextStyle(fontSize: 12),
            ),
            trailing: IconButton(
              tooltip: "Horários de ${list[index].code}",
              icon: Icon(Icons.access_time),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TimesScreen(list[index])),
                );
              },
            ),
            onTap: () {},
          );
        });
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
