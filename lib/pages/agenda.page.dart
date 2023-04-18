import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:intl/intl.dart';
import 'package:medocup_app/models/agendamento.model.dart';
import 'package:medocup_app/providers/agenda.provider.dart';
import 'package:medocup_app/providers/agendamento.provider.dart';
import 'package:medocup_app/widgets/card.horario.widget.dart';
import 'package:provider/provider.dart';

class AgendaPage extends StatefulWidget {
  AgendaPage({super.key});

  @override
  State<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends State<AgendaPage> {
  DatePickerController _controller = DatePickerController();

  @override
  void initState() {
    super.initState();

    //apos criar o componente executa o callback
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.jumpToSelection();
    });
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
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.grey[200]),
              child: Row(
                children: [
                  Expanded(
                    child: DatePicker(
                      DateTime.utc(2023, 02, 01),
                      locale: 'pt_BR',
                      width: 60,
                      height: 85,
                      initialSelectedDate: DateTime.now(),
                      selectionColor: Colors.blue,
                      selectedTextColor: Colors.white,
                      controller: _controller,
                      onDateChange: (data) {
                        setState(() {
                          agenda.setDataSelecionada(data);
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: 60,
                    child: InkWell(
                      child: const Icon(
                        Icons.settings_input_component_sharp,
                        color: (Colors.blue),
                        size: 32,
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
                          _controller.animateToDate(agenda.dataSelecionada);
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
