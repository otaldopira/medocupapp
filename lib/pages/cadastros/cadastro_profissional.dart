import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:intl/intl.dart';
import 'package:medocup_app/mixins/validations_mixin.dart';
import 'package:medocup_app/models/profissional_model.dart';
import 'package:medocup_app/pages/login_page.dart';
import 'package:medocup_app/providers/profissional_provider.dart';
import 'package:provider/provider.dart';

import '../../services/auth_service.dart';

class CadastroProfissionalPage extends StatefulWidget {
  final Profissional? profissional;
  final String? email;
  const CadastroProfissionalPage({Key? key, this.profissional, this.email})
      : super(key: key);

  @override
  State<CadastroProfissionalPage> createState() =>
      _CadastroProfissionalPageState();
}

class _CadastroProfissionalPageState extends State<CadastroProfissionalPage>
    with ValidacoesMixin {
  final formKey = GlobalKey<FormState>();

  bool isEditing() => widget.profissional != null;

  final List<String> _generos = [
    'Masculino',
    'Feminino',
  ];

  // dados pessoais
  final _nome = TextEditingController();
  final _dataNascimento = TextEditingController();
  String? _generoSelecionado;
  final _cpf = TextEditingController();
  final _crm = TextEditingController();
  final _email = TextEditingController();
  final _senha = TextEditingController();

  cadastrarProfissional() {
    Profissional profissional = Profissional(
      nome: _nome.text,
      dataNascimento: _dataNascimento.text,
      sexo: _generoSelecionado.toString(),
      cpf: _cpf.text,
      crm: _crm.text,
    );
    if (formKey.currentState!.validate()) {
      context
          .read<ProfissionalProvider>()
          .inserirProfissional(profissional, _email.text, _senha.text);
      Navigator.pop(context);
    }
    return null;
  }

  editarProfissional() {
    Loader.show(context, progressIndicator: const CircularProgressIndicator());
    Profissional profissional = Profissional(
      nome: _nome.text,
      dataNascimento: _dataNascimento.text,
      sexo: _generoSelecionado.toString(),
      cpf: _cpf.text,
      crm: _crm.text,
    );
    if (formKey.currentState!.validate()) {
      context
          .read<ProfissionalProvider>()
          .editarProfissional(profissional, _email.text, _senha.text)
          .then((_) {
        Loader.hide();
        AwesomeDialog(
          context: context,
          animType: AnimType.bottomSlide,
          autoHide: const Duration(milliseconds: 1500),
          headerAnimationLoop: false,
          dialogType: DialogType.success,
          title: 'Profissional alterado',
        ).show().then((__) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => const LoginPage()));
          context.read<AuthService>().sair();
        });
      });
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    if (isEditing()) {
      _nome.text = widget.profissional!.nome;
      _dataNascimento.text = widget.profissional!.dataNascimento;
      _generoSelecionado = widget.profissional!.sexo;
      _cpf.text = widget.profissional!.cpf;
      _crm.text = widget.profissional!.crm;
      _email.text = widget.email == null ? "" : widget.email as String;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: InkWell(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: const [
                          Icon(Icons.arrow_back, size: 24),
                          Text(
                            '  Voltar',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const Text(
                    'Profissional',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Nome'),
                    controller: _nome,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp('[a-z A-Z á-ú Á-Ú]'),
                      )
                    ],
                    onSaved: (value) {
                      _nome.text = value!;
                    },
                    validator: (value) => combine(
                      [
                        () => campoVazio(value),
                      ],
                    ),
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Data Nascimento'),
                    controller: _dataNascimento,
                    // ignore: unnecessary_string_escapes
                    inputFormatters: [MaskedInputFormatter('##\/##\/####')],
                    onSaved: (value) {
                      _nome.text = value!;
                    },
                    validator: (value) => combine(
                      [
                        () => campoVazio(value),
                        () => dataNascimento(DateTime.parse(
                            DateFormat('yyyy-MM-dd').format(
                                DateFormat('dd/MM/yyyy').parse(value!)))),
                      ],
                    ),
                    keyboardType: TextInputType.datetime,
                  ),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Gênero'),
                    items: _generos.map((genero) {
                      return DropdownMenuItem<String>(
                        value: genero,
                        child: Text(genero),
                      );
                    }).toList(),
                    value: _generoSelecionado,
                    validator: (value) => campoVazio(value),
                    onChanged: (value) {
                      setState(() {
                        _generoSelecionado = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'CPF'),
                    controller: _cpf,
                    inputFormatters: [
                      // ignore: unnecessary_string_escapes
                      MaskedInputFormatter('###\.###\.###\-##')
                    ],
                    onSaved: (value) {
                      _cpf.text = value!;
                    },
                    validator: (value) => combine(
                      [
                        () => campoVazio(value),
                        () => cpf(value),
                      ],
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'CRM'),
                    controller: _crm,
                    inputFormatters: [MaskedInputFormatter('######')],
                    onSaved: (value) {
                      _crm.text = value!;
                    },
                    validator: (value) => combine(
                      [
                        () => campoVazio(value),
                      ],
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: Text(
                      'Autenticação',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'E-mail'),
                    controller: _email,
                    onSaved: (value) {
                      _email.text = value!;
                    },
                    validator: (value) => combine(
                      [
                        () => campoVazio(value),
                      ],
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Senha'),
                    controller: _senha,
                    obscureText: true,
                    onSaved: (value) {
                      _senha.text = value!;
                    },
                    validator: (value) => combine(
                      [
                        () => campoVazio(value),
                      ],
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30, left: 25, right: 25),
                    width: 300,
                    decoration: const BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: TextButton(
                        onPressed: () {
                          isEditing() == false
                              ? cadastrarProfissional()
                              : editarProfissional();
                        },
                        child: isEditing() == false
                            ? const Text(
                                'Cadastrar',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              )
                            : const Text(
                                'Alterar',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              )),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
