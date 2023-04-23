import 'colaborador_model.dart';

class Agendamento {
  int id;
  Colaborador colaborador;
  String data;
  String hora;

  Agendamento({
    required this.id,
    required this.colaborador,
    required this.data,
    required this.hora,
  });
}
