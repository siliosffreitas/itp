import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Widget _buildBody(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(
        flex: 1,
        child: FutureBuilder(
          future: FirebaseDatabase.instance.reference().child('linhas').once(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return Container(
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
//                snapshot.val();

                return Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(16),
                  child: Text("Recuperou tudo de boa"),
                );
            }
          },
        ),
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buscar no StarBus"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
            tooltip: "Pesquisar",
          )
        ],
      ),
      body: _buildBody(context),
    );
  }
}
