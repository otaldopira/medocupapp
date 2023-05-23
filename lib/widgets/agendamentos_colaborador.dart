import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:medocup_app/models/colaborador_model.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import '../pages/agendamento_page.dart';
import '../providers/agendamento_provider.dart';

class AgendamentosColaborador extends StatefulWidget {
  final Colaborador colaborador;
  const AgendamentosColaborador({super.key, required this.colaborador});

  @override
  State<AgendamentosColaborador> createState() =>
      _AgendamentosColaboradorState();
}

class _AgendamentosColaboradorState extends State<AgendamentosColaborador> {
  @override
  Widget build(BuildContext context) {
    final agendamentos = context.watch<AgendamentoProvider>();
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          SizedBox(
            width: 500,
            height: 576,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return InkWell(
                  child: Card(
                    margin: const EdgeInsets.only(top: 12),
                    elevation: 2,
                    child: ListTile(
                      title: Row(
                        children: [
                          const Icon(Icons.calendar_today),
                          const SizedBox(width: 8),
                          Text(agendamentos.agendamentosColaborador[index].data,
                              style: TextStyle(color: Colors.grey[600])),
                          const SizedBox(width: 8),
                          const Icon(Icons.access_time),
                          const SizedBox(width: 8),
                          Text(agendamentos.agendamentosColaborador[index].hora,
                              style: TextStyle(color: Colors.grey[600])),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20))),
                      context: context,
                      builder: (context) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Container(
                            height: 200,
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Column(
                              children: [
                                SizedBox(
                                    child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            agendamentos
                                                .agendamentosColaborador[index]
                                                .colaborador
                                                .nome,
                                            style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            "${agendamentos.agendamentosColaborador[index].data} - ${agendamentos.agendamentosColaborador[index].hora}")
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                )),
                                ListTile(
                                  leading: const Icon(Icons.edit,
                                      color: Colors.blue),
                                  title: const Text(
                                    "Editar",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {
                                    showBarModalBottomSheet(
                                      context: context,
                                      builder: (context) => AgendamentoPage(
                                          agendamento: agendamentos
                                              .agendamentosColaborador[index]),
                                    ).then(
                                      (_) {
                                        context
                                            .read<AgendamentoProvider>()
                                            .buscarAgendamentosColaborador(
                                                widget.colaborador);
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.delete_rounded,
                                      color: Colors.red),
                                  title: const Text(
                                    "Excluir",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  onTap: () {
                                    AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.warning,
                                      animType: AnimType.topSlide,
                                      headerAnimationLoop: true,
                                      title:
                                          'Você deseja excluir este agendamento?',
                                      btnCancelText: 'Cancelar',
                                      btnOkText: 'Confirmar',
                                      btnCancelOnPress: () {},
                                      btnOkOnPress: () {
                                        context
                                            .read<AgendamentoProvider>()
                                            .deletarAgendamento(agendamentos
                                                .agendamentosColaborador[index]
                                                .idAgendamento
                                                .toString())
                                            .then((_) => AwesomeDialog(
                                                  context: context,
                                                  animType:
                                                      AnimType.bottomSlide,
                                                  autoHide: const Duration(
                                                      milliseconds: 1500),
                                                  headerAnimationLoop: false,
                                                  dialogType:
                                                      DialogType.success,
                                                  title: 'Agendamento excluído',
                                                ).show().then((__) =>
                                                    Navigator.pop(context)));
                                      },
                                    ).show();
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              itemCount: agendamentos.agendamentosColaborador.length,
            ),
          )
        ],
      ),
    );
  }
}
