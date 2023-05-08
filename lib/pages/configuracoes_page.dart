import 'package:flutter/material.dart';
import 'package:medocup_app/pages/cadastros/cadastro_page.dart';
import 'package:medocup_app/services/auth_service.dart';
import 'package:provider/provider.dart';

class MaisPage extends StatelessWidget {
  const MaisPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        Icons.storage_rounded,
                        color: Colors.blue,
                      ),
                      title: const Text('Cadastros'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CadastroPage()));
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.settings,
                        color: Colors.blue,
                      ),
                      title: const Text('Preferências'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CadastroPage()));
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.logout_outlined,
                        color: Colors.red,
                      ),
                      title: const Text('Sair'),
                      onTap: () {
                        context.read<AuthService>().sair();
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
