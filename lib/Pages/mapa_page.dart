import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // Importa o flutter_map
import 'package:latlong2/latlong.dart'; // Importa o latlong2 para coordenadas

class MapaPage extends StatefulWidget {
  const MapaPage({Key? key}) : super(key: key);

  @override
  State<MapaPage> createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  // Lista de marcadores para flutter_map (será preenchida no initState)
  List<Marker> _marcadores = [];

  // Posição inicial da câmera (ajuste conforme necessário)
  final LatLng _posicaoInicial = const LatLng(
    -23.5505,
    -46.6333,
  ); // Centro de SP
  final double _zoomInicial = 11.5;

  @override
  void initState() {
    super.initState();
    _carregarMarcadores(); // Chama o método para criar os marcadores
  }

  // Função para exibir o AlertDialog com informações
  void _mostrarInfoDialog(String titulo, String snippet) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(titulo),
        content: Text(snippet),
        actions: [
          TextButton(
            child: const Text('Fechar'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  // Método para criar e carregar os marcadores fixos
  void _carregarMarcadores() {
    // Lista com as informações de cada local (mesma que você já tinha)
    final locais = [
      {
        'id': 'senac_lapa_tito',
        'nome': 'Senac Lapa Tito',
        'lat': -23.5229,
        'lng': -46.6943,
        'info': 'Unidade do Senac na Lapa.',
      },
      {
        'id': 'parque_ibirapuera',
        'nome': 'Parque Ibirapuera',
        'lat': -23.5885,
        'lng': -46.6588,
        'info': 'O pulmão verde de São Paulo.',
      },
      {
        'id': 'masp',
        'nome': 'MASP',
        'lat': -23.5618,
        'lng': -46.6560,
        'info': 'Museu de Arte de São Paulo.',
      },
      {
        'id': 'mercado_municipal',
        'nome': 'Mercado Municipal de SP',
        'lat': -23.5416,
        'lng': -46.6302,
        'info': 'Famoso pelo sanduíche de mortadela.',
      },
      {
        'id': 'beco_do_batman',
        'nome': 'Beco do Batman',
        'lat': -23.5563,
        'lng': -46.6866,
        'info': 'Galeria de grafite a céu aberto.',
      },
    ];

    List<Marker> tempMarkers = [];

    for (final local in locais) {
      tempMarkers.add(
        Marker(
          point: LatLng(local['lat'] as double, local['lng'] as double),
          width: 80.0,
          height: 80.0,
          child: GestureDetector(
            onTap: () {
              _mostrarInfoDialog(
                local['nome'] as String,
                local['info'] as String,
              );
            },
            child: Tooltip(
              message: local['nome'] as String,
              child: const Icon(
                Icons.location_pin,
                color: Colors.red, // Cor do ícone
                size: 40.0, // Tamanho do ícone
              ),
            ),
          ),
        ),
      );
    }

    setState(() {
      _marcadores = tempMarkers;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa com Marcações'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      // Usa o widget FlutterMap
      body: FlutterMap(
        options: MapOptions(
          initialCenter: _posicaoInicial, // Posição central inicial
          initialZoom: _zoomInicial, // Zoom inicial
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.api_consumo',
          ),
          MarkerLayer(markers: _marcadores),
        ],
      ),
    );
  }
}
