import 'package:flutter/cupertino.dart';

class AgendaProvider extends ChangeNotifier {
  DateTime _dataSelecionada = DateTime.now();

  DateTime get dataSelecionada => _dataSelecionada;

  void setDataSelecionada(DateTime novaData) {
    _dataSelecionada = novaData;
    _horariosDisponiveis.clear(); // limpa a lista atual de horários disponíveis
    _horariosDisponiveis.addAll([
      '09:00',
      '10:00',
      '11:00',
      '12:00',
      '13:00',
      '14:00',
      '15:00',
      '16:00',
      '17:00'
    ]);
    notifyListeners();
  }

  final List<String> _horariosDisponiveis = [
    '09:00',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00'
  ];

  List<String> get horariosDisponiveis => _horariosDisponiveis;

  String horario(int index) {
    return horariosDisponiveis.elementAt(index);
  }
}
