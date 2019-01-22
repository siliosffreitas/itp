import 'package:flutter/material.dart';
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
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
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
