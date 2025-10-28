import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapaPage extends StatefulWidget {
  const MapaPage({super.key});

  @override
  State<MapaPage> createState() => _MapaPageState();
}

class _MapaPageState extends State<MapaPage> {
  final Completer<GoogleMapController> _controller = Completer();

  static const CameraPosition _posicaoInicial = CameraPosition(
    target: LatLng(-23.55, -46.65),
    zoom: 11.5,
  );

  final Set<Marker> _marcadores = {
    Marker(
      markerId: MarkerId('senac_lapa_tito'),
      position: LatLng(-23.5229, -46.6943),
      infoWindow: InfoWindow(
        title: 'Senac Lapa Tito',
        snippet: 'Unidade do Senac na Lapa',
      ),
    ),
    Marker(
      markerId: MarkerId('parque_ibirapuera'),
      position: LatLng(-23.5885, -46.6588),
      infoWindow: InfoWindow(
        title: 'Parque Ibirapuera',
        snippet: 'O pulmão verde de São Paulo',
      ),
    ),
    Marker(
      markerId: MarkerId('estadio_morumbi'),
      position: LatLng(-23.5980, -46.7208),
      infoWindow: InfoWindow(
        title: 'Estádio do Morumbi',
        snippet: 'Casa do Maior time do País',
      ),
    ),
    Marker(
      markerId: MarkerId('escola_emygdio'),
      position: LatLng(-23.5288, -46.6949),
      infoWindow: InfoWindow(
        title: 'EE Emygdio de Barros',
        snippet: 'Escola Estadual em São Paulo',
      ),
    ),
    Marker(
      markerId: MarkerId('beco_do_batman'),
      position: LatLng(-23.5563, -46.6866),
      infoWindow: InfoWindow(
        title: 'Beco do Batman',
        snippet: 'Deveria ser em Gotham',
      ),
    ),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mapa com Marcações')),
      body: GoogleMap(
        initialCameraPosition: _posicaoInicial,
        markers: _marcadores,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
