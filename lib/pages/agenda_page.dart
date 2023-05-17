import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medocup_app/providers/agenda_provider.dart';
import 'package:medocup_app/providers/agendamento_provider.dart';
import 'package:medocup_app/widgets/horario_card.dart';
import 'package:provider/provider.dart';
import 'package:weekly_date_picker/weekly_date_picker.dart';

class AgendaPage extends StatefulWidget {
  const AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  @override
  void initState() {
    super.initState();
    Future(() => Provider.of<AgendamentoProvider>(context, listen: false)
        .lerAgendamentos());
  }

  @override
  Widget build(BuildContext context) {
    final agenda = Provider.of<AgendaProvider>(context);
    final agendamentos = Provider.of<AgendamentoProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.only(left: 8),
              height: 70,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[200]),
              child: Row(
                children: [
                  Expanded(
                    child: WeeklyDatePicker(
                      selectedDay: agenda.dataSelecionada,
                      backgroundColor: Colors.grey.shade200,
                      weekdays: const [
                        'seg',
                        'ter',
                        'qua',
                        'qui',
                        'sex',
                        'sab',
                        'dom'
                      ],
                      selectedBackgroundColor: Colors.blue,
                      enableWeeknumberText: false,
                      changeDay: (data) {
                        agenda.setDataSelecionada(data);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: InkWell(
                      child: const Icon(
                        Icons.settings_input_component_sharp,
                        color: (Colors.blue),
                        size: 20,
                      ),
                      onTap: () async {
                        DateTime? calendario = await showDatePicker(
                          context: context,
                          initialDate: agenda.dataSelecionada,
                          firstDate: DateTime(2022),
                          lastDate: DateTime(2024),
                        );
                        setState(() {
                          if (calendario == null) return;
                          agenda.setDataSelecionada(calendario);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: agendamentos.agendamentos
                      .where((agendamento) =>
                          agendamento.data ==
                          DateFormat('dd/MM/yyyy')
                              .format(agenda.dataSelecionada))
                      .isEmpty
                  ? const Center(
                      child: Text('Não há agendamentos para este dia.'))
                  : ListView(
                      children: agendamentos.agendamentos
                          .where((agendamento) =>
                              agendamento.data ==
                              DateFormat('dd/MM/yyyy')
                                  .format(agenda.dataSelecionada))
                          .map((agendamento) =>
                              CardHorario(agendamento: agendamento))
                          .toList()
                        ..sort((a, b) =>
                            a.agendamento.hora.compareTo(b.agendamento.hora)),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
