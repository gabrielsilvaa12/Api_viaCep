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
          _doCache = !_online || (resultado.cep != valorCep);
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
        title: const Text("Não é o correios"),
        backgroundColor: Colors.yellow,
        foregroundColor: Colors.blue[800],
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              children: [
                Icon(
                  _online ? Icons.wifi : Icons.wifi_off,
                  color: _online ? Colors.blue[800] : Colors.red[400],
                ),
                const SizedBox(width: 8),
                Text(_online ? "Online" : "Offline"),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildBannerOffline(),
                const SizedBox(height: 16),

                _buildCampoCep(),
                const SizedBox(height: 24),

                if (_erro != null) _buildAreaErro(),

                if (_endereco != null) _buildCardResultado(),
                const SizedBox(height: 16),

                if (_historico.isNotEmpty) _buildSecaoHistorico(),
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).scaffoldBackgroundColor,
              child: _buildBotaoBuscar(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerOffline() {
    if (_online) return Container();
    return Container(
      width: double.infinity,
      color: Colors.orange[100],
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.only(bottom: 8.0),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, color: Colors.orange),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "Offline — só é possível consultar CEPs já salvos.",
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCampoCep() {
    return TextField(
      controller: _cepController,
      keyboardType: TextInputType.number,
      maxLength: 9,
      decoration: InputDecoration(
        labelText: "Digite o CEP (apenas números)",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: Icon(_online ? Icons.search : Icons.history),
      ),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }

  Widget _buildBotaoBuscar() {
    return ElevatedButton.icon(
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
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14.0),
      ),
    );
  }

  Widget _buildAreaErro() {
    if (_erro == null) return Container();
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.red[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[800]),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _erro!,
              style: TextStyle(
                color: Colors.red[800],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardResultado() {
    if (_endereco == null) return Container();

    return Card(
      elevation: 0,
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on_outlined, color: Colors.blue[800]),
                    const SizedBox(width: 8),
                    const Text(
                      "Endereço Encontrado",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Chip(
                  label: Text(_doCache ? "Do cache" : "Da internet"),
                  backgroundColor: _doCache
                      ? Colors.indigo[100]
                      : Colors.teal[100],
                  avatar: Icon(
                    _doCache ? Icons.storage : Icons.public,
                    size: 16,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            Text("CEP: ${_endereco!.cep ?? 'N/A'}"),
            Text("Rua: ${_endereco!.logradouro ?? 'N/A'}"),
            Text("Bairro: ${_endereco!.bairro ?? 'N/A'}"),
            Text("Cidade: ${_endereco!.localidade ?? 'N/A'}"),
            Text("UF: ${_endereco!.uf ?? 'N/A'}"),
          ],
        ),
      ),
    );
  }

  Widget _buildSecaoHistorico() {
    if (_historico.isEmpty) return Container();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Histórico de Consultas",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            OutlinedButton.icon(
              icon: const Icon(Icons.delete_sweep_outlined, size: 18),
              label: const Text("Limpar"),
              onPressed: _limparHistorico,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _historico
              .map(
                (cep) => ActionChip(
                  label: Text(cep),
                  avatar: const Icon(Icons.location_pin, size: 16),
                  backgroundColor: Colors.blue[50], // Cor nova
                  onPressed: () {
                    _cepController.text = cep;
                    _buscarCep(cep: cep);
                  },
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
