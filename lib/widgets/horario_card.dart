import 'package:flutter/material.dart';
import 'package:medocup_app/models/agendamento_model.dart';
import 'package:medocup_app/pages/detalhes/detalhes_agendamento_page.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

// ignore: must_be_immutable
class CardHorario extends StatelessWidget {
  Agendamento agendamento;
  CardHorario({super.key, required this.agendamento});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsetsDirectional.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(15)),
            color: Colors.grey[200],
          ),
          child: ListTile(
            title: Text(agendamento.colaborador.nome),
            subtitle: Text(agendamento.hora),
          ),
        ),
      ),
      onTap: () {
        showBarModalBottomSheet(
          expand: true,
          context: context,
          builder: (context) => DetalhesAgendamentos(
            agendamento: agendamento,
          ),
        );
      },
    );
  }
}
