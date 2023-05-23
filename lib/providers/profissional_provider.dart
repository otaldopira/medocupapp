import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medocup_app/databases/db_firestore.dart';
import 'package:medocup_app/models/profissional_model.dart';
import 'package:medocup_app/services/auth_service.dart';

class ProfissionalProvider extends ChangeNotifier {
  final List<Profissional> _profissionais = [];
  late Profissional _profissional;
  late AuthService auth;
  late FirebaseFirestore db;

  List<Profissional> get profissionais => _profissionais;
  Profissional get profissional => _profissional;

  ProfissionalProvider({required this.auth}) {
    _startRepository();
  }

  _startRepository() async {
    await _startFirestore();
    await lerProfissionais();
  }

  _startFirestore() {
    db = DBfirestore.get();
  }

  inserirProfissional(Profissional profissional, email, senha) async {
    String uid = await autenticarProfissional(email, senha);

    if (uid.contains(' ')) {
      return uid;
    }

    await db.collection('profissionais/').doc(uid).set({
      'id': uid,
      'nome': profissional.nome,
      'dataNascimento': profissional.dataNascimento,
      'sexo': profissional.sexo,
      'cpf': profissional.cpf,
      'crm': profissional.crm,
    }).then((value) => adicionarLista(uid));

    notifyListeners();
  }

  autenticarProfissional(String email, String senha) async {
    try {
      String? uid = await auth.registrar(email, senha);
      return uid;
    } on AuthException catch (e) {
      return e.mensagem;
    }
  }

  adicionarLista(String id) {
    db.collection('profissionais/').doc(id).get().then((doc) {
      var profissional = Profissional(
        id: id,
        nome: doc['nome'],
        dataNascimento: doc['dataNascimento'],
        sexo: doc['sexo'],
        cpf: doc['cpf'],
        crm: doc['crm'],
      );
      _profissionais.add(profissional);
    });
  }

  lerProfissionais() async {
    if (_profissionais.isEmpty) {
      final snapshot = await db.collection('profissionais/').get();
      for (var doc in snapshot.docs) {
        var profissional = Profissional(
          id: doc.id,
          nome: doc['nome'],
          dataNascimento: doc['dataNascimento'],
          sexo: doc['sexo'],
          cpf: doc['cpf'],
          crm: doc['crm'],
        );

        _profissionais.add(profissional);
      }
      notifyListeners();
    }
  }

  editarProfissional(
      Profissional profissional, String email, String senha) async {
    try {
      await auth.alterar(email, senha);
    } on AuthException catch (e) {
      return e.mensagem;
    }

    var indice = profissionais.indexWhere((a) => a.id == profissional.id);

    if (indice == -1) {
      return null;
    }

    _profissionais[indice] = profissional;

    await db.collection('profissionais/').doc(profissional.id).update({
      'id': profissional.id,
      'nome': profissional.nome,
      'dataNascimento': profissional.dataNascimento,
      'sexo': profissional.sexo,
      'cpf': profissional.cpf,
      'crm': profissional.crm,
    });

    notifyListeners();
  }

  deletarProfissional(Profissional profissional) async {
    _profissionais.remove(profissional);
    notifyListeners();
  }

  buscarProfissional() async {
    await db
        .collection('profissionais/')
        .doc(auth.usuario!.uid)
        .get()
        .then((doc) {
      var profissional = Profissional(
        id: doc.id,
        nome: doc['nome'],
        dataNascimento: doc['dataNascimento'],
        sexo: doc['sexo'],
        cpf: doc['cpf'],
        crm: doc['crm'],
      );
      _profissional = profissional;
      notifyListeners();
    });
  }
}
