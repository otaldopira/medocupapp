import 'package:flutter/material.dart';

class ColaboradorForm extends StatefulWidget {
  const ColaboradorForm({super.key});

  @override
  State<ColaboradorForm> createState() => _ColaboradorFormState();
}

class _ColaboradorFormState extends State<ColaboradorForm> {
  final _formKey = GlobalKey<FormState>();

  late String nome;
  late String sobrenome;
  late String email;
  late String senha;
  late String endereco;
  late String cidade;
  late String estado;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário do Colaborador'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                //salvar colaborador aqui
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    const TabBar(
                      labelColor: Colors.black,
                      tabs: [
                        Tab(text: 'Dados Pessoais'),
                        Tab(text: 'Endereço'),
                        Tab(text: 'Autenticação'),
                      ],
                    ),
                    SizedBox(
                      height: 500,
                      child: TabBarView(
                        children: [
                          //aba de dados pessoais
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration:
                                      const InputDecoration(labelText: 'Nome'),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Por favor, insira seu nome.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) => nome = value!,
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'Sobrenome'),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Por favor, insira seu sobrenome.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) => sobrenome = value!,
                                ),
                                TextFormField(
                                  decoration:
                                      const InputDecoration(labelText: 'Email'),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Por favor, insira seu email.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) => email = value!,
                                ),
                              ],
                            ),
                          ),
                          //aba de endereço
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'Endereço'),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Por favor, insira seu endereço.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) => endereco = value!,
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'Cidade'),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Por favor, insira sua cidade.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) => cidade = value!,
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'Estado'),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Por favor, insira seu estado.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) => estado = value!,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'Endereço'),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Por favor, insira seu endereço.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) => endereco = value!,
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'Cidade'),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Por favor, insira sua cidade.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) => cidade = value!,
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                      labelText: 'Estado'),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Por favor, insira seu estado.';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) => estado = value!,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
