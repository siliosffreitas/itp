import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String text;

  DrawerTile(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        child: Container(
          height: 60,
          child: Row(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(16),
                child: Icon(
                  icon,
                  size: 32,
                  color: Colors.black,
                ),
              ),
              Text(
                text,
                style: TextStyle(fontSize: 16, color: Colors.black),
              )
            ],
          ),
        ),
        onTap: () {},
      ),
    );
  }
}
