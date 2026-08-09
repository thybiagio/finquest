class Meta { 
    const Meta({
      required this.id,
      required this.titulo,
      required this.valorAlvo,
      this.valorAtual = 0.0,
    }) : assert(valorAlvo > 0, 'valorAlvo deve ser maior que zero');

    final String id;
    final String titulo;
    final double valorAlvo;
    final double valorAtual;

    double get percentualAlcancado => 
      valorAlvo <= 0 ? 0 : (valorAtual / valorAlvo).clamp(0, 1);

    bool get concluida => valorAtual >= valorAlvo;
}