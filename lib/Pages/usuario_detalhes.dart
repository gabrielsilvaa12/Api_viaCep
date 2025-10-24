import 'package:api_consumo/Models/usuario.dart';
import 'package:flutter/material.dart';

class UsuarioDetalhes extends StatelessWidget {
  final Usuario usuario;

  const UsuarioDetalhes({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(thickness: 4, indent: 150, endIndent: 150),
            const SizedBox(height: 15),
            Text(
              'Detalhes do Usuário',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(height: 25),
            ..._infos.map(
              (info) =>
                  _buildDetailRow(info['icon'], info['label'], info['value']),
            ),
            const SizedBox(height: 25),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.close),
                label: const Text('Fechar'),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> get _infos => [
    {'icon': Icons.person_outline, 'label': 'Nome', 'value': usuario.nome},
    {'icon': Icons.email_outlined, 'label': 'Email', 'value': usuario.email},
    {
      'icon': Icons.phone_outlined,
      'label': 'Telefone',
      'value': usuario.telefone,
    },
    {'icon': Icons.badge_outlined, 'label': 'CPF', 'value': usuario.cpf},
  ];

  Widget _buildDetailRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[700], size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(value?.isNotEmpty == true ? value! : 'Não informado'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
