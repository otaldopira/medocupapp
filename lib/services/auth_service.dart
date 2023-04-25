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

  _authCheck() {
    debugPrint(usuario.toString());
    _auth.authStateChanges().listen((User? usuario) {
      usuario = (usuario == null) ? null : usuario;
      isLoading = false;
      notifyListeners();
    });
  }

  _getUser() {
    usuario = _auth.currentUser;
    notifyListeners();
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
