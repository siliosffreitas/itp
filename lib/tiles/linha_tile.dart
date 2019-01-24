import 'package:flutter/material.dart';

class LinhaTile extends StatelessWidget {

  final dynamic _linha;

  LinhaTile(this._linha);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: EdgeInsets.all(16),
        height: 80,
        child: Row(
          children: <Widget>[
            CircleAvatar(
              child: IconButton(
                  icon: Icon(Icons.directions_bus), onPressed: () {}),
            ),
            Container(
              padding: EdgeInsets.only(left: 16),
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    _linha['CodigoLinha'],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _linha['Denomicao'] ?? "Não informado",
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
  }
}
