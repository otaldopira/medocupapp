import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:intl/intl.dart';
import 'package:medocup_app/models/colaborador_model.dart';
import 'package:medocup_app/pages/cadastros/cadastro_colaborador_page.dart';
import 'package:medocup_app/providers/agendamento_provider.dart';
import 'package:medocup_app/providers/colaborador_provider.dart';
import 'package:medocup_app/widgets/agendamentos_colaborador.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import '../../widgets/dados_colaborador.dart';

// ignore: must_be_immutable
class DetalhesColaborador extends StatefulWidget {
  Colaborador colaborador;
  DetalhesColaborador({super.key, required this.colaborador});

  @override
  State<DetalhesColaborador> createState() => _DetalhesColaboradorState();
}

class _DetalhesColaboradorState extends State<DetalhesColaborador> {
  @override
  void initState() {
    super.initState();
    context
        .read<AgendamentoProvider>()
        .buscarAgendamentosColaborador(widget.colaborador);
  }

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
                      Loader.show(context,
                          progressIndicator: const CircularProgressIndicator());
                      Provider.of<AgendamentoProvider>(context, listen: false)
                          .lerAgendamentos()
                          .then((_) {
                        Navigator.pop(context, widget.colaborador);
                        Loader.hide();
                      });
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
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.warning,
                                  animType: AnimType.topSlide,
                                  headerAnimationLoop: true,
                                  title:
                                      'Você deseja excluir este colaborador?',
                                  btnCancelText: 'Cancelar',
                                  btnOkText: 'Confirmar',
                                  btnCancelOnPress: () {},
                                  btnOkOnPress: () {
                                    colaboradores.deletarColaborador(widget
                                        .colaborador.idColaborador
                                        .toString());
                                    AwesomeDialog(
                                      context: context,
                                      animType: AnimType.bottomSlide,
                                      autoHide:
                                          const Duration(milliseconds: 1500),
                                      headerAnimationLoop: false,
                                      dialogType: DialogType.success,
                                      title: 'Colaborador excluído',
                                    ).show().then((__) {
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    });
                                  },
                                ).show()
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
              Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 24),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: ProfilePicture(
                        name: widget.colaborador.nome,
                        radius: 31,
                        fontsize: 21,
                      ),
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
              ),
              DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    const TabBar(
                      labelColor: Colors.black,
                      tabs: [
                        Tab(text: 'Dados Pessoais'),
                        Tab(text: 'Agendamentos'),
                      ],
                    ),
                    SizedBox(
                      height: 600,
                      child: TabBarView(
                        children: [
                          DadosColaborador(colaborador: widget.colaborador),
                          AgendamentosColaborador(
                              colaborador: widget.colaborador),
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
