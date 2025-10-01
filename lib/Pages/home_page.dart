import 'package:api_consumo/Models/endereco.dart';
import 'package:api_consumo/Services/via_cep_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController cepController = TextEditingController();
  TextEditingController logradouroController = TextEditingController();
  TextEditingController complementoController = TextEditingController();
  TextEditingController bairroController = TextEditingController();
  TextEditingController cidadeController = TextEditingController();
  TextEditingController estadoController = TextEditingController();
  Endereco? endereco;

  ViaCepService viaCepService = ViaCepService();

  Future<void> buscarCep(String cep) async {
    Endereco? response = await viaCepService.buscarEndereco(cep);
    if (response == null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            icon: Icon(Icons.warning, color: Colors.red),
            title: Text('ATENÇÃO'),
            content: Text('CEP não encontrado!'),
          );
        },
      );
      return;
    }

    setState(() {
      endereco = response;
    });

    setControllersCep(endereco!);
  }

  void setControllersCep(Endereco endereco) {
    logradouroController.text = endereco.logradouro!;
    complementoController.text = endereco.complemento!;
    bairroController.text = endereco.bairro!;
    cidadeController.text = endereco.localidade!;
    estadoController.text = endereco.estado!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("App de mapa de lugares do mundo"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            spacing: 20,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: cepController,
                maxLength: 8,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      buscarCep(cepController.text);
                    },
                    icon: Icon(Icons.search),
                  ),
                  border: OutlineInputBorder(),
                  labelText: "CEP",
                ),
              ),
              TextField(
                controller: logradouroController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Logradouro",
                ),
              ),
              TextField(
                controller: complementoController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Complemento",
                ),
              ),
              TextField(
                controller: bairroController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Bairro",
                ),
              ),
              TextField(
                controller: cidadeController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Cidade",
                ),
              ),
              TextField(
                controller: estadoController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Estado",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
