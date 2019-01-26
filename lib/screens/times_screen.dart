import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:io' show Platform;

class TimesScreen extends StatefulWidget {
  final dynamic _line;

  TimesScreen(this._line);

  @override
  _TimesScreenState createState() => _TimesScreenState(_line);
}

class _TimesScreenState extends State<TimesScreen> {
  final dynamic _line;

  _TimesScreenState(this._line);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseDatabase.instance
            .reference()
            .child('horarios')
            .child(_line['CodigoLinha'])
            .once(),
        builder: (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Scaffold(
                appBar: AppBar(
                  title: Text("Horários de ${_line['CodigoLinha']}"),
                ),
                body: Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    strokeWidth: 5,
                  ),
                ),
              );
            default:
              if (snapshot.hasError)
                return Scaffold(
                    appBar: AppBar(
                      title: Text("Horários de ${_line['CodigoLinha']}"),
                    ),
                    body: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(16),
                      child: Text(
                          "Parece que algo deu errado, tente novamente mais tarde"),
                    ));

              if (snapshot.data.value == null) {
                return Scaffold(
                    appBar: AppBar(
                      title: Text("Horários de ${_line['CodigoLinha']}"),
                    ),
                    body: Container(
                      alignment: Alignment.center,
                      child: Text(
                          "Essa linha não possui nenhum horário registrado"),
                    ));
              }

              int count = 0;

              var tabs = List<Widget>();
              var children = List<Widget>();
              if (_checkHasPeriod(snapshot, 'week')) {
                count++;
                tabs.add(Tab(
                  text: "SEMANA",
                ));
                children.add(_gridTab(snapshot, 'week'));
              }
              if (_checkHasPeriod(snapshot, 'saturday')) {
                count++;
                tabs.add(Tab(
                  text: "SÁBADO",
                ));
                children.add(_gridTab(snapshot, 'saturday'));
              }
              if (_checkHasPeriod(snapshot, 'sunday')) {
                count++;
                tabs.add(Tab(
                  text: "DOMINGO",
                ));
                children.add(_gridTab(snapshot, 'sunday'));
              }

              return DefaultTabController(
                length: count,
                child: Scaffold(
                  appBar: AppBar(
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: Platform.isAndroid
                          ? CrossAxisAlignment.start
                          : CrossAxisAlignment.center,
                      children: <Widget>[
                        Text("Horários de ${_line['CodigoLinha']}",
                            style: TextStyle(fontSize: 22)),
                        Text(
                          "Ponto inicial: ${snapshot.data.value['startPoint']}",
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                    bottom: TabBar(
                      tabs: tabs,
                    ),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(Icons.help_outline),
                        onPressed: () {
                          _getDetailsTimes();
                        },
                        tooltip: "Ajuda",
                      ),
                    ],
                  ),
                  body: TabBarView(
                    children: children,
                  ),
                ),
              );
          }
        });
  }

  _checkHasPeriod(AsyncSnapshot<DataSnapshot> snapshot, String period) {
    return snapshot.data.value['times'][period] != null;
  }

  _getDetailsTimes() {
    FirebaseDatabase.instance
        .reference()
        .child('horarios')
        .child('informacoes')
        .once()
        .then((DataSnapshot snapshot) {
      _showDialog(context, snapshot.value['titulo'],
          "${snapshot.value['legenda']}\n\nÚltima atualização em ${snapshot.value['ultimaAtualizacao']}");
    });
  }

  void _showDialog(context, title, content) {
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

  Widget _gridTab(AsyncSnapshot<DataSnapshot> snapshot, String period) {
    return GridView.builder(
        padding: EdgeInsets.all(4.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
          childAspectRatio: 3,
        ),
        itemCount:
            snapshot.data.value['times'][period].toString().split(",").length,
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.only(left: 16),
            height: 80,
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.access_time),
                  onPressed: () {},
                ),
                Text(
                  snapshot.data.value['times']['week']
                      .toString()
                      .split(",")[index],
                  style: TextStyle(fontSize: 22),
                )
              ],
            ),
          );
        });
  }
}
