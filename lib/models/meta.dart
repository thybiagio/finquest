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

    Meta copyWith({String? titulo, double? valorAlvo, double? valorAtual}) {
        return Meta(
          id: id,
          titulo: titulo ?? this.titulo,
          valorAlvo: valorAlvo ?? this.valorAlvo,
          valorAtual: valorAtual ?? this.valorAtual,
        );
    }

    Map<String, dynamic> toMap() => {
          'id': id,
          'titulo': titulo,
          'valorAlvo': valorAlvo,
          'valorAtual': valorAtual,
        };

    factory Meta.fromMap(Map<String, dynamic> map) => Meta(
          id: map['id'] as String,
          titulo: map['titulo'] as String,
          valorAlvo: (map['valorAlvo'] as num).toDouble(),
          valorAtual: (map['valorAtual'] as num).toDouble(),
        );
}