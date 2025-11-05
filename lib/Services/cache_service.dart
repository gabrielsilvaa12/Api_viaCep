import 'dart:convert';
import 'package:api_consumo/Models/endereco.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static const _cacheKey = 'cep_cache';

  Future<Map<String, dynamic>> _getCache() async {
    final prefs = await SharedPreferences.getInstance();
    final cache = prefs.getString(_cacheKey);
    return cache != null ? json.decode(cache) : {};
  }

  Future<void> salvarEndereco(String cep, Endereco endereco) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final mapa = await _getCache();

      mapa[cep] = endereco.toMap();
      await prefs.setString(_cacheKey, jsonEncode(mapa));

      print('[CacheService] cep $cep salvo com sucesso!');
    } catch (erro) {
      print('[CacheService] Erro ao salvar: $erro');
    }
  }

  Future<Endereco?> buscarEndereco(String cep) async {
    try {
      final mapa = await _getCache();
      if (!mapa.containsKey(cep)) {
        print('[CacheService] CEP $cep não encontrado');
        return null;
      }

      print('[CacheService] CEP $cep encontrado no cache!');
      return Endereco.fromJson(mapa[cep]);
    } catch (erro) {
      print('[CacheService] Erro ao buscar: $erro');
      return null;
    }
  }

  Future<List<String>> listarCepsConsultados() async {
    try {
      final mapa = await _getCache();
      final ceps = mapa.keys.toList();
      print('[CacheService] ${ceps.length} CEP(s) encontrados: $ceps');
      return ceps;
    } catch (e) {
      print('[CacheService] Erro ao listar CEPs: $e');
      return [];
    }
  }

  Future<void> limparCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cacheKey);
      print('[CacheService] Cache limpo com sucesso!');
    } catch (erro) {
      print('[CacheService] Erro ao limpar cache: $erro');
    }
  }
}
