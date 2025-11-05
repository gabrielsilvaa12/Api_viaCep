import 'package:api_consumo/Pages/consulta_cep_page.dart';
// import 'package:api_consumo/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const ConsultaCepPage());
}
