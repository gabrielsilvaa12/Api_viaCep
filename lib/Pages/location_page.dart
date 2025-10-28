import 'package:api_consumo/Services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  String LocationText = "";
  final LocationService locationService = LocationService();

  @override
  void initState() {
    super.initState();
    getLocation();
  }

  Future getLocation() async {
    Position? position = await locationService.getCurrentLocation();

    if (position != null) {
      setState(() {
        LocationText =
            "latitude: ${position.latitude}, longitude: ${position.longitude}";
      });
      return;
    }

    setState(() {
      LocationText = "Não foi possível obter a localização.";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(LocationText)));
  }
}
