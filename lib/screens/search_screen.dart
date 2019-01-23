import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buscar no StarBus"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: (){},
            tooltip: "Pesquisar",
          )
        ],
      ),
     body: FutureBuilder(
         builder: null
     ),
    );
  }
}

