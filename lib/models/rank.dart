import 'package:flutter/material.dart';

class RankInfo {
  const RankInfo({
    required this.nome,
    required this.corPrimaria,
    required this.corSecundaria,
  });

  final String nome;
  final Color corPrimaria;
  final Color corSecundaria;
}

RankInfo rankParaNivel(int nivel) {
  if (nivel >= 50) {
    return const RankInfo(
      nome: 'Mestre das Finanças',
      corPrimaria: Color(0xFFFFD60A),
      corSecundaria: Color(0xFFFF9F0A),
    );
  }
  if (nivel >= 25) {
    return const RankInfo(
      nome: 'Estrategista',
      corPrimaria: Color(0xFFBF5AF2),
      corSecundaria: Color(0xFF64D2FF),
    );
  }
  if (nivel >= 10) {
    return const RankInfo(
      nome: 'Investidor',
      corPrimaria: Color(0xFF0A84FF),
      corSecundaria: Color(0xFF64D2FF),
    );
  }
  return const RankInfo(
    nome: 'Poupador',
    corPrimaria: Color(0xFF30D158),
    corSecundaria: Color(0xFF9EE6B0),
  );
}