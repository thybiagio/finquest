import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/categoria.dart';
import '../models/transacao.dart';
import '../models/meta.dart';

/// Snapshot de tudo que precisa ser salvo/restaurado entre sessões do app.
class EstadoFinQuest {
  EstadoFinQuest({
    required this.categorias,
    required this.transacoes,
    required this.metas,
    required this.receitaTotal,
    required this.nomeJogador,
    required this.nivel,
    required this.xpAtual,
    this.fotoPerfilBase64,
  });

  final List<Categoria> categorias;
  final List<Transacao> transacoes;
  final List<Meta> metas;
  final double receitaTotal;
  final String nomeJogador;
  final int nivel;
  final int xpAtual;
  final String? fotoPerfilBase64;
}

/// Salva e carrega o estado do FinQuest usando SharedPreferences
/// (funciona tanto na web quanto em mobile/desktop).
class StorageService {
  static const _chave = 'finquest_estado';

  Future<void> salvar(EstadoFinQuest estado) async {
    final prefs = await SharedPreferences.getInstance();
    final mapa = {
      'categorias': estado.categorias.map((c) => c.toMap()).toList(),
      'transacoes': estado.transacoes.map((t) => t.toMap()).toList(),
      'metas': estado.metas.map((m) => m.toMap()).toList(),
      'receitaTotal': estado.receitaTotal,
      'nomeJogador': estado.nomeJogador,
      'nivel': estado.nivel,
      'xpAtual': estado.xpAtual,
      'fotoPerfilBase64': estado.fotoPerfilBase64,
    };
    await prefs.setString(_chave, jsonEncode(mapa));
  }

  Future<EstadoFinQuest?> carregar() async {
    final prefs = await SharedPreferences.getInstance();
    final texto = prefs.getString(_chave);
    if (texto == null) return null;

    final mapa = jsonDecode(texto) as Map<String, dynamic>;

    final categorias = (mapa['categorias'] as List)
        .map((c) => Categoria.fromMap(c as Map<String, dynamic>))
        .toList();

    final metas = (mapa['metas'] as List)
        .map((m) => Meta.fromMap(m as Map<String, dynamic>))
        .toList();

    final transacoes = (mapa['transacoes'] as List)
        .map((t) => Transacao.fromMap(t as Map<String, dynamic>, categorias, metas))
        .toList();

    return EstadoFinQuest(
      categorias: categorias,
      transacoes: transacoes,
      metas: metas,
      receitaTotal: (mapa['receitaTotal'] as num).toDouble(),
      nomeJogador: mapa['nomeJogador'] as String,
      nivel: mapa['nivel'] as int,
      xpAtual: mapa['xpAtual'] as int,
      fotoPerfilBase64: mapa['fotoPerfilBase64'] as String?,
    );
  }
}