import 'package:flutter/material.dart';
import 'package:medocup_app/models/agendamento_model.dart';
import 'package:medocup_app/repositories/agendamento_repository.dart';

class AgendamentoProvider extends ChangeNotifier {
  List<Agendamento> _agendamentos = AgendamentoRepository.agendamentos;
  List<Agendamento> get agendamentos => _agendamentos;

  List<Agendamento> getAgendamentosDaDataSelecionada(String dataSelecionada) {
    return _agendamentos
        .where((agendamento) => agendamento.data == dataSelecionada)
        .toList();
  }

  inserirAgendamento(Agendamento agendamento) {
    _agendamentos.add(agendamento);
    notifyListeners();
  }

  editarAgendamento(Agendamento agendamento) {
    if (agendamento == null) {
      return null;
    }

    var indice = agendamentos.indexWhere((a) => a.id == agendamento.id);

    if (indice == -1) {
      return null;
    }

    _agendamentos[indice] = agendamento;

    notifyListeners();
  }

  deletarAgendamento(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Você deseja remover este agendamento ?'),
        actions: [
          TextButton(
            onPressed: () {
              _agendamentos
                  .removeAt(agendamentos.indexWhere((a) => a.id == id));
              notifyListeners();
              Navigator.popUntil(context, ModalRoute.withName('/home'));
            },
            child: const Text('Sim'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Não'),
          ),
        ],
      ),
    );
  }
}
