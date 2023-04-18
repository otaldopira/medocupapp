import 'package:medocup_app/models/agendamento.model.dart';
import 'package:medocup_app/models/colaborador.model.dart';
import 'package:medocup_app/models/endereco.model.dart';

class AgendamentoRepository {
  static List<Agendamento> agendamentos = [
    Agendamento(
      id: 1,
      colaborador: Colaborador(
        id: 1,
        nome: 'Raul Eger Paixão',
        sexo: 'Masculino',
        cpf: '141.116.911-53',
        rg: '24.484.305-3',
        dataNascimento: '02/06/1960',
        celular: '(67) 96921-1753',
        endereco: Endereco(
          cep: '79102-170',
          estado: 'MS',
          cidade: 'Campo Grande',
          bairro: 'Jardim Imá',
          rua: 'Rua Aquidaban',
        ),
      ),
      data: '18/04/2023',
      hora: '10:00',
    ),
    Agendamento(
      id: 2,
      colaborador: Colaborador(
        id: 2,
        nome: 'Taynara Silveira Mattos',
        sexo: 'Feminino',
        cpf: '834.216.364-43',
        rg: '23.103.606-1',
        dataNascimento: '15/11/1947',
        celular: '(84) 97478-2168',
        endereco: Endereco(
          cep: '59613-830',
          estado: 'RN',
          cidade: 'Mossoró',
          bairro: 'Monsenhor Américo',
          rua: 'Rua Francisco Xavier de Oliveira',
        ),
      ),
      data: '18/04/2023',
      hora: '14:00',
    ),
    Agendamento(
      id: 3,
      colaborador: Colaborador(
        id: 3,
        nome: 'Rosangela Laporte Quaresma',
        sexo: 'Feminino',
        cpf: '163.155.740-84',
        rg: '45.247.545-4',
        dataNascimento: '30/04/2011',
        celular: '(53) 99845-6725',
        endereco: Endereco(
          cep: '91796-718',
          estado: 'RS',
          cidade: 'Porto Alegre',
          bairro: 'Lageado',
          rua: 'Rua Quatorze',
        ),
      ),
      data: '19/04/2023',
      hora: '16:00',
    ),
  ];
}