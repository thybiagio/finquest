import 'categoria.dart';

enum TipoTransacao { despesa, receita }

class Transacao { 
  Transacao({ 
    required this.id,
    required this.valor,
    required this.tipo,
    required this.data,
    this.categoria,
    this.descricao,
  }) : assert(valor > 0, 'valor deve ser maior que zero');

  final String id;
  final double valor;
  final TipoTransacao tipo;
  final DateTime data;
  final Categoria? categoria;
  final String? descricao;

  bool get isDespesa => tipo == TipoTransacao.despesa;
  bool get isReceita => tipo == TipoTransacao.receita;

  Map<String, dynamic> toMap() => {
        'id': id,
        'valor': valor,
        'tipo': tipo.name,
        'data': data.toIso8601String(),
        'categoriaId': categoria?.id,
        'descricao': descricao,
      };

  factory Transacao.fromMap(Map<String, dynamic> map, List<Categoria> categorias) {
    final categoriaId = map['categoriaId'] as String?;
    Categoria? categoria;
    if (categoriaId != null) {
      for (final c in categorias) {
        if (c.id == categoriaId) {
          categoria = c;
          break;
        }
      }
    }
    return Transacao(
      id: map['id'] as String,
      valor: (map['valor'] as num).toDouble(),
      tipo: TipoTransacao.values.byName(map['tipo'] as String),
      data: DateTime.parse(map['data'] as String),
      categoria: categoria,
      descricao: map['descricao'] as String?,
    );
  }
}