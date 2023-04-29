import 'package:flutter/material.dart';
import 'package:medocup_app/models/profissional_model.dart';
import 'package:medocup_app/providers/profissional_provider.dart';
import 'package:provider/provider.dart';

class UserCard extends StatefulWidget {
  final Profissional profissional;
  const UserCard({Key? key, required this.profissional}) : super(key: key);

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  // static Map<String, Color> precoColor = <String, Color>{
  //   'up': Colors.teal,
  //   'down': Colors.indigo,
  // };

  // readNumberFormat() {
  //   final loc = context.watch<AppSettings>().locale;
  //   real = NumberFormat.currency(locale: loc['locale'], name: loc['name']);
  // }

  // abrirDetalhes() {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (_) => MoedasDetalhesPage(moeda: widget.moeda),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 12),
      elevation: 2,
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 20, left: 20),
          child: Row(
            children: [
              const Icon(Icons.person_2_rounded, size: 40),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.profissional.nome,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        widget.profissional.crm,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: ListTile(
                      title: const Text('Remover das Favoritas'),
                      onTap: () {
                        Navigator.pop(context);
                        Provider.of<ProfissionalProvider>(context,
                                listen: false)
                            .deletarProfissional(widget.profissional);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
