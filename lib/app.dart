import 'package:api_consumo/Pages/home_page.dart';
import 'package:flutter/material.dart';

class ViaCepApi extends StatelessWidget {
  const ViaCepApi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ACO ACO ACO ACO',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFA7C957)),
      ),
      home: const HomePage(title: 'App de mapa de lugares do mundo'),
      debugShowCheckedModeBanner: false,
    );
  }
}
