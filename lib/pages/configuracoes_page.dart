import 'package:flutter/material.dart';
import 'package:medocup_app/pages/cadastro_page.dart';
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
                      title: const Text('Cadastros'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CadastroPage()));
                      },
                    ),
                    ListTile(
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
