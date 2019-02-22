import 'package:flutter/material.dart';
import 'package:itp/tiles/drawer_tile.dart';

class CustomDrawer extends StatelessWidget {
  PageController _pageController = PageController();

  CustomDrawer(this._pageController);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Column(
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text("Silio Silvestre"),
          accountEmail: Text("siliosffreitas@gmail.com"),
          currentAccountPicture: GestureDetector(
            onTap: () => print('clicou na imagem de perfil'),
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://www.shareicon.net/data/128x128/2016/09/01/822727_user_512x512.png"),
            ),
          ),
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      "http://clipart-library.com/img/795833.jpg"))),
          otherAccountsPictures: <Widget>[
            GestureDetector(
              onTap: () => print('clicou na imagem de perfil'),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    "http://www.sclance.com/pngs/profile-icon-png/profile_icon_png_1113474.png"),
              ),
            ),
          ],
          onDetailsPressed: () => print("clique nos detalhes"),
        ),
        Expanded(
          child: Container(
              child: ListView(
            children: <Widget>[
              DrawerTile(Icons.home, "Início", _pageController, 0),
              DrawerTile(Icons.place, "Informar veículo", _pageController, 6),
              DrawerTile(Icons.message, "Fale com a gente", _pageController, 2),
              DrawerTile(Icons.share, "Compartilhar", _pageController, 3),
              DrawerTile(Icons.home, "Tutorial", _pageController, 4),
              DrawerTile(Icons.info, "Sobre", _pageController, 5),
            ],
          )),
        ),
        Material(
          elevation: 10,
          child:
              DrawerTile(Icons.settings, "Configurações", _pageController, 1),
        )
      ],
    ));
  }
}
