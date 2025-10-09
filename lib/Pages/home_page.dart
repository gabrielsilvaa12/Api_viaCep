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
  bool isLoading = false;

  ViaCepService viaCepService = ViaCepService();

  Future<void> buscarCep(String cep) async {
    clearControllers();
    setState(() {
      isLoading = true;
    });
    try {
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
        cepController.clear();
        return;
      }

      setState(() {
        endereco = response;
      });

      setControllersCep(endereco!);
    } catch (erro) {
      throw Exception("Erro ao buscar cep: $erro");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void setControllersCep(Endereco endereco) {
    cepController.text = endereco.cep!;
    logradouroController.text = endereco.logradouro!;
    complementoController.text = endereco.complemento!;
    bairroController.text = endereco.bairro!;
    cidadeController.text = endereco.localidade!;
    estadoController.text = endereco.estado!;
  }

  void clearControllers() {
    bairroController.clear();
    logradouroController.clear();
    complementoController.clear();
    cidadeController.clear();
    estadoController.clear();
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
              Image.asset('assets/images/garden.png', height: 150),
              TextField(
                onChanged: (value) {
                  if (value.isEmpty) {
                    setState(() {
                      endereco = null;
                    });
                    clearControllers();
                  }
                },
                controller: cepController,
                maxLength: 9,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  suffixIcon: isLoading
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(),
                        )
                      : IconButton(
                          onPressed: () {
                            buscarCep(cepController.text);
                          },
                          icon: Icon(Icons.search),
                        ),
                  border: OutlineInputBorder(),
                  labelText: "CEP",
                ),
              ),
              if (endereco?.bairro != null)
                Column(
                  spacing: 20,
                  children: [
                    TextField(
                      controller: logradouroController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Logradouro",
                      ),
                    ),
                    // if (complementoController.text.isNotEmpty)
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
            ],
          ),
        ),
      ),
    );
  }
}
