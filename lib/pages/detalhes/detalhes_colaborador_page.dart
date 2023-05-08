import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medocup_app/models/colaborador_model.dart';
import 'package:medocup_app/pages/cadastros/cadastro_colaborador_page.dart';
import 'package:medocup_app/providers/colaborador_provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class DetalhesColaborador extends StatefulWidget {
  Colaborador colaborador;
  DetalhesColaborador({super.key, required this.colaborador});

  @override
  State<DetalhesColaborador> createState() => _DetalhesColaboradorState();
}

class _DetalhesColaboradorState extends State<DetalhesColaborador> {
  @override
  Widget build(BuildContext context) {
    final colaboradores = Provider.of<ColaboradorProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
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
                  InkWell(
                    child: const Icon(Icons.more_vert_rounded),
                    onTap: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (context) => CupertinoActionSheet(
                          actions: [
                            CupertinoActionSheetAction(
                              onPressed: () => {
                                showBarModalBottomSheet(
                                  context: context,
                                  builder: (context) => CadastroColaboradorPage(
                                      colaborador: widget.colaborador),
                                ).then(
                                  (value) {
                                    if (value != null) {
                                      setState(() {
                                        widget.colaborador = value;
                                      });
                                    }
                                    Navigator.pop(context);
                                  },
                                ),
                              },
                              child: const Text('Editar'),
                            ),
                            CupertinoActionSheetAction(
                              onPressed: () => {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text(
                                        'Você deseja remover este Colaborador ?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          colaboradores.deletarColaborador(
                                              widget.colaborador.id.toString());
                                        },
                                        child: const Text('Sim'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Não'),
                                      ),
                                    ],
                                  ),
                                )
                              },
                              isDestructiveAction: true,
                              child: const Text('Excluir'),
                            ),
                          ],
                          cancelButton: CupertinoActionSheetAction(
                            onPressed: () => {
                              Navigator.pop(context),
                            },
                            child: const Text('Cancelar'),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  const Icon(
                    Icons.people_outline_outlined,
                    size: 80,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.colaborador.nome,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                      Text(
                          'Idade: ${DateTime.now().difference(DateTime.parse(DateFormat('yyyy-MM-dd').format(DateFormat('dd/MM/yyyy').parse(widget.colaborador.dataNascimento)))).inDays ~/ 365} anos'),
                    ],
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 15),
                child: Text(
                  'Dados Pessoais',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: 500,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: Colors.grey[350]),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Nome Completo',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.colaborador.nome,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Gênero',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.colaborador.sexo,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'CPF',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.colaborador.cpf,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'RG',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.colaborador.rg,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Data Nascimento',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.colaborador.dataNascimento,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        'Celular',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.colaborador.celular,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
