import 'package:flutter/material.dart';
import 'package:medocup_app/models/colaborador_model.dart';
import 'package:medocup_app/repositories/colaborador_repository.dart';

class ColaboradorProvider extends ChangeNotifier {
  List<Colaborador> _colaboradores = ColaboradorRepository.colaboradores;

  List<Colaborador> get colaboradores => _colaboradores;

  inserirColaborador(Colaborador colaborador) {
    _colaboradores.add(colaborador);
    notifyListeners();
  }

  editarColaborador(Colaborador colaborador) {
    if (colaborador == null) {
      return null;
    }

    var indice = colaboradores.indexWhere((a) => a.id == colaborador.id);

    if (indice == -1) {
      return null;
    }

    _colaboradores[indice] = colaborador;

    notifyListeners();
  }

  deletarColaborador(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Você deseja remover este Colaborador ?'),
        actions: [
          TextButton(
            onPressed: () {
              _colaboradores
                  .removeAt(colaboradores.indexWhere((a) => a.id == id));
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
