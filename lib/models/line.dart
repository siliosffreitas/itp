/**
 * Representacao de uma parada
 * @author Silio Silvestre
 * */
class Line {
  Line.fromMap(Map<dynamic, dynamic> json) {
    circular = json["Circular"];
    code = json["CodigoLinha"];
    nickname = json["Denomicao"];
    origin = json["Origem"];
    destiny = json["Retorno"];
  }

  bool circular;
  String code;
  String nickname;
  String origin;
  String destiny;

  @override
  String toString() {
    // TODO: implement toString
    return "circular: ${circular},\tcode: ${code},\tnickname: ${nickname},\torigin: ${origin},\tdestiny: ${destiny}";
  }
}
