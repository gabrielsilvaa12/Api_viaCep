import 'package:api_consumo/Pages/consulta_cep_page.dart';
import 'package:flutter/material.dart';

class ViaCepApi extends StatelessWidget {
  const ViaCepApi({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. Este é o MaterialApp que fornece a "Directionality"
    return MaterialApp(
      title: 'Consulta de CEP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFA7C957)),
      ),
      // 3. Defina a tela da atividade como a 'home'
      home: const ConsultaCepPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
