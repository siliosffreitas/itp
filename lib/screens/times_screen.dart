import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text("Horários de ${_line['CodigoLinha']}"),
      ),
      body: FutureBuilder(
          future: FirebaseDatabase.instance
              .reference()
              .child('horarios')
              .child(_line['CodigoLinha'])
              .once(),
          builder:
              (BuildContext context, AsyncSnapshot<DataSnapshot> snapshot) {
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

                if (snapshot.data.value == null) {
                  return Container(
                    alignment: Alignment.center,
                    child:
                        Text("Essa linha não possui nenhum horário registrado"),
                  );
                }

                print(snapshot.data.value);

//                List list = snapshot.data.value;
//                list.sort((a, b) => a['CodigoLinha']
//                    .toString()
//                    .toLowerCase()
//                    .compareTo(b['CodigoLinha'].toString().toLowerCase()));
//                return ListView.builder(
//                    itemCount: list.length,
//                    itemBuilder: (BuildContext ctxt, int index) {
//                      return LinhaTile(list[index]);
//                    });

//                return Text(snapshot.data.value['startPoint']);

                return DefaultTabController(
                  length: 3,
                  child: TabBarView(
                      children: [
                        Container(color: Colors.red,),
                        Container(color: Colors.green,),
                        Container(color: Colors.blue,),
                      ])
                );
            }
          }),
    );
  }
}
