import 'package:flutter/material.dart';
import 'package:itp/delegates/data_search.dart';
import 'package:itp/screens/search_screen.dart';
import 'package:itp/screens/tabs/map_tab.dart';
import 'package:itp/screens/tabs/settings_tab.dart';
import 'package:itp/screens/widgets/custom_drawer.dart';

class HomeScreen extends StatelessWidget {
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            title: Text("StarBus"),
            actions: <Widget>[
//              IconButton(
//                icon: Icon(Icons.refresh),
//                onPressed: () {},
//                tooltip: "Atualizar",
//              ),
//              IconButton(
//                icon: Icon(Icons.notifications),
//                onPressed: () {
//                  print('teste');
//
//                },
//                tooltip: "Notificações",
//              ),
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () async{
                  String line = await showSearch(context: context, delegate: DataSearch());
                  print(line);
//                  Navigator.push(
//                    context,
//                    MaterialPageRoute(builder: (context) => SearchScreen()),
//                  );
                },
                tooltip: "Pesquisar",
              )
            ],
          ),
          drawer: CustomDrawer(_pageController),
          body: MapTab(),
        ),
        Scaffold(
          appBar: AppBar(
            title: Text("Configurações"),
          ),
          drawer: CustomDrawer(_pageController),
          body: SettingsTab(),
        ),

//        ,
      ],
    );
  }
}
