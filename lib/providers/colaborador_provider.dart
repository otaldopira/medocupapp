import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medocup_app/databases/db_firestore.dart';
import 'package:medocup_app/models/colaborador_model.dart';
import 'package:medocup_app/models/endereco_model.dart';

class ColaboradorProvider extends ChangeNotifier {
  final List<Colaborador> _colaboradores = [];

  List<Colaborador> get colaboradores => _colaboradores;

  late FirebaseFirestore db;

  ColaboradorProvider() {
    _startRepository();
  }

  _startRepository() async {
    await _startFirestore();
    lerColaboradores();
  }

  _startFirestore() {
    db = DBfirestore.get();
  }

  inserirColaborador(Colaborador colaborador) async {
    String id = db.collection('colaboradores/').doc().id;

    await db.collection('colaboradores/').doc(id).set({
      'id': id,
      'nome': colaborador.nome,
      'sexo': colaborador.sexo,
      'cpf': colaborador.cpf,
      'rg': colaborador.rg,
      'dataNascimento': colaborador.dataNascimento,
      'celular': colaborador.celular,
      'endereco': {
        'cep': colaborador.endereco.cep,
        'estado': colaborador.endereco.estado,
        'cidade': colaborador.endereco.cidade,
        'bairro': colaborador.endereco.bairro,
        'rua': colaborador.endereco.rua,
      }
    }).then((value) => adicionarLista(id));

    notifyListeners();
  }

  adicionarLista(String id) {
    db.collection('colaboradores/').doc(id).get().then((doc) {
      var colaborador = Colaborador(
        idColaborador: doc.id,
        nome: doc['nome'],
        sexo: doc['sexo'],
        cpf: doc['cpf'],
        rg: doc['rg'],
        dataNascimento: doc['dataNascimento'],
        celular: doc['celular'],
        endereco: Endereco(
            cep: doc['endereco']['cep'],
            estado: doc['endereco']['estado'],
            cidade: doc['endereco']['cidade'],
            bairro: doc['endereco']['bairro'],
            rua: doc['endereco']['rua']),
      );

      _colaboradores.add(colaborador);
    });
  }

  lerColaboradores() async {
    if (_colaboradores.isEmpty) {
      final snapshot = await db.collection('colaboradores/').get();
      for (var doc in snapshot.docs) {
        var colaborador = Colaborador(
          idColaborador: doc.id,
          nome: doc['nome'],
          sexo: doc['sexo'],
          cpf: doc['cpf'],
          rg: doc['rg'],
          dataNascimento: doc['dataNascimento'],
          celular: doc['celular'],
          endereco: Endereco(
              cep: doc['endereco']['cep'],
              estado: doc['endereco']['estado'],
              cidade: doc['endereco']['cidade'],
              bairro: doc['endereco']['bairro'],
              rua: doc['endereco']['rua']),
        );

        _colaboradores.add(colaborador);
      }
      notifyListeners();
    }
  }

  atualizarAgendamentos(
      Colaborador colaborador, Map<String, Object> data) async {
    final docs = db.collection('agendamentos');
    final snapshot = await docs
        .where("colaborador.idColaborador",
            isEqualTo: colaborador.idColaborador)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    for (var doc in snapshot.docs) {
      await db
          .collection('agendamentos')
          .doc(doc.id)
          .update({'colaborador': data});
    }
  }

  editarColaborador(Colaborador colaborador) async {
    var indice = _colaboradores
        .indexWhere((a) => a.idColaborador == colaborador.idColaborador);

    if (indice == -1) {
      return null;
    }

    _colaboradores[indice] = colaborador;

    Map<String, Object> data = {
      'idColaborador': colaborador.idColaborador!,
      'nome': colaborador.nome,
      'sexo': colaborador.sexo,
      'cpf': colaborador.cpf,
      'rg': colaborador.rg,
      'dataNascimento': colaborador.dataNascimento,
      'celular': colaborador.celular,
      'endereco': {
        'cep': colaborador.endereco.cep,
        'estado': colaborador.endereco.estado,
        'cidade': colaborador.endereco.cidade,
        'bairro': colaborador.endereco.bairro,
        'rua': colaborador.endereco.rua,
      },
    };

    await db
        .collection('colaboradores')
        .doc(colaborador.idColaborador)
        .update(data);
    await atualizarAgendamentos(colaborador, data);

    notifyListeners();
  }

  deletarColaborador(String id) async {
    await db.collection('colaboradores/').doc(id).delete();
    _colaboradores
        .removeAt(colaboradores.indexWhere((a) => a.idColaborador == id));
    notifyListeners();
  }
}
