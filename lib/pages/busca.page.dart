import 'package:flutter/material.dart';
import 'package:medocup_app/models/colaborador.model.dart';
import 'package:medocup_app/pages/detalhes.agendamento.page.dart';
import 'package:medocup_app/pages/detalhes.colaborador.page.dart';
import 'package:medocup_app/repositories/colaborador.repository.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

enum TipoSelecao { selecionar, verDetalhes }

class BuscaPage extends StatefulWidget {
  final TipoSelecao tipoSelecao;
  const BuscaPage({super.key, required this.tipoSelecao});

  @override
  State<BuscaPage> createState() => _BuscaPageState();
}

class _BuscaPageState extends State<BuscaPage> {
  late final List<Colaborador> _colaboradoresFiltro = [];
  final buscaColaborador = TextEditingController();

  buscarColaborador(String pattern) {
    for (Colaborador colaborador in ColaboradorRepository.colaboradores) {
      if (!colaborador.nome.toLowerCase().contains(pattern.toLowerCase())) {
        _colaboradoresFiltro.remove(colaborador);
      }

      if (colaborador.nome.toLowerCase().contains(pattern.toLowerCase()) &&
          pattern != '' &&
          !_colaboradoresFiltro.contains(colaborador)) {
        _colaboradoresFiltro.add(colaborador);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 20),
                  child: widget.tipoSelecao == TipoSelecao.selecionar
                      ? InkWell(
                          child: const SizedBox(
                            width: 60,
                            height: 60,
                            child:
                                Icon(Icons.arrow_back_ios, color: Colors.blue),
                          ),
                          onTap: () => Navigator.pop(context),
                        )
                      : const SizedBox.shrink(),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 20, top: 10),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                        color: Colors.white),
                    child: TextField(
                      controller: buscaColaborador,
                      decoration: const InputDecoration(
                          hintText: 'Busque por nome',
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: Colors.grey,
                          ),
                          border: InputBorder.none),
                      onChanged: (pattern) {
                        setState(() {
                          buscarColaborador(buscaColaborador.text);
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 15.0, top: 10.0),
                      child: Text(
                        'Colaborador',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          final colaborador = _colaboradoresFiltro[index];
                          return ListTile(
                            title: Text(colaborador.nome),
                            subtitle: Text(colaborador.dataNascimento),
                            onTap: () {
                              if (widget.tipoSelecao ==
                                  TipoSelecao.selecionar) {
                                Navigator.pop(context, colaborador);
                              } else {
                                setState(() {
                                  buscaColaborador.text = '';
                                  _colaboradoresFiltro.clear();
                                });
                                showBarModalBottomSheet(
                                  expand: true,
                                  context: context,
                                  builder: (context) => DetalhesColaborador(
                                      colaborador: colaborador),
                                );
                              }
                            },
                          );
                        },
                        itemCount: _colaboradoresFiltro.length,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
