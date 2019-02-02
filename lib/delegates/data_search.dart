import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:itp/models/line.dart';
import 'package:itp/screens/times_screen.dart';
import 'package:itp/util/util.dart';

class DataSearch extends SearchDelegate<String> {
  List<Line> _list;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    Future.delayed(Duration.zero).then((_) => close(context, query));
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return FutureBuilder(
        future: FirebaseDatabase.instance.reference().child('linhas').once(),
        builder: (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {
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

              _list = List<Line>();
              for (var json in snapshot.data.value) {
                Line line = Line.fromMap(json);
                _list.add(line);
              }
              _list.sort((a, b) =>
                  a.code.toLowerCase().compareTo(b.code.toLowerCase()));
              return _returnListResults(context, _list);
          }
        },
      );
    } else {
      return _suggestions(context, query);
    }
  }

  ListView _returnListResults(BuildContext context, List<Line> list) {
    return ListView.builder(
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
            onTap: () {
              close(context, list[index].code);
            },
          );
        });
  }

  _suggestions(BuildContext context, String search) {
    search = Util.removeDiacritics(search.toLowerCase().trim());
    List<Line> auxList = _list
        .where((line) =>
            Util.removeDiacritics(line.code.toString())
                .toLowerCase()
                .contains(search) ||
            Util.removeDiacritics(line.nickname.toString())
                .toLowerCase()
                .contains(search))
        .toList();
    return _returnListResults(context, auxList);
  }
}
