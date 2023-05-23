import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medocup_app/databases/db_firestore.dart';
import 'package:medocup_app/models/agendamento_model.dart';
import 'package:medocup_app/models/colaborador_model.dart';
import 'package:medocup_app/models/endereco_model.dart';
import '../services/auth_service.dart';

class AgendamentoProvider extends ChangeNotifier {
  final List<Agendamento> _agendamentos = [];
  List<Agendamento> _agendamentosColaborador = [];
  late AuthService auth;
  late FirebaseFirestore db;

  AgendamentoProvider({required this.auth}) {
    _startRepository();
  }

  _startRepository() async {
    await _startFirestore();
  }

  _startFirestore() {
    db = DBfirestore.get();
  }

  List<Agendamento> get agendamentos => _agendamentos;
  List<Agendamento> get agendamentosColaborador => _agendamentosColaborador;

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
      'idAgendamento': id,
      'colaborador': {
        'idColaborador': agendamento.colaborador.idColaborador,
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
          idAgendamento: id,
          colaborador: Colaborador(
            idColaborador: doc['colaborador']['idColaborador'],
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
    var indice = _agendamentos
        .indexWhere((a) => a.idAgendamento == agendamento.idAgendamento);

    if (indice == -1) {
      return null;
    }

    await db
        .collection('agendamentos/')
        .doc(agendamento.idAgendamento.toString())
        .update({
      'colaborador': {
        'idColaborador': agendamento.colaborador.idColaborador,
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
    }).then((value) {
      _agendamentos[indice] = agendamento;
      notifyListeners();
    });
  }

  lerAgendamentos() async {
    _agendamentos.clear();
    if (_agendamentos.isEmpty) {
      final docs = db.collection('agendamentos');
      final snapshot = await docs
          .where('profissional_id', isEqualTo: auth.usuario!.uid)
          .get();
      for (var doc in snapshot.docs) {
        var agendamento = Agendamento(
            idAgendamento: doc['idAgendamento'],
            colaborador: Colaborador(
              idColaborador: doc['colaborador']['idColaborador'],
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
    notifyListeners();
  }

  deletarAgendamento(String id) async {
    await db.collection('agendamentos').doc(id).delete();
    _agendamentos.removeWhere((agendamento) => agendamento.idAgendamento == id);
    notifyListeners();
  }

  buscarAgendamentosColaborador(Colaborador colaborador) async {
    _agendamentosColaborador = [];

    final docs = db.collection('agendamentos');
    final snapshot = await docs
        .where('colaborador.idColaborador',
            isEqualTo: colaborador.idColaborador)
        .get();

    for (var doc in snapshot.docs) {
      var agendamento = Agendamento(
        idAgendamento: doc['idAgendamento'],
        colaborador: Colaborador(
          idColaborador: doc['colaborador']['idColaborador'],
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
            rua: doc['colaborador']['endereco']['rua'],
          ),
        ),
        data: doc['data'], // Armazenar como string no formato "dd/MM/yyyy"
        hora: doc['hora'],
        idMedico: doc['profissional_id'],
      );

      _agendamentosColaborador.add(agendamento);
    }

    _agendamentosColaborador.sort((a, b) => DateFormat('dd/MM/yyyy')
        .parse(b.data)
        .compareTo(DateFormat('dd/MM/yyyy').parse(a.data))); // Ordenar por data

    notifyListeners();
  }
}
