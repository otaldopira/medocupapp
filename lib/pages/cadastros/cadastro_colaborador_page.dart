import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:intl/intl.dart';
import 'package:medocup_app/mixins/validations_mixin.dart';
import 'package:medocup_app/models/colaborador_model.dart';
import 'package:medocup_app/models/endereco_model.dart';
import 'package:medocup_app/providers/colaborador_provider.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CadastroColaboradorPage extends StatefulWidget {
  Colaborador? colaborador;
  CadastroColaboradorPage({Key? key, this.colaborador}) : super(key: key);

  @override
  State<CadastroColaboradorPage> createState() =>
      _CadastroColaboradorPageState();
}

class _CadastroColaboradorPageState extends State<CadastroColaboradorPage>
    with ValidacoesMixin {
  final formKey = GlobalKey<FormState>();

  bool isEditing() => widget.colaborador != null;

  final List<String> _generos = [
    'Masculino',
    'Feminino',
  ];
  final List<String> estados = [
    'AC',
    'AL',
    'AP',
    'AM',
    'BA',
    'CE',
    'DF',
    'ES',
    'GO',
    'MA',
    'MT',
    'MS',
    'MG',
    'PA',
    'PB',
    'PR',
    'PE',
    'PI',
    'RJ',
    'RN',
    'RS',
    'RO',
    'RR',
    'SC',
    'SP',
    'SE',
    'TO'
  ];

  // dados pessoais
  final _nome = TextEditingController();
  String? _generoSelecionado;
  final _cpf = TextEditingController();
  final _rg = TextEditingController();
  final _dataNascimento = TextEditingController();
  final _celular = TextEditingController();

  // dados de endereço
  final _cep = TextEditingController();
  String? _estadoSelecionado;
  final _cidade = TextEditingController();
  final _bairro = TextEditingController();
  final _rua = TextEditingController();

  cadastrarColaborador() {
    Colaborador colaborador = Colaborador(
      id: '',
      nome: _nome.text,
      sexo: _generoSelecionado.toString(),
      cpf: _cpf.text,
      rg: _rg.text,
      dataNascimento: _dataNascimento.text,
      celular: _celular.text,
      endereco: Endereco(
          cep: _cep.text,
          estado: _estadoSelecionado.toString(),
          cidade: _cidade.text,
          bairro: _bairro.text,
          rua: _rua.text),
    );
    if (formKey.currentState!.validate()) {
      context.read<ColaboradorProvider>().inserirColaborador(colaborador);
      Navigator.pop(context);
    }
    return null;
  }

  editarColaborador() {
    Colaborador colaborador = Colaborador(
      nome: _nome.text,
      sexo: _generoSelecionado.toString(),
      cpf: _cpf.text,
      rg: _rg.text,
      dataNascimento: _dataNascimento.text,
      celular: _celular.text,
      endereco: Endereco(
          cep: _cep.text,
          estado: _estadoSelecionado.toString(),
          cidade: _cidade.text,
          bairro: _bairro.text,
          rua: _rua.text),
    );
    if (formKey.currentState!.validate()) {
      context.watch<ColaboradorProvider>().editarColaborador(colaborador);
      Navigator.pop(context, colaborador);
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    if (isEditing()) {
      _nome.text = widget.colaborador!.nome;
      _generoSelecionado = widget.colaborador!.sexo;
      _cpf.text = widget.colaborador!.cpf;
      _rg.text = widget.colaborador!.rg;
      _dataNascimento.text = widget.colaborador!.dataNascimento;
      _celular.text = widget.colaborador!.celular;
      _cep.text = widget.colaborador!.endereco.cep;
      _estadoSelecionado = widget.colaborador!.endereco.estado;
      _cidade.text = widget.colaborador!.endereco.cidade;
      _bairro.text = widget.colaborador!.endereco.bairro;
      _rua.text = widget.colaborador!.endereco.rua;
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
                    'Colaborador',
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
                    decoration: const InputDecoration(labelText: 'RG'),
                    controller: _rg,
                    // ignore: unnecessary_string_escapes
                    inputFormatters: [MaskedInputFormatter('##\.###\.###\-#')],
                    onSaved: (value) {
                      _rg.text = value!;
                    },
                    validator: (value) => combine(
                      [
                        () => campoVazio(value),
                        () => rg(value),
                      ],
                    ),
                    keyboardType: TextInputType.number,
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
                    decoration: const InputDecoration(labelText: 'Celular'),
                    controller: _celular,
                    inputFormatters: [MaskedInputFormatter('(##) #####-####')],
                    onSaved: (value) {
                      _celular.text = value!;
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
                      'Endereço',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'CEP'),
                    controller: _cep,
                    // ignore: unnecessary_string_escapes
                    inputFormatters: [MaskedInputFormatter('#####\-###')],
                    onSaved: (value) {
                      _cep.text = value!;
                    },
                    validator: (value) => combine(
                      [
                        () => campoVazio(value),
                      ],
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Estado'),
                    items: estados.map((estado) {
                      return DropdownMenuItem<String>(
                        value: estado,
                        child: Text(estado),
                      );
                    }).toList(),
                    value: _estadoSelecionado,
                    validator: (value) => campoVazio(value),
                    onChanged: (value) {
                      setState(() {
                        _estadoSelecionado = value;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Cidade'),
                    controller: _cidade,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp('[a-zA-Z á-úÁ-Ú]'),
                      ),
                    ],
                    onSaved: (value) {
                      _cidade.text = value!;
                    },
                    validator: (value) => combine(
                      [
                        () => campoVazio(value),
                      ],
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Bairro'),
                    controller: _bairro,
                    onSaved: (value) {
                      _bairro.text = value!;
                    },
                    validator: (value) => combine(
                      [
                        () => campoVazio(value),
                      ],
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Rua'),
                    controller: _rua,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp('[a-zA-Z0-9À-ÿ ,./()-]'),
                      ),
                    ],
                    onSaved: (value) {
                      _rua.text = value!;
                    },
                    validator: (value) => combine(
                      [
                        () => campoVazio(value),
                      ],
                    ),
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
                              ? cadastrarColaborador()
                              : editarColaborador();
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
