import 'colaborador_model.dart';

class Agendamento {
  String? idAgendamento;
  Colaborador colaborador;
  String data;
  String hora;
  String? idMedico;

  Agendamento({
    this.idAgendamento,
    required this.colaborador,
    required this.data,
    required this.hora,
    this.idMedico,
  });
}
