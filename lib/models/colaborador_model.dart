import 'package:medocup_app/models/endereco_model.dart';

class Colaborador {
  String? id;
  String nome;
  String sexo;
  String cpf;
  String rg;
  String dataNascimento;
  String celular;
  Endereco endereco;

  Colaborador({
    this.id,
    required this.nome,
    required this.sexo,
    required this.cpf,
    required this.rg,
    required this.dataNascimento,
    required this.celular,
    required this.endereco,
  });
}
