import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:intl/intl.dart';
import 'package:medocup_app/mixins/validations_mixin.dart';
import 'package:medocup_app/models/agendamento_model.dart';
import 'package:medocup_app/models/colaborador_model.dart';
import 'package:medocup_app/pages/busca_page.dart';
import 'package:medocup_app/pages/home_page.dart';
import 'package:medocup_app/providers/agenda_provider.dart';
import 'package:medocup_app/providers/agendamento_provider.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

class AgendamentoPage extends StatefulWidget {
  final Agendamento? agendamento;

  const AgendamentoPage({super.key, this.agendamento});

  @override
  State<AgendamentoPage> createState() => _AgendamentoPageState();
}

class _AgendamentoPageState extends State<AgendamentoPage>
    with ValidacoesMixin {
  late Colaborador? _colaboradorSelecionado;
  final TextEditingController _controllerColaborador = TextEditingController();
  final TextEditingController _controllerCelular = TextEditingController();
  final TextEditingController _controllerData = TextEditingController();
  final TextEditingController _controllerHora = TextEditingController();

  bool isEditing() => widget.agendamento != null;

  List<String> getHorariosDisponiveis(
      List<String> horariosDisponiveis, List<Agendamento> agendamentos) {
    List<String> horariosLivres = horariosDisponiveis;
    for (Agendamento agendamento in agendamentos) {
      if (horariosDisponiveis.contains(agendamento.hora)) {
        horariosLivres.remove(agendamento.hora);
      }
    }
    return horariosLivres;
  }

  inserirAgendamento() {
    Loader.show(context, progressIndicator: const CircularProgressIndicator());
    Agendamento novoAgendamento = Agendamento(
      colaborador: _colaboradorSelecionado!,
      data: _controllerData.text,
      hora: _controllerHora.text,
    );

    context
        .read<AgendamentoProvider>()
        .inserirAgendamento(novoAgendamento)
        .then((_) {
      Loader.hide();
      AwesomeDialog(
        context: context,
        animType: AnimType.bottomSlide,
        autoHide: const Duration(milliseconds: 1500),
        headerAnimationLoop: false,
        dialogType: DialogType.success,
        title: 'Agendamento inserido',
      ).show().then((__) => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomePage())));
    });
  }

  editarAgendamento() {
    Loader.show(context, progressIndicator: const CircularProgressIndicator());
    Agendamento novoAgendamento = Agendamento(
      idAgendamento: widget.agendamento!.idAgendamento,
      colaborador: _colaboradorSelecionado!,
      data: _controllerData.text,
      hora: _controllerHora.text,
    );

    context
        .read<AgendamentoProvider>()
        .editarAgendamento(novoAgendamento)
        .then((_) {
      Loader.hide();
      AwesomeDialog(
        context: context,
        animType: AnimType.bottomSlide,
        autoHide: const Duration(milliseconds: 1500),
        headerAnimationLoop: false,
        dialogType: DialogType.success,
        title: 'Agendamento editado',
      ).show().then((__) => Navigator.pop(context));
    });
  }

  @override
  void initState() {
    super.initState();
    if (isEditing()) {
      String dataString = widget.agendamento!.data;
      DateFormat formato = DateFormat("dd/MM/yyyy");
      DateTime dataAtual = formato.parse(dataString);

      Future(() {
        Loader.show(context,
            progressIndicator: const CircularProgressIndicator());
        context.read<AgendaProvider>().setDataSelecionada(dataAtual);
        _colaboradorSelecionado = widget.agendamento!.colaborador;
        _controllerColaborador.text = widget.agendamento!.colaborador.nome;
        _controllerCelular.text = widget.agendamento!.colaborador.celular;
        _controllerData.text = widget.agendamento!.data;
        _controllerHora.text = widget.agendamento!.hora;
      }).then((_) => Loader.hide());
    }
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final agenda = context.watch<AgendaProvider>();
    final agendamentos = context.watch<AgendamentoProvider>();
    _controllerData.text =
        DateFormat('dd/MM/yyyy').format(agenda.dataSelecionada);
    late List<String>? horariosDisponiveis;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agendamento'),
        leading: InkWell(
          child: const Icon(Icons.arrow_back_ios),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 20, left: 40, right: 30),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        controller: _controllerData,
                        validator: (value) => combine(
                          [
                            () => campoVazio(value),
                            () => dataPassada(agenda.dataSelecionada),
                          ],
                        ),
                        autofocus: false,
                        decoration: InputDecoration(
                          label: Row(
                            children: const [
                              Icon(Icons.date_range, color: Colors.grey),
                              SizedBox(width: 8),
                              Text('Data'),
                            ],
                          ),
                        ),
                        onTap: () async {
                          DateTime? escolherData = await showDatePicker(
                            context: context,
                            initialDate: agenda.dataSelecionada,
                            firstDate: agenda.dataSelecionada,
                            lastDate: DateTime(2024),
                          );

                          if (escolherData != null) {
                            agenda.setDataSelecionada(escolherData);
                            setState(() {
                              _controllerHora.text = '';
                              _controllerData.text =
                                  DateFormat('dd/MM/yyyy').format(escolherData);
                            });
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      width: 150,
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        controller: _controllerHora,
                        validator: (value) => campoVazio(value),
                        decoration: InputDecoration(
                          label: Row(
                            children: const [
                              Icon(Icons.access_time_outlined,
                                  color: Colors.grey),
                              SizedBox(width: 8),
                              Text('Hora'),
                            ],
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            horariosDisponiveis = getHorariosDisponiveis(
                                agenda.horariosDisponiveis,
                                agendamentos.agendamentos
                                    .where((dia) => dia.data.contains(
                                        DateFormat('dd/MM/yyyy')
                                            .format(agenda.dataSelecionada)
                                            .toString()))
                                    .toList());
                          });
                          showModalBottomSheet(
                            shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20))),
                            context: context,
                            builder: (BuildContext context) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: SizedBox(
                                  height: 200,
                                  child: horariosDisponiveis!.isNotEmpty
                                      ? ListView.separated(
                                          separatorBuilder: (context, index) =>
                                              const Divider(),
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              title: Text(
                                                  horariosDisponiveis![index]),
                                              onTap: () {
                                                setState(() {
                                                  _controllerHora.text =
                                                      agenda.horario(index);
                                                });
                                                Navigator.pop(context);
                                              },
                                            );
                                          },
                                          itemCount:
                                              horariosDisponiveis!.length,
                                        )
                                      : const Center(
                                          child: ListTile(
                                            title: Text(
                                                'Sem horários disponíveis',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ),
                                ),
                              );
                            },
                          );
                        },
                        keyboardType: TextInputType.none,
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _controllerColaborador,
                  validator: (value) =>
                      campoVazio(value, 'Escolha um colaborador'),
                  autofocus: false,
                  decoration: InputDecoration(
                    label: Row(
                      children: const [
                        Icon(Icons.person, color: Colors.grey),
                        SizedBox(width: 8),
                        Text('Colaborador'),
                      ],
                    ),
                    suffixIcon: const Icon(Icons.search_rounded),
                  ),
                  keyboardType: TextInputType.none,
                  onTap: () {
                    // Abre um modal de busca de colaborador
                    Future<Colaborador?> future =
                        showBarModalBottomSheet<Colaborador>(
                      expand: true,
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) =>
                          const BuscaPage(tipoSelecao: TipoSelecao.selecionar),
                    );
                    // Quando um colaborador for selecionado, atualiza o estado
                    future.then((value) {
                      if (value != null) {
                        setState(() {
                          _colaboradorSelecionado = value;
                          _controllerColaborador.text =
                              _colaboradorSelecionado?.nome ?? '';
                          _controllerCelular.text =
                              _colaboradorSelecionado?.celular ?? '';
                        });
                      }
                    });
                  },
                ),
                TextFormField(
                  controller: _controllerCelular,
                  validator: (value) => combine(
                    [
                      () => campoVazio(value),
                      () => numeroCelular(value),
                    ],
                  ),
                  autofocus: false,
                  inputFormatters: [MaskedInputFormatter('(##) #####-####')],
                  decoration: InputDecoration(
                    label: Row(
                      children: const [
                        Icon(Icons.phone_android_outlined, color: Colors.grey),
                        SizedBox(width: 8),
                        Text('Celular'),
                      ],
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 60, left: 25, right: 25),
                  width: 300,
                  decoration: const BoxDecoration(
                    color: Colors.lightBlue,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        isEditing() == false
                            ? inserirAgendamento()
                            : editarAgendamento();
                      }
                    },
                    child: isEditing() == false
                        ? const Text('Inserir',
                            style: TextStyle(color: Colors.white, fontSize: 18))
                        : const Text(
                            'Alterar',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
