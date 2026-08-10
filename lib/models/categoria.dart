import 'package:flutter/material.dart';

class Categoria {
  const Categoria({
    required this.id,
    required this.nome,
    required this.corHex,
    required this.orcamentoMensal,
    this.gastoAtual = 0.0,
  });

  final String id;
  final String nome;
  final String corHex;
  final double orcamentoMensal;
  final double gastoAtual;

  double get percentualUsado =>
      orcamentoMensal <= 0 ? 0 : (gastoAtual / orcamentoMensal).clamp(0, 1);

  bool get estourouOrcamento => gastoAtual > orcamentoMensal;

  Color get cor {
  final hex = corHex.replaceAll('#', '');
  return Color(int.parse('FF$hex', radix: 16));
}

Categoria copyWith({double? gastoAtual}) {
  return Categoria(
    id: id,
    nome: nome,
    corHex: corHex,
    orcamentoMensal: orcamentoMensal,
    gastoAtual: gastoAtual ?? this.gastoAtual,
  );
}

}