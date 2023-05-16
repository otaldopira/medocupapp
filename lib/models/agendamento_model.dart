import 'colaborador_model.dart';

class Agendamento {
  String? id;
  Colaborador colaborador;
  String data;
  String hora;
  String? idMedico;

  Agendamento({
    this.id,
    required this.colaborador,
    required this.data,
    required this.hora,
    this.idMedico,
  });
}
