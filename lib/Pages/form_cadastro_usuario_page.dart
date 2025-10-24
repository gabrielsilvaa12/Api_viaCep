import 'package:api_consumo/Models/usuario.dart';
import 'package:api_consumo/Pages/usuarios_page.dart';
import 'package:api_consumo/Services/firebase_service.dart';
import 'package:flutter/material.dart';

class FormCadastroUsuarioPage extends StatefulWidget {
  const FormCadastroUsuarioPage({super.key});

  @override
  State<FormCadastroUsuarioPage> createState() =>
      _FormCadastroUsuarioPageState();
}

class _FormCadastroUsuarioPageState extends State<FormCadastroUsuarioPage> {
  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController telefoneController = TextEditingController();
  TextEditingController cpfController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController confirmarSenhaController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final FirebaseService firebaseService = FirebaseService(
    colectionName: 'usuarios',
  );

  Future<void> salvarUsuario() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    Usuario usuario = Usuario(
      id: "",
      nome: nomeController.text,
      email: emailController.text,
      telefone: telefoneController.text,
      cpf: cpfController.text,
      senha: senhaController.text,
    );

    try {
      String idUser = await firebaseService.create(usuario.toMap());

      if (idUser.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Column(
              children: [
                Text(
                  "sucesso: $idUser",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Usuário cadastrado com sucesso!",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        );
      }
    } catch (erro) {}
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(
            children: [
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 20,
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, insira seu nome';
                        }
                        return null;
                      },
                      controller: nomeController,
                      decoration: InputDecoration(
                        labelText: "Nome",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        final RegExp emailRegex = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                        );
                        if (!emailRegex.hasMatch(value!)) {
                          return "Email inválido";
                        }

                        return null;
                      },
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, insira seu telefone';
                        }
                        return null;
                      },
                      controller: telefoneController,
                      decoration: InputDecoration(
                        labelText: "Telefone",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, insira seu cpf';
                        }
                        return null;
                      },
                      controller: cpfController,
                      decoration: InputDecoration(
                        labelText: "Cpf",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor, insira sua senha';
                        }
                        return null;
                      },
                      controller: senhaController,
                      decoration: InputDecoration(
                        labelText: "Senha",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'A confirmação de senha é obrigatória';
                        }
                        if (value != senhaController.text) {
                          return 'a confirmação de senha não corresponde à senha';
                        }
                        return null;
                      },
                      controller: confirmarSenhaController,
                      decoration: InputDecoration(
                        labelText: "Confirmar senha",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        salvarUsuario();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UsuariosPage(),
                          ),
                        );
                      },
                      child: Text('Cadastrar'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
