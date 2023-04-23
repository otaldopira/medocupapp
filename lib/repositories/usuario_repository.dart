import 'package:medocup_app/models/usuario_model.dart';

class UsuarioRepository {
  static List<Usuario> usuarios = [
    Usuario(nome: 'João', email: 'joao@email.com', senha: '123'),
    Usuario(nome: 'Maria', email: 'maria@email.com', senha: '456'),
  ];
}
