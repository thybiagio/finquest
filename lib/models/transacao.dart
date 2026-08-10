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
}