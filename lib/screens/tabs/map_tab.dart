import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:itp/models/line.dart';
import 'package:itp/models/stop.dart';
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
  GoogleMapController _mapController;
  List<Stop> _nextsStops;
  List<Line> _linesTrack;

  void _refresh() async {
    final center = await _getUserLocation();

    _mapController.moveCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: center == null ? LatLng(0, 0) : center,
        zoom: 15.0,
      ),
    ));

    _getStops(center);
  }

  addLineTrack(Line line) {
    if (_linesTrack == null || _linesTrack.isEmpty) {
      _linesTrack = List<Line>();
    }

    // procurando linha na lista de linhas, só com o contains nao detectou
    bool founded = false;
    for (var l in _linesTrack) {
      if (l.code == line.code) {
        founded = true;
        break;
      }
    }
    if (!founded) {
      if (_linesTrack.length == MAX_LINES_IN_TRACKING) {
        _showDialog("Atenção",
            "O máximo de linhas rastreadas simultaneamente é ${MAX_LINES_IN_TRACKING}");
        return;
      }

      if (_linesTrack.length >= MAX_LINES_IN_TRACKING / 2) {
        _showDialog("Atenção",
            "Muitas linhas sendo rastreadas simultaneamente pode causar lentidão e consumo excessivo de dados");
      }

      setState(() {
        line.color = _determineLineColor();
        _linesTrack.add(line);
      });

      print("Linha ${line.code} adicionada ao rastreamento ");
    } else {
      print("Linha ${line.code} já está no rastreamento");
    }
  }

  _determineLineColor() {
    List<Color> colors = [
      Colors.blueAccent,
      Colors.redAccent,
      Colors.greenAccent,
      Colors.yellowAccent,
      Colors.orangeAccent,
      Colors.green,
      Colors.brown,
      Colors.purpleAccent,
      Colors.lightBlueAccent,
      Colors.grey
    ];
    if (_linesTrack == null) {
      return colors[0];
    }
    for (var color in colors) {
      bool founded = false;
      for (var line in _linesTrack) {
        if (line.color != null && color == line.color) {
          founded = true;
          break;
        }
      }
      if (!founded) {
        return color;
      }
    }
  }

  removeLineTrack(Line line) {
    for (var l in _linesTrack) {
      if (l.code == line.code) {
        setState(() {
          line.color = null;
          _linesTrack.remove(l);
        });

        break;
      }
    }
  }

  _getStops(LatLng userLocation) {
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
              if (_nextsStops == null) {
                _nextsStops = new List();
              }
              Stop s = Stop.fromMap(stop);
              _nextsStops.add(s);
              _addStopOnMap(s);
            }
          }
        }
      });
    }
  }

  String _titleInfowindow(Stop stop) {
    return 'Parada ${stop.code} • ${stop.nickname}';
  }

  void _addStopOnMap(Stop stop) {
    _mapController.addMarker(
      MarkerOptions(
        position: LatLng(stop.latitude, stop.longititude),
        infoWindowText: InfoWindowText(
          _titleInfowindow(stop),
          stop.address,
        ),
        icon: Theme.of(context).platform == TargetPlatform.iOS
            ? BitmapDescriptor.fromAsset("assets/ios/stopbus_green.png")
            : BitmapDescriptor.fromAsset("assets/android/stopbus_green.png"),
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
      return center;
    } on Exception catch (e) {
      currentLocation = null;
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      alignment: const Alignment(0, 1),
      children: <Widget>[
        GoogleMap(
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
          initialCameraPosition: CameraPosition(
            target: LatLng(-5.082618, -42.790596),
            zoom: 11,
          ),
        ),
        _linesTrack != null && _linesTrack.isNotEmpty
            ? Container(
                height: 71,
                child: Column(
                  children: <Widget>[
                    Divider(
                      height: 1,
                    ),
                    Container(
                      height: 70,
                      color: Color.fromARGB(200, 255, 255, 255),
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _linesTrack.length,
                          itemBuilder: (BuildContext ctxt, int index) {
                            return Container(
                                width: 250,
                                child: Card(
                                  child: ListTile(
                                    leading: Icon(Icons.directions_bus,
                                        color: _linesTrack[index].color),
                                    title: Text(
                                      _linesTrack[index].code,
                                    ),
                                    subtitle: Text(
                                      _linesTrack[index].nickname ??
                                          "Não informado",
                                      maxLines: 1,
                                    ),
                                    trailing: IconButton(
                                      tooltip:
                                          "Horários de ${_linesTrack[index].code}",
                                      icon: Icon(Icons.close),
                                      onPressed: () {
                                        removeLineTrack(_linesTrack[index]);
                                      },
                                    ),
                                  ),
                                ));
                          }),
                    )
                  ],
                ),
              )
            : Container()
      ],
    ));
  }

//  determineColor

  void _onMapCreated(GoogleMapController controller) async {
    setState(() {
      _mapController = controller;
    });

    _mapController.onInfoWindowTapped.add((Marker marker) async {
      for (var stop in _nextsStops) {
        if (marker.options.infoWindowText.title == _titleInfowindow(stop)) {
          Line line = await Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => StopScreen(stop)));
          if (line != null) {
            addLineTrack(line);
          }
          break;
        }
      }
    });

    _refresh();
  }
}
