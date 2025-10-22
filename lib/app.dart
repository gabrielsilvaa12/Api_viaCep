import 'package:api_consumo/Pages/form_cadastro_usuario_page.dart';
// import 'package:api_consumo/Pages/home_page.dart';
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
      home: const FormCadastroUsuarioPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
