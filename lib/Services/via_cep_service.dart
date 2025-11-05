import 'dart:convert';
import 'package:api_consumo/Models/endereco.dart';
import 'package:api_consumo/Services/cache_service.dart';
import 'package:api_consumo/Services/connectivity_service.dart';
import 'package:http/http.dart' as http;

class ViaCepService {
  final _connectivityService = ConnectivityService();
  final _cacheService = CacheService();

  Future<Endereco?> buscarEndereco(String cep) async {
    cep = cep.replaceAll(RegExp(r'\D'), '');
    if (cep.length != 8) {
      throw Exception('CEP inválido (precisa ter 8 dígitos).');
    }
    final conectado = await _connectivityService.checkconnectivity();

    if (conectado) {
      print('[ViaCepService] Online — buscando na API...');

      try {
        final response = await http.get(
          Uri.parse('https://viacep.com.br/ws/$cep/json/'),
        );

        if (response.statusCode != 200) {
          throw Exception('Erro na API: código ${response.statusCode}');
        }

        final data = jsonDecode(response.body);

        if (data['erro'] == true) {
          print('[ViaCepService] CEP $cep não encontrado na API.');
          return null;
        }

        final endereco = Endereco.fromJson(data);
        await _cacheService.salvarEndereco(cep, endereco);

        print('[ViaCepService] Endereço salvo no cache.');
        return endereco;
      } catch (erro) {
        print(
          '[ViaCepService] Falha ao acessar API ($erro). Tentando cache...',
        );
        return await _buscarNoCache(cep);
      }
    }

    print('[ViaCepService] Sem internet — buscando no cache...');
    return await _buscarNoCache(cep);
  }

  Future<Endereco?> _buscarNoCache(String cep) async {
    final endereco = await _cacheService.buscarEndereco(cep);

    if (endereco != null) {
      print('[ViaCepService] Endereço encontrado no cache.');
      return endereco;
    }

    throw Exception('Sem conexão e CEP não encontrado no cache.');
  }

  Future<List<String>> obterHistorico() =>
      _cacheService.listarCepsConsultados();

  Future<void> limparHistorico() => _cacheService.limparCache();
}
