import 'package:flutter/material.dart';
import 'package:medocup_app/pages/cadastros/agenda_medico_page.dart';
import 'package:medocup_app/pages/cadastros/cadastro_profissional.dart';
import 'package:medocup_app/providers/profissional_provider.dart';
import 'package:provider/provider.dart';

class PreferenciasPage extends StatefulWidget {
  const PreferenciasPage({Key? key}) : super(key: key);

  @override
  State<PreferenciasPage> createState() => _PreferenciasPageState();
}

class _PreferenciasPageState extends State<PreferenciasPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfissionalProvider>().buscarProfissional();
  }

  @override
  Widget build(BuildContext context) {
    final profissional = context.watch<ProfissionalProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text("Preferências")),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: ListTile.divideTiles(
                  context: context,
                  tiles: [
                    ListTile(
                      leading: const Icon(
                        Icons.schedule,
                        color: Colors.blue,
                      ),
                      title: const Text('Agenda'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ConfiguracaoAgenda()));
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.person_outline_sharp,
                        color: Colors.blue,
                      ),
                      title: const Text('Dados'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CadastroProfissionalPage(
                                      profissional: profissional.profissional,
                                      email: profissional.auth.usuario?.email,
                                    )));
                      },
                    ),
                  ],
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
