/**
 * Representacao de uma parada
 * @author Silio Silvestre
 * */
class Stop {
  Stop.fromMap(Map<dynamic, dynamic> json) {
    code = json["CodigoParada"];
    nickname = json["Denomicao"];
    address = json["Endereco"];
    latitude = double.tryParse(json["Lat"]);
    longititude = double.tryParse(json["Long"]);
  }

  int code;
  String nickname;
  String address;
  double latitude;
  double longititude;
}
