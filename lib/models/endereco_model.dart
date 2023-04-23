class Endereco{
  String cep;
  String estado;
  String cidade;
  String bairro;
  String rua;
  String? numero;

  Endereco({required this.cep, required this.estado, required this.cidade, required this.bairro, required this.rua, this.numero});
}