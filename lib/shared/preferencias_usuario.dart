import 'package:shared_preferences/shared_preferences.dart';

class PreferenciasUsuario {
  static final PreferenciasUsuario _instancia = PreferenciasUsuario._internal();

  factory PreferenciasUsuario() {
    return _instancia;
  }

  PreferenciasUsuario._internal();
  late SharedPreferences _prefs;

  initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  int get idChat {
    return _prefs.getInt('idChat') ?? 0;
  }

  set idChat(int value) {
    _prefs.setInt('idChat', value);
  }

  bool get vistoImagen {
    return _prefs.getBool('vistoImagen') ?? false;
  }

  set vistoImagen(bool value) {
    _prefs.setBool('vistoImagen', value);
  }

  bool get vistoTexto {
    return _prefs.getBool('vistoTexto') ?? false;
  }

  set vistoTexto(bool value) {
    _prefs.setBool('vistoTexto', value);
  }

  double get limiteToken {
    return _prefs.getDouble('limiteToken') ?? 200;
  }

  set limiteToken(double value) {
    _prefs.setDouble('limiteToken', value);
  }
}
