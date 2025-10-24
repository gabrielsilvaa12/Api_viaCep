import 'package:api_consumo/Models/usuario.dart';
import 'package:api_consumo/Pages/usuario_detalhes.dart';
import 'package:api_consumo/Services/firebase_service.dart';
import 'package:api_consumo/widgets/usuario_card.dart';
import 'package:flutter/material.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({super.key});

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final FirebaseService firebaseService = FirebaseService(
    colectionName: 'usuarios',
  );
  List<Usuario> _usuarios = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _carregarUsuarios();
  }

  Future<void> _carregarUsuarios() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final List<dynamic> data = await firebaseService.readAll();
      final List<Usuario> usuariosCarregados = data.map((item) {
        return Usuario.fromMap(
          item['id'] as String,
          item as Map<String, dynamic>,
        );
      }).toList();

      setState(() {
        _usuarios = usuariosCarregados;
        _isLoading = false;
      });
    } catch (erro) {
      setState(() {
        _errorMessage = "Erro ao carregar usuários: $erro";
        _isLoading = false;
      });
      print(_errorMessage);
    }
  }

  void _mostrarDetalhesUsuario(Usuario usuario) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      builder: (BuildContext context) {
        return UsuarioDetalhes(usuario: usuario);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Usuários'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _carregarUsuarios,
        tooltip: 'Recarregar Usuários',
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.red, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    if (_usuarios.isEmpty) {
      return const Center(child: Text('Nenhum usuário encontrado.'));
    }
    return ListView.builder(
      itemCount: _usuarios.length,
      itemBuilder: (context, index) {
        final usuario = _usuarios[index];
        return UsuarioCard(
          usuario: usuario,
          onTap: () {
            _mostrarDetalhesUsuario(usuario);
          },
        );
      },
    );
  }
}
