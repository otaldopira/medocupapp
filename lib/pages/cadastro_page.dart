import 'package:flutter/material.dart';
import 'package:medocup_app/pages/cadastro_colaborador_page.dart';

class CadastroPage extends StatelessWidget {
  const CadastroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: ListView(
          children: ListTile.divideTiles(
            context: context,
            tiles: [
              ListTile(
                title: const Text('Colaboradores'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => CadastroColaboradorPage()));
                },
              ),
            ],
          ).toList(),
        ),
      ),
    );
  }
}
