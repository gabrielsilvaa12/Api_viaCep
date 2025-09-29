class Endereco {
  String? cep;
  String? logradouro;
  String? complemento;
  String? bairro;
  String? localidade;
  String? uf;
  String? estado;

  Endereco({
    this.cep,
    this.logradouro,
    this.complemento,
    this.bairro,
    this.localidade,
    this.uf,
    this.estado,
  });

  factory Endereco.fromJson(Map<String, dynamic> json) {
    return Endereco(
      cep: json['cep'],
      logradouro: json['logradouro'],
      complemento: json['complemento'],
      bairro: json['bairro'],
      localidade: json['localidade'],
      uf: json['uf'],
      estado: json['estado'],
    );
  }
}
