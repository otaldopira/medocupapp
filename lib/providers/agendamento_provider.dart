import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medocup_app/databases/db_firestore.dart';
import 'package:medocup_app/models/agendamento_model.dart';
import 'package:medocup_app/models/colaborador_model.dart';
import 'package:medocup_app/models/endereco_model.dart';

import '../services/auth_service.dart';

class AgendamentoProvider extends ChangeNotifier {
  final List<Agendamento> _agendamentos = [];
  late AuthService auth;
  late FirebaseFirestore db;

  AgendamentoProvider({required this.auth}) {
    _startRepository();
  }

  _startRepository() async {
    await _startFirestore();
    lerAgendamentos();
  }

  _startFirestore() {
    db = DBfirestore.get();
  }

  List<Agendamento> get agendamentos => _agendamentos;

  List<Agendamento> getAgendamentosDaDataSelecionada(String dataSelecionada) {
    return _agendamentos
        .where((agendamento) =>
            agendamento.data == dataSelecionada &&
            agendamento.idMedico == auth.usuario!.uid)
        .toList();
  }

  inserirAgendamento(Agendamento agendamento) async {
    String id = db.collection('agendamentos/').doc().id;
    await db.collection('agendamentos/').doc(id).set({
      'id': id,
      'colaborador': {
        'id': agendamento.colaborador.id,
        'nome': agendamento.colaborador.nome,
        'sexo': agendamento.colaborador.sexo,
        'cpf': agendamento.colaborador.cpf,
        'rg': agendamento.colaborador.rg,
        'dataNascimento': agendamento.colaborador.dataNascimento,
        'celular': agendamento.colaborador.celular,
        'endereco': {
          'cep': agendamento.colaborador.endereco.cep,
          'estado': agendamento.colaborador.endereco.estado,
          'cidade': agendamento.colaborador.endereco.cidade,
          'bairro': agendamento.colaborador.endereco.bairro,
          'rua': agendamento.colaborador.endereco.rua,
        },
      },
      'data': agendamento.data,
      'hora': agendamento.hora,
      'profissional_id': auth.usuario!.uid
    }).then((value) => adicionarLista(id));
    notifyListeners();
  }

  adicionarLista(String id) async {
    await db.collection('agendamentos/').doc(id).get().then((doc) {
      var agendamento = Agendamento(
          id: id,
          colaborador: Colaborador(
            id: doc['colaborador']['id'],
            nome: doc['colaborador']['nome'],
            sexo: doc['colaborador']['sexo'],
            cpf: doc['colaborador']['cpf'],
            rg: doc['colaborador']['rg'],
            dataNascimento: doc['colaborador']['dataNascimento'],
            celular: doc['colaborador']['celular'],
            endereco: Endereco(
                cep: doc['colaborador']['endereco']['cep'],
                estado: doc['colaborador']['endereco']['estado'],
                cidade: doc['colaborador']['endereco']['cidade'],
                bairro: doc['colaborador']['endereco']['bairro'],
                rua: doc['colaborador']['endereco']['rua']),
          ),
          data: doc['data'],
          hora: doc['hora'],
          idMedico: doc['profissional_id']);

      _agendamentos.add(agendamento);
    });
  }

  editarAgendamento(Agendamento agendamento) async {
    var indice = _agendamentos.indexWhere((a) => a.id == agendamento.id);

    if (indice == -1) {
      return null;
    }

    _agendamentos[indice] = agendamento;

    await db.collection('agendamentos/').doc(agendamento.id.toString()).update({
      'colaborador': {
        'id': agendamento.colaborador.id,
        'nome': agendamento.colaborador.nome,
        'sexo': agendamento.colaborador.sexo,
        'cpf': agendamento.colaborador.cpf,
        'rg': agendamento.colaborador.rg,
        'dataNascimento': agendamento.colaborador.dataNascimento,
        'celular': agendamento.colaborador.celular,
        'endereco': {
          'cep': agendamento.colaborador.endereco.cep,
          'estado': agendamento.colaborador.endereco.estado,
          'cidade': agendamento.colaborador.endereco.cidade,
          'bairro': agendamento.colaborador.endereco.bairro,
          'rua': agendamento.colaborador.endereco.rua,
        },
      },
      'data': agendamento.data,
      'hora': agendamento.hora,
    });

    notifyListeners();
  }

  lerAgendamentos() async {
    debugPrint('to aqui');
    debugPrint(_agendamentos.toString());
    if (_agendamentos.isEmpty) {
      final docs = db.collection('agendamentos');
      final snapshot = await docs
          .where('profissional_id', isEqualTo: auth.usuario!.uid)
          .get();
      for (var doc in snapshot.docs) {
        var agendamento = Agendamento(
            colaborador: Colaborador(
              id: doc['colaborador']['id'],
              nome: doc['colaborador']['nome'],
              sexo: doc['colaborador']['sexo'],
              cpf: doc['colaborador']['cpf'],
              rg: doc['colaborador']['rg'],
              dataNascimento: doc['colaborador']['dataNascimento'],
              celular: doc['colaborador']['celular'],
              endereco: Endereco(
                  cep: doc['colaborador']['endereco']['cep'],
                  estado: doc['colaborador']['endereco']['estado'],
                  cidade: doc['colaborador']['endereco']['cidade'],
                  bairro: doc['colaborador']['endereco']['bairro'],
                  rua: doc['colaborador']['endereco']['rua']),
            ),
            data: doc['data'],
            hora: doc['hora'],
            idMedico: doc['profissional_id']);
        _agendamentos.add(agendamento);
      }
      notifyListeners();
    }
  }

  limparAgendamentos() {
    _agendamentos.clear();
  }

  deletarAgendamento(String id) async {
    await db.collection('agendamentos').doc(id.toString()).delete();
    _agendamentos.removeAt(agendamentos.indexWhere((a) => a.id == id));
    notifyListeners();
  }
}
