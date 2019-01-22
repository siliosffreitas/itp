import 'package:flutter/material.dart';
import 'package:itp/tiles/drawer_tile.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                  child: Text("StarBus", style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white),),
                )
              ],
            ),
          ),
          DrawerTile(Icons.home, "Início"),
          DrawerTile(Icons.place, "Informar veículo"),
          DrawerTile(Icons.message, "Fale com a gente"),
          DrawerTile(Icons.share, "Compartilhar"),
          DrawerTile(Icons.home, "Tutorial"),
          DrawerTile(Icons.info, "Sobre"),
          DrawerTile(Icons.settings, "Configurações"),
        ],
      ),
    );
  }
}
