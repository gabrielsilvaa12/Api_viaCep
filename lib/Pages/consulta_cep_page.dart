import 'package:api_consumo/Models/endereco.dart';
import 'package:api_consumo/Services/connectivity_service.dart';
import 'package:api_consumo/Services/via_cep_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConsultaCepPage extends StatefulWidget {
  const ConsultaCepPage({super.key});

  @override
  State<ConsultaCepPage> createState() => _ConsultaCepPageState();
}

class _ConsultaCepPageState extends State<ConsultaCepPage> {
  bool _online = true;
  bool _carregando = false;
  bool _doCache = false;
  String? _erro;
  Endereco? _endereco;
  List<String> _historico = [];

  final _connectivity = ConnectivityService();
  final _viaCep = ViaCepService();
  final _cepController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _connectivity.initialize();
    _checkConexao();
    _carregarHistorico();

    _connectivity.connectivityStream.listen((status) async {
      final conectado = await _connectivity.checkconnectivity();
      setState(() => _online = conectado);
    });
  }

  Future<void> _checkConexao() async {
    final conectado = await _connectivity.checkconnectivity();
    setState(() => _online = conectado);
  }

  Future<void> _carregarHistorico() async {
    final lista = await _viaCep.obterHistorico();
    setState(() => _historico = lista);
  }

  Future<void> _buscarCep({String? cep}) async {
    final valorCep = (cep ?? _cepController.text).replaceAll(RegExp(r'\D'), '');
    if (valorCep.length != 8) {
      setState(() => _erro = 'Digite um CEP válido com 8 números.');
      return;
    }

    setState(() {
      _carregando = true;
      _erro = null;
      _endereco = null;
      _doCache = false;
    });

    try {
      final resultado = await _viaCep.buscarEndereco(valorCep);
      if (resultado == null) {
        setState(() => _erro = 'CEP não encontrado.');
      } else {
        setState(() {
          _endereco = resultado;
          _doCache = !_online;
          _cepController.text = resultado.cep ?? valorCep;
        });
        _carregarHistorico();
      }
    } catch (e) {
      setState(() => _erro = e.toString().replaceAll('Exception: ', ''));
    } finally {
      setState(() => _carregando = false);
    }
  }

  Future<void> _limparHistorico() async {
    await _viaCep.limparHistorico();
    _carregarHistorico();
  }

  @override
  void dispose() {
    _cepController.dispose();
    _connectivity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Consulta de CEP"),
        actions: [
          Row(
            children: [
              Icon(
                _online ? Icons.wifi : Icons.wifi_off,
                color: _online ? Colors.green : Colors.red,
              ),
              const SizedBox(width: 6),
              Text(_online ? "Online" : "Offline"),
              const SizedBox(width: 16),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!_online)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                color: Colors.orange[100],
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Offline — só é possível consultar CEPs já salvos.",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            TextField(
              controller: _cepController,
              keyboardType: TextInputType.number,
              maxLength: 8,
              decoration: InputDecoration(
                labelText: "Digite o CEP",
                border: const OutlineInputBorder(),
                suffixIcon: Icon(_online ? Icons.search : Icons.history),
              ),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _carregando ? null : () => _buscarCep(),
              icon: _carregando
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.search),
              label: Text(_carregando ? "Buscando..." : "Buscar CEP"),
            ),
            const SizedBox(height: 16),
            if (_erro != null)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                color: Colors.red[100],
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red[800]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _erro!,
                        style: TextStyle(color: Colors.red[800]),
                      ),
                    ),
                  ],
                ),
              ),
            if (_endereco != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Endereço Encontrado",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Chip(
                            label: Text(_doCache ? "Do cache" : "Da internet"),
                            backgroundColor: _doCache
                                ? Colors.blue[100]
                                : Colors.green[100],
                            avatar: Icon(
                              _doCache ? Icons.storage : Icons.public,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      Text("CEP: ${_endereco!.cep ?? 'N/A'}"),
                      Text("Rua: ${_endereco!.logradouro ?? 'N/A'}"),
                      Text("Bairro: ${_endereco!.bairro ?? 'N/A'}"),
                      Text("Cidade: ${_endereco!.localidade ?? 'N/A'}"),
                      Text("UF: ${_endereco!.uf ?? 'N/A'}"),
                    ],
                  ),
                ),
              ),
            if (_historico.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Histórico de Consultas",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: _limparHistorico,
                        child: const Text(
                          "Limpar",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                  Wrap(
                    spacing: 8,
                    children: _historico
                        .map(
                          (cep) => ActionChip(
                            label: Text(cep),
                            avatar: const Icon(Icons.history, size: 16),
                            onPressed: () {
                              _cepController.text = cep;
                              _buscarCep(cep: cep);
                            },
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
