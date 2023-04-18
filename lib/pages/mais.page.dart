import 'package:flutter/material.dart';

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
                        Navigator.pushNamed(context, '/cadastro');
                      },
                    ),
                    ListTile(
                      title: const Text('Sair'),
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/login');
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
