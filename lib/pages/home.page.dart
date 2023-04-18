import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medocup_app/pages/agenda.page.dart';
import 'package:medocup_app/pages/busca.page.dart';
import 'package:medocup_app/pages/mais.page.dart';
import 'package:medocup_app/providers/agenda.provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int paginaAtual = 0;
  late PageController pc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pc = PageController(initialPage: paginaAtual);
  }

  @override
  Widget build(BuildContext context) {
    final agenda = Provider.of<AgendaProvider>(context);
    return Scaffold(
      body: PageView(
        controller: pc,
        onPageChanged: (value) => setState(
          () {
            paginaAtual = value;
          },
        ),
        children: [
          AgendaPage(),
          const BuscaPage(tipoSelecao: TipoSelecao.verDetalhes),
          const MaisPage()
        ],
      ),
      floatingActionButton: paginaAtual == 0
          ? SizedBox(
              height: 70,
              width: 70,
              child: FloatingActionButton(
                onPressed: () {
                  debugPrint(agenda.dataSelecionada.toString());
                  Navigator.pushNamed(context, '/agendamento',
                      arguments: agenda.dataSelecionada);
                },
                elevation: 2,
                backgroundColor: Colors.green[700],
                child: const Text(
                  '+',
                  style: TextStyle(fontSize: 40),
                ),
              ),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Agenda'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Buscar'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Mais'),
        ],
        onTap: (val) => setState(
          () {
            pc.animateToPage(
              paginaAtual = val,
              duration: const Duration(milliseconds: 400),
              curve: Curves.ease,
            );
          },
        ),
      ),
    );
  }
}
