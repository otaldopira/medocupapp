import 'package:flutter/material.dart';
import 'package:medocup_app/models/colaborador_model.dart';

class DadosColaborador extends StatefulWidget {
  final Colaborador colaborador;
  const DadosColaborador({super.key, required this.colaborador});

  @override
  State<DadosColaborador> createState() => _DadosColaboradorState();
}

class _DadosColaboradorState extends State<DadosColaborador> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nome Completo',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            widget.colaborador.nome,
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Gênero',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            widget.colaborador.sexo,
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'CPF',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            widget.colaborador.cpf,
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'RG',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            widget.colaborador.rg,
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Data Nascimento',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            widget.colaborador.dataNascimento,
          ),
          const SizedBox(
            height: 10,
          ),
          const Text(
            'Celular',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            widget.colaborador.celular,
          ),
        ],
      ),
    );
  }
}
