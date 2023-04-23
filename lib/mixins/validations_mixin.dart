import 'package:flutter/material.dart';

mixin ValidacoesMixin {
  String? campoVazio(String? valor, [String? mensagem]) {
    if (valor == null || valor.isEmpty) {
      return mensagem ?? "Este campo é obrigatório";
    }

    return null;
  }

  String? numeroCelular(String? valor, [String? mensagem]) {
    var celular =
        RegExp(r'^\(?[1-9]{2}\)? ?(?:[2-8]|9[1-9])[0-9]{3}\-?[0-9]{4}$');
    if (!celular.hasMatch(valor!)) return "Digite um número de celular válido";
    return null;
  }

  String? dataPassada(DateTime? valor, [String? mensagem]) {
    if (valor!.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      return mensagem ?? "Não é permitido fazer agendamento com datas passadas";
    }

    return null;
  }

  String? dataNascimento(DateTime? valor, [String? mensagem]) {
    DateTime dataAtual = DateTime.now();

    if (dataAtual.isBefore(valor!)) {
      return mensagem ?? 'Data passada é maior que data atual !';
    }

    return null;
  }

  String? cpf(String? valor, [String? mensagem]) {
// TIRA A MÁSCARA DO CPF
    String? cpfNoMask = valor!.replaceAll(RegExp(r'\D'), '');

    if (cpfNoMask.length != 11) {
      return mensagem ?? 'CPF deve conter 11 dígitos';
    }

    int d1 = 0;
    int d2 = 0;

// VALIDANDO OS DÍGITOS VERIFICADORES DO CPF
    if (RegExp(r'(\d)\1{10}').hasMatch(cpfNoMask)) {
      return mensagem ?? 'CPF inválido';
    }

    for (int i = 0, x = 10; i < 9; i++, x--) {
      d1 += int.parse(cpfNoMask[i]) * x;
    }

    for (int i = 0, x = 11; i < 10; i++, x--) {
      d2 += int.parse(cpfNoMask[i]) * x;
    }

    int tempD1 = ((d1 % 11) < 2) ? 0 : (11 - (d1 % 11));
    int tempD2 = ((d2 % 11) < 2) ? 0 : (11 - (d2 % 11));

    if (tempD1 == int.parse(cpfNoMask[9]) &&
        tempD2 == int.parse(cpfNoMask[10])) {
      return null;
    }

    return mensagem ?? 'CPF inválido';
  }

  String? rg(String? rg, [String? mensagem]) {
    // TIRA A FORMATAÇÃO DO RG
    // Remover caracteres especiais e espaços em branco do RG
    rg = rg!.replaceAll(RegExp('[^0-9]'), '');

    // Verificar se o RG possui 8 ou 9 dígitos
    if (rg.length != 9) {
      return mensagem ?? 'Rg deve possuir 9 caracteres';
    }

    // Calcular o dígito verificador
    var digitos = rg.split('');
    var peso = [2, 3, 4, 5, 6, 7, 8, 9, 10];
    var soma = 0;
    for (var i = 0; i < rg.length - 1; i++) {
      soma += int.parse(digitos[i]) * peso[i];
    }
    var digito = 11 - (soma % 11);
    if (digito == 10 || digito == 11) {
      digito = 0;
    }

    // Verificar se o dígito verificador é válido
    if (digito == int.parse(digitos.last)) {
      return null;
    }

    return mensagem ?? 'Rg Inválido';
  }

  String? combine(List<String? Function()> validacao) {
    for (final func in validacao) {
      final validation = func();
      if (validation != null) return validation;
    }
    return null;
  }
}
