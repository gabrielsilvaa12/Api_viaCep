import 'package:api_consumo/app.dart'; // 1. Importe o app.dart
import 'package:api_consumo/Services/shared_preferences_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPreferencesService.init(); // 2. Esta linha está correta!

  runApp(const ViaCepApi()); // 3. Chame o ViaCepApi aqui
}
