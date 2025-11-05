import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static SharedPreferencesService? _instance;

  static SharedPreferences? _preferences;

  SharedPreferencesService._();

  static Future<void> init() async {
    // 1. Adicione "static"
    if (_instance != null) {
      return; // 2. Mude esta linha para "return;"
    }

    _instance = SharedPreferencesService._();

    _preferences = await SharedPreferences.getInstance();

    return; // 3. Mude esta linha para "return;"
  }
  // ...

  Future<bool> saveInt(String key, int value) async {
    try {
      bool result = await _preferences!.setInt(key, value);
      return result;
    } catch (erro) {
      debugPrint("Falha ao salvar inteiro: $erro");
      return false;
    }
  }

  Future<bool> saveString(String key, String value) async {
    try {
      bool result = await _preferences!.setString(key, value);
      return result;
    } catch (erro) {
      debugPrint("Falha ao salvar string: $erro");
      return false;
    }
  }

  Future<bool> saveBool(String key, bool value) async {
    try {
      bool result = await _preferences!.setBool(key, value);
      return result;
    } catch (erro) {
      debugPrint("Falha ao salvar bool: $erro");
      return false;
    }
  }

  Future<bool> saveDouble(String key, double value) async {
    try {
      bool result = await _preferences!.setDouble(key, value);
      return result;
    } catch (erro) {
      debugPrint("Falha ao salvar double: $erro");
      return false;
    }
  }

  Future<bool> saveList(String key, List<String> value) async {
    try {
      bool result = await _preferences!.setStringList(key, value);
      return result;
    } catch (erro) {
      debugPrint("Falha ao salvar list: $erro");
      return false;
    }
  }

  int? getInt(String key) {
    try {
      return _preferences!.getInt(key);
    } catch (erro) {
      debugPrint("Impossível ler o valor do inteiro: $erro");
      return null;
    }
  }

  String? getString(String key) {
    try {
      return _preferences!.getString(key);
    } catch (erro) {
      debugPrint("Impossível ler o valor do string: $erro");
      return null;
    }
  }

  bool? getBool(String key) {
    try {
      return _preferences!.getBool(key);
    } catch (erro) {
      debugPrint("Impossível ler o valor do bool: $erro");
      return null;
    }
  }

  double? getDouble(String key) {
    try {
      return _preferences!.getDouble(key);
    } catch (erro) {
      debugPrint("Impossível ler o valor do double: $erro");
      return null;
    }
  }

  List<String>? getStringList(String key) {
    try {
      return _preferences!.getStringList(key);
    } catch (erro) {
      debugPrint("Impossível ler o valor da lista: $erro");
      return null;
    }
  }

  Future<bool> remove(String key) async {
    try {
      return await _preferences!.remove(key);
    } catch (erro) {
      debugPrint("Erro ao remover a chave $key: $erro");

      return false;
    }
  }

  Future<bool> clearAll() async {
    try {
      return await _preferences!.clear();
    } catch (erro) {
      debugPrint("Erro ao limpar o LocalStorage: $erro");
      return false;
    }
  }

  bool containsKey(String key) {
    try {
      return _preferences!.containsKey(key);
    } catch (erro) {
      debugPrint("Erro ao verificar chave: $erro");
      return false;
    }
  }

  Set<String> getKeys() {
    try {
      return _preferences!.getKeys();
    } catch (erro) {
      debugPrint("Erro ao verificar chave: $erro");
      return {};
    }
  }
}
