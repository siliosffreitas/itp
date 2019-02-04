import 'package:flutter/material.dart';
import 'package:itp/models/stop.dart';

class StopScreen extends StatelessWidget {
  final Stop _stop;

  StopScreen(this._stop);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalhes da parada ${_stop.code}"),
      ),
      body: Container(),
    );
  }
}
