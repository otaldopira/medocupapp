import 'package:flutter/material.dart';
import 'package:medocup_app/pages/cadastros/cadastro_colaborador_page.dart';

class CadastroPage extends StatelessWidget {
  const CadastroPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cadastro")),
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
              const Divider(),
              // ListTile(
              //   title: const Text('Empresas'),
              //   onTap: () {},
              // ),
              // ListTile(
              //   title: const Text('Exames'),
              //   onTap: () {},
              // ),
            ],
          ).toList(),
        ),
      ),
    );
  }
}
