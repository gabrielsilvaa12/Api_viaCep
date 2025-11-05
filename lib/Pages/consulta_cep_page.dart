import 'package:api_consumo/Models/endereco.dart';
import 'package:api_consumo/Services/connectivity_service.dart';
import 'package:api_consumo/Services/via_cep_service.dart';
import 'package:flutter/material.dart';

class ConsultaCepPage extends StatefulWidget {
  const ConsultaCepPage({super.key});

  @override
  State<ConsultaCepPage> createState() => _ConsultaCepPageState();
}

class _ConsultaCepPageState extends State<ConsultaCepPage> {
  bool _temInternet = true;
  bool _buscando = false;
  Endereco? _enderecoEncontrado;
  String? _mensagemErro;
  List<String> _historico = [];
  bool _veioDoCache = false;

  final ConnectivityService _connectivityService = ConnectivityService();
  final ViaCepService _viaCepService = ViaCepService();
  final TextEditingController _cepController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _connectivityService.initialize();
    _ouvirMudancasDeConexao();
    _verificarConexaoInicial();
    _carregarHistorico();
  }

  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
