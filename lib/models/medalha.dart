import 'package:flutter/material.dart';

class Medalha {
  const Medalha({
    required this.nome,
    required this.descricao,
    required this.icone,
    required this.desbloqueada,
  });

  final String nome;
  final String descricao;
  final IconData icone;
  final bool desbloqueada;
}

List<Medalha> calcularMedalhas({
  required int transacoesCount,
  required int categoriasCount,
  required int metasCount,
  required int metasConcluidasCount,
  required int nivel,
}) {
  return [
    Medalha(
      nome: 'Primeiro Passo',
      descricao: 'Registre sua primeira transação',
      icone: Icons.flag,
      desbloqueada: transacoesCount >= 1,
    ),
    Medalha(
      nome: 'Metódico',
      descricao: 'Registre 10 transações',
      icone: Icons.checklist,
      desbloqueada: transacoesCount >= 10,
    ),
    Medalha(
      nome: 'Organizado',
      descricao: 'Crie sua primeira categoria',
      icone: Icons.grid_view,
      desbloqueada: categoriasCount >= 1,
    ),
    Medalha(
      nome: 'Sonhador',
      descricao: 'Crie sua primeira meta',
      icone: Icons.flag_circle,
      desbloqueada: metasCount >= 1,
    ),
    Medalha(
      nome: 'Meta Batida',
      descricao: 'Conclua uma meta',
      icone: Icons.emoji_events,
      desbloqueada: metasConcluidasCount >= 1,
    ),
    Medalha(
      nome: 'Investidor',
      descricao: 'Alcance o nível 10',
      icone: Icons.trending_up,
      desbloqueada: nivel >= 10,
    ),
    Medalha(
      nome: 'Estrategista',
      descricao: 'Alcance o nível 25',
      icone: Icons.psychology,
      desbloqueada: nivel >= 25,
    ),
    Medalha(
      nome: 'Lenda das Finanças',
      descricao: 'Alcance o nível 50',
      icone: Icons.workspace_premium,
      desbloqueada: nivel >= 50,
    ),
  ];
}