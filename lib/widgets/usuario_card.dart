import 'package:api_consumo/Models/usuario.dart';
import 'package:flutter/material.dart';

class UsuarioCard extends StatelessWidget {
  final Usuario usuario;
  final VoidCallback onTap;

  const UsuarioCard({super.key, required this.usuario, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 5),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(
            usuario.nome.isNotEmpty ? usuario.nome[0].toUpperCase() : '?',
          ),
        ),
        title: Text(
          usuario.nome.isNotEmpty ? usuario.nome : "Nome não informado",
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          usuario.email.isNotEmpty ? usuario.email : 'Email não informado',
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey,
        ),
        onTap: onTap, // Usa a função passada como parâmetro
      ),
    );
  }
}
