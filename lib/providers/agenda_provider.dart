import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import '../databases/db_firestore.dart';

class AgendaProvider extends ChangeNotifier {
  late FirebaseFirestore db;
  DateTime _dataSelecionada = DateTime.now();

  DateTime get dataSelecionada => _dataSelecionada;

  AgendaProvider() {
    _startRepository();
  }

  _startRepository() async {
    await _startFirestore();
  }

  _startFirestore() {
    db = DBfirestore.get();
  }

  void setDataSelecionada(DateTime novaData) {
    _dataSelecionada = novaData;
    _horariosDisponiveis.clear(); // limpa a lista atual de horários disponíveis
    _gerarHorariosDisponiveis();
    notifyListeners();
  }

  List<String> _horariosDisponiveis = [];

  List<String> get horariosDisponiveis => _horariosDisponiveis;

  String horario(int index) {
    return horariosDisponiveis.elementAt(index);
  }

  void _gerarHorariosDisponiveis() async {
    // busca a agenda do médico no banco de dados
    final agendasMedico = db.collection('agendas');
    final agendaMedico = await agendasMedico
        .where('medico_id', isEqualTo: "zOwET4d0ZWcGNYQzDe0BbmkM7t12")
        .get();

    final dataSelecionada = DateFormat('yyyy-MM-dd').format(_dataSelecionada);

    final horarioInicio = DateTime.parse(
        '$dataSelecionada ${agendaMedico.docs[0]['horario_inicio']}:00');
    final horarioFim = DateTime.parse(
        '$dataSelecionada ${agendaMedico.docs[0]['horario_fim']}:00');
    final intervalo =
        Duration(minutes: int.parse(agendaMedico.docs[0]['intervalo']));

    final horariosDeAtendimento = <String>[];
    var horarioAtual = horarioInicio;

    while (horarioAtual.isBefore(horarioFim)) {
      horariosDeAtendimento.add(DateFormat('HH:mm').format(horarioAtual));
      horarioAtual = horarioAtual.add(intervalo);
    }

    _horariosDisponiveis = horariosDeAtendimento;
    debugPrint(_horariosDisponiveis.toString());
  }
}
