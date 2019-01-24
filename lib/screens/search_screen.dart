import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

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

                List list = snapshot.data.value;
                print(list);

                return ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (BuildContext ctxt, int index) {
                      return InkWell(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.all(16),
                          height: 80,
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                child: IconButton(
                                    icon: Icon(Icons.directions_bus),
                                    onPressed: () {}),
                              ),
                              Container(
                                padding: EdgeInsets.only(left: 16),
                                alignment: Alignment.center,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      list[index]['CodigoLinha'],
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      list[index]['Denomicao'] ??
                                          "Não informado",
                                      style: TextStyle(fontSize: 14),
                                      maxLines: 2,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );

                      Text(list[index]['Denomicao']);
                    });

//                return Container(
//                  alignment: Alignment.center,
//                  padding: EdgeInsets.all(16),
//                  child: Text("Recuperou tudo de boa"),
//                );
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
