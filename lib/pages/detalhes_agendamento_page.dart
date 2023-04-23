import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medocup_app/models/agendamento_model.dart';
import 'package:medocup_app/pages/agendamento_page.dart';
import 'package:medocup_app/providers/agendamento_provider.dart';
import 'package:medocup_app/widgets/text_info_widget.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

class DetalhesAgendamentos extends StatefulWidget {
  final Agendamento agendamento;
  DetalhesAgendamentos({super.key, required this.agendamento});

  @override
  State<DetalhesAgendamentos> createState() => _DetalhesAgendamentosState();
}

class _DetalhesAgendamentosState extends State<DetalhesAgendamentos> {
  @override
  Widget build(BuildContext context) {
    final agendamentos = Provider.of<AgendamentoProvider>(context);
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
                                  builder: (context) => AgendamentoPage(
                                      agendamento: widget.agendamento),
                                ).then(
                                  (value) => {
                                    Navigator.pop(context),
                                    Navigator.pop(context)
                                  },
                                ),
                              },
                              child: const Text('Editar'),
                            ),
                            CupertinoActionSheetAction(
                              onPressed: () => {
                                agendamentos.deletarAgendamento(
                                    context, widget.agendamento.id),
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
                        widget.agendamento.colaborador.nome,
                        style: const TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
              const Text(
                'Agendamento',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 14.0),
                child: TextInfo(
                    icon: Icons.calendar_month, texto: widget.agendamento.data),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: TextInfo(
                    icon: Icons.access_time_rounded,
                    texto: widget.agendamento.hora),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
