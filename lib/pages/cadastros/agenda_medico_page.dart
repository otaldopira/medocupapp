import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/masked_input_formatter.dart';
import 'package:medocup_app/providers/agenda_provider.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

class ConfiguracaoAgenda extends StatefulWidget {
  const ConfiguracaoAgenda({super.key});

  @override
  State<ConfiguracaoAgenda> createState() => _ConfiguracaoAgendaState();
}

class _ConfiguracaoAgendaState extends State<ConfiguracaoAgenda> {
  final _formKey = GlobalKey<FormState>();
  final _horarioInicio = TextEditingController();
  final _horarioFim = TextEditingController();
  final _intervaloMinutos = TextEditingController();
  final Map<String, int> diasSemana = {
    'Segunda-feira': 1,
    'Terça-feira': 2,
    'Quarta-feira': 3,
    'Quinta-feira': 4,
    'Sexta-feira': 5,
    'Sábado': 6,
    'Domingo': 7,
  };

  List<int> diasSelecionados = [];
  late bool isEditing;

  @override
  void initState() {
    super.initState(); // Define o valor padrão para isEditing

    _loadAgendaData(); // Chama o método para carregar os dados da agenda assincronamente
  }

  void _loadAgendaData() async {
    isEditing = await context.read<AgendaProvider>().verificarAgenda() != null
        ? true
        : false;

    if (isEditing) {
      // ignore: use_build_context_synchronously
      final agendaData = await context.read<AgendaProvider>().verificarAgenda();
      if (agendaData != null) {
        setState(() {
          _horarioInicio.text = agendaData['horarioInicio'];
          _horarioFim.text = agendaData['horarioFim'];
          _intervaloMinutos.text = agendaData['intervalo'].toString();
          diasSelecionados = List<int>.from(agendaData['dias']);
        });
      }
    }
  }

  void _salvarConfiguracao() {
    if (_formKey.currentState!.validate()) {
      context.read<AgendaProvider>().atualizarAgenda(
          diasSelecionados,
          _horarioInicio.text,
          _horarioFim.text,
          int.parse(_intervaloMinutos.text));
      if (isEditing) {
      } else {
        context.read<AgendaProvider>().adicionarAgenda(
            diasSelecionados,
            _horarioInicio.text,
            _horarioFim.text,
            int.parse(_intervaloMinutos.text));
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Configuração de agenda salva com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final diasAtendimento = diasSemana.keys
        .map((dia) => MultiSelectItem(
              diasSemana[dia],
              dia,
            ))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurar Agenda'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                _salvarConfiguracao();
                // salvar dados da agenda
              }
            },
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              const SizedBox(height: 16.0),
              const Text(
                'Horário inicial:',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _horarioInicio,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  MaskedInputFormatter('##:##'),
                ],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o intervalo de atendimento.';
                  }
                  RegExp regex = RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$');
                  if (!regex.hasMatch(value)) {
                    return 'Por favor, insira um horário válido no formato HH:MM.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Horário final:',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _horarioFim,
                keyboardType: TextInputType.number,
                inputFormatters: [MaskedInputFormatter('##:##')],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o intervalo de atendimento.';
                  }
                  RegExp regex = RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$');
                  if (!regex.hasMatch(value)) {
                    return 'Por favor, insira um horário válido no formato HH:MM.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Intervalo de Atendimento (minutos):',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                controller: _intervaloMinutos,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, insira o intervalo de atendimento.';
                  }
                  final intervalo = int.tryParse(value);
                  if (intervalo == null) {
                    return 'Por favor, insira um valor válido.';
                  }
                  if (intervalo <= 0) {
                    return 'Por favor, insira um intervalo maior que zero.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              const Text(
                'Dias de atendimento:',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              MultiSelectBottomSheetField(
                initialChildSize: 0.6,
                listType: MultiSelectListType.LIST,
                searchable: false,
                buttonText: const Text("Selecione"),
                title: const Text(""),
                initialValue: diasSelecionados,
                items: diasAtendimento,
                onConfirm: (values) {
                  setState(() {
                    diasSelecionados.clear();
                    diasSelecionados.addAll(values.map((dia) => dia as int));
                    debugPrint(diasSelecionados.toString());
                  });
                },
                confirmText: const Text('Confirmar'),
                cancelText: const Text('Cancelar'),
                isDismissible: false,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor, selecione pelo menos um dia.';
                  }
                  return null;
                },
                chipDisplay: MultiSelectChipDisplay(
                  onTap: (value) {
                    setState(
                      () {
                        diasSelecionados.remove(value);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
