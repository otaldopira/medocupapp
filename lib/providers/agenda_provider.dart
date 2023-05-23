import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../databases/db_firestore.dart';
import '../services/auth_service.dart';

class AgendaProvider extends ChangeNotifier {
  late FirebaseFirestore db;
  late AuthService auth;
  DateTime _dataSelecionada = DateTime.now();

  DateTime get dataSelecionada => _dataSelecionada;

  AgendaProvider({required this.auth}) {
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
    final agendaMedico = await buscarAgendaMedico();

    final dataSelecionada = DateFormat('yyyy-MM-dd').format(_dataSelecionada);

    if (agendaMedico != null &&
        agendaMedico['dias'].contains(_dataSelecionada.weekday)) {
      final horarioInicio = DateTime.parse(
          '$dataSelecionada ${agendaMedico['horarioInicio']}:00');
      final horarioFim =
          DateTime.parse('$dataSelecionada ${agendaMedico['horarioFim']}:00');
      final intervalo = Duration(minutes: agendaMedico['intervalo']);

      final horariosDeAtendimento = <String>[];
      var horarioAtual = horarioInicio;

      while (horarioAtual.isBefore(horarioFim)) {
        horariosDeAtendimento.add(DateFormat('HH:mm').format(horarioAtual));
        horarioAtual = horarioAtual.add(intervalo);
      }

      _horariosDisponiveis = horariosDeAtendimento;
    } else {
      _horariosDisponiveis.clear();
    }
  }

  adicionarAgenda(List<int> dias, String horarioInicio, String horarioFim,
      int intervalo) async {
    String idMedico = auth.usuario!.uid;
    await db.collection('agendas').add({
      'dias': dias,
      'horarioInicio': horarioInicio,
      'horarioFim': horarioFim,
      'intervalo': intervalo,
      'medico_id': idMedico
    });

    notifyListeners();
  }

  buscarAgendaMedico() async {
    String idMedico = auth.usuario!.uid;
    final docs = db.collection('agendas');
    final snapshot = await docs.where("medico_id", isEqualTo: idMedico).get();
    if (snapshot.docs.isEmpty) {
      return null;
    }
    return snapshot.docs.first;
  }

  atualizarAgenda(List<int> dias, String horarioInicio, String horarioFim,
      int intervalo) async {
    String idMedico = auth.usuario!.uid;
    final agendaMedico = await buscarAgendaMedico();
    await db.collection('agendas').doc(agendaMedico.id).update({
      'dias': dias,
      'horarioInicio': horarioInicio,
      'horarioFim': horarioFim,
      'intervalo': intervalo,
      'medico_id': idMedico
    });

    notifyListeners();
  }

  verificarAgenda() async {
    String idMedico = auth.usuario!.uid;

    final snapshot = await buscarAgendaMedico();

    if (snapshot != null) {
      final agendaData = snapshot.data();
      return {
        'dias': agendaData['dias'],
        'horarioInicio': agendaData['horarioInicio'],
        'horarioFim': agendaData['horarioFim'],
        'intervalo': agendaData['intervalo'],
        'medico_id': idMedico,
      };
    }

    return null;
  }
}
