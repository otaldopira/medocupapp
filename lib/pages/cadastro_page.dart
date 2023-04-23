import 'package:flutter/material.dart';

class cadastroPage extends StatelessWidget {
  const cadastroPage({Key? key}) : super(key: key);

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
                  Navigator.pushNamed(context, '/cadastro/Colaborador');
                },
              ),
            ],
          ).toList(),
        ),
      ),
    );
  }
}
