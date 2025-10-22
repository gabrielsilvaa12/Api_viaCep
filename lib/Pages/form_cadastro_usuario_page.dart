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
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        print("formulario válido");
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
