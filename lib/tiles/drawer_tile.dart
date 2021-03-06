import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  final IconData icon;
  final String text;
  PageController _pageController;
  final int page;

  DrawerTile(this.icon, this.text, this._pageController, this.page);

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
                  color: _pageController.page == page ? Theme.of(context).primaryColor: Colors.black,
                ),
              ),
              Text(
                text,
                style: TextStyle(fontSize: 16, color: _pageController.page == page ? Theme.of(context).primaryColor: Colors.black,),
              )
            ],
          ),
        ),
        onTap: () {
          Navigator.of(context).pop();
          _pageController.jumpToPage(page);
        },
      ),
    );
  }
}
