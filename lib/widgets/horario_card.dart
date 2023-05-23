import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:medocup_app/models/agendamento_model.dart';
import 'package:medocup_app/providers/agendamento_provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import '../pages/agendamento_page.dart';
import '../pages/detalhes/detalhes_colaborador_page.dart';
import '../pages/home_page.dart';

class CardHorario extends StatefulWidget {
  final Agendamento agendamento;
  const CardHorario({super.key, required this.agendamento});

  @override
  State<CardHorario> createState() => _CardHorarioState();
}

class _CardHorarioState extends State<CardHorario> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsetsDirectional.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            color: Colors.grey[200],
          ),
          child: ListTile(
            title: Text(widget.agendamento.colaborador.nome),
            subtitle: Text(widget.agendamento.hora),
          ),
        ),
      ),
      onTap: () {
        showModalBottomSheet(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
          context: context,
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Container(
                height: 293,
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    SizedBox(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(widget.agendamento.colaborador.nome,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                                "${widget.agendamento.data} - ${widget.agendamento.hora}")
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    )),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.note_add, color: Colors.blue),
                      title: const Text(
                        "Ficha do Paciente",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        showBarModalBottomSheet(
                          expand: true,
                          context: context,
                          builder: (context) => DetalhesColaborador(
                              colaborador: widget.agendamento.colaborador),
                        );
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.edit, color: Colors.blue),
                      title: const Text(
                        "Editar Agendamento",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        showBarModalBottomSheet(
                          context: context,
                          builder: (context) =>
                              AgendamentoPage(agendamento: widget.agendamento),
                        ).then(
                          (value) => {Navigator.pop(context)},
                        );
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading:
                          const Icon(Icons.delete_rounded, color: Colors.red),
                      title: const Text(
                        "Excluir Agendamento",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.warning,
                          animType: AnimType.topSlide,
                          headerAnimationLoop: true,
                          title: 'Você deseja excluir este agendamento?',
                          btnCancelText: 'Cancelar',
                          btnOkText: 'Confirmar',
                          btnCancelOnPress: () {},
                          btnOkOnPress: () {
                            context
                                .read<AgendamentoProvider>()
                                .deletarAgendamento(
                                    widget.agendamento.idAgendamento.toString())
                                .then((_) => AwesomeDialog(
                                      context: context,
                                      animType: AnimType.bottomSlide,
                                      autoHide:
                                          const Duration(milliseconds: 1500),
                                      headerAnimationLoop: false,
                                      dialogType: DialogType.success,
                                      title: 'Agendamento excluído',
                                    ).show().then((__) => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const HomePage()))));
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
  }
}
