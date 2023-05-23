import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthException implements Exception {
  String mensagem;
  AuthException(this.mensagem);
}

class AuthService extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? usuario;
  bool isLoading = true;

  AuthService() {
    _authCheck();
  }

  _authCheck() async {
    _auth.authStateChanges().listen((User? user) {
      usuario = (user == null) ? null : user;
      isLoading = false;
      notifyListeners();
    });
  }

  _getUser() {
    usuario = _auth.currentUser;
    notifyListeners();
  }

  Future<String?> registrar(String email, String senha) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: senha);
      final user = userCredential.user;
      return user?.uid;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw AuthException('A senha é muito fraca!');
      } else if (e.code == 'email-already-in-use') {
        throw AuthException('Este email já está cadastrado');
      }
    }
    return null;
  }


  alterar(String email, String senha)async{
    try {
      await _auth.currentUser!.updateEmail(email);
      await _auth.currentUser!.updatePassword(senha);
    } catch (e) {
       throw AuthException('Não foi possível alterar as credenciais');
    }
    
  }

  entrar(String email, String senha) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: senha);
      _getUser();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw AuthException('Usuário não encontrado');
      } else if (e.code == 'wrong-password') {
        throw AuthException('Senha incorreta');
      }
    }
  }

  sair() async {
    await _auth.signOut();
    _getUser();
  }
}
