import 'package:flutter/material.dart';
import 'package:itp/tiles/drawer_tile.dart';

class CustomDrawer extends StatelessWidget {
  PageController _pageController = PageController();

  CustomDrawer(this._pageController);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 8),
              padding: EdgeInsets.all(16),
              height: 200,
              color: Colors.blue,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 8,
                    left: 0,
                    child: Text(
                      "StarBus",
                      style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            DrawerTile(Icons.home, "Início", _pageController, 0),
//          DrawerTile(Icons.place, "Informar veículo", _pageController, 1),
//          DrawerTile(Icons.message, "Fale com a gente", _pageController, 2),
//          DrawerTile(Icons.share, "Compartilhar", _pageController, 3),
//          DrawerTile(Icons.home, "Tutorial", _pageController, 4),
//          DrawerTile(Icons.info, "Sobre", _pageController, 5),
            DrawerTile(Icons.settings, "Configurações", _pageController, 1),
          ],
        ),
      )

    );
  }
}
