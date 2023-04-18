import 'package:flutter/material.dart';
import 'package:medocup_app/models/usuario.model.dart';
import 'package:medocup_app/repositories/usuario.repository.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usuarios = UsuarioRepository.usuarios;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _senhaController = TextEditingController();
  bool isEmailValid = true;
  final _form = GlobalKey<FormState>();

  entrar() {
    if (_form.currentState!.validate()) {
      String email = _emailController.text;
      String senha = _senhaController.text;
      autenticarUsuario(email, senha);
    }
  }

  autenticarUsuario(String email, String senha) {
    for (Usuario usuario in usuarios) {
      if (usuario.email == email && usuario.senha == senha) {
        return Navigator.pushReplacementNamed(context, '/home');
      }
    }
    return ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Usuario/Senha Inválidos')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey[50],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3.6,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.elliptical(120, 80),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(12, 0, 0, 0),
                      blurRadius: 10,
                      offset: Offset(2, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: Image.asset(
                    "images/medocup.completa.logo.png",
                  ),
                ),
              ),
              Form(
                key: _form,
                child: Padding(
                  padding: const EdgeInsets.only(top: 60, left: 40, right: 40),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.email_rounded),
                          labelText: "E-mail",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(15),
                            ),
                            borderSide: BorderSide(
                                strokeAlign: BorderSide.strokeAlignCenter),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Este campo é obrigatório';
                          } else if (!RegExp(r'^.+@[^\s@]+\.[^\s@]+$')
                              .hasMatch(value)) {
                            return 'Por favor, insira um e-mail válido';
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TextFormField(
                          controller: _senhaController,
                          obscureText: true,
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Icons.lock_rounded),
                            labelText: "Senha",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                                borderSide: BorderSide(
                                    strokeAlign: BorderSide.strokeAlignCenter)),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Este campo é obrigatório';
                            }
                            return null;
                          },
                        ),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.only(top: 10, left: 25, right: 25),
                        width: 300,
                        decoration: const BoxDecoration(
                            color: Colors.blue,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: TextButton(
                            onPressed: () {
                              entrar();
                            },
                            child: const Text(
                              'Entrar',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            )),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
