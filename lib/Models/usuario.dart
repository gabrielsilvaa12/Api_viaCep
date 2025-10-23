class Usuario {
  final String id;
  final String nome;
  final String email;
  final String telefone;
  final String cpf;
  final String senha;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.cpf,
    required this.senha,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'email': email,
      'Telefone': telefone,
      'cpf': cpf,
      'senha': senha,
    };
  }

  factory Usuario.fromMap(String idUser, Map<String, dynamic> map) {
    return Usuario(
      id: idUser,
      nome: map['nome'],
      email: map['email'],
      telefone: map['telefone'],
      cpf: map['cpf'],
      senha: map['senha'],
    );
  }
}
