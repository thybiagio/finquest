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
}