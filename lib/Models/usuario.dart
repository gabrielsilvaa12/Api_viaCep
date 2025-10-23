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
      'telefone': telefone,
      'cpf': cpf,
      'senha': senha,
    };
  }

  // Em lib/Models/usuario.dart

  factory Usuario.fromMap(String idUser, Map<String, dynamic> map) {
    return Usuario(
      id: idUser,
      nome: map['nome'] as String? ?? '',
      email: map['email'] as String? ?? '',
      telefone: map['Telefone'] as String? ?? '',
      cpf: map['cpf'] as String? ?? '',
      senha: map['senha'] as String? ?? '',
    );
  }
}
