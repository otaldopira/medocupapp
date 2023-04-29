class Profissional {
  String? id;
  String nome;
  String dataNascimento;
  String sexo;
  String cpf;
  String crm;
  String email;
  String senha;

  Profissional(
      {this.id,
      required this.nome,
      required this.dataNascimento,
      required this.sexo,
      required this.cpf,
      required this.crm,
      required this.email,
      required this.senha});
}
