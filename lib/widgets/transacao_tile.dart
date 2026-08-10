import 'package:flutter/material.dart';
import '../models/transacao.dart';

class TransacaoTile extends StatelessWidget {
  const TransacaoTile({super.key, required this.transacao});

  final Transacao transacao;

  @override
  Widget build(BuildContext context) {
    final cor = transacao.isReceita ? const Color(0xFF30D158) : const Color(0xFFFF453A);
    final sinal = transacao.isReceita ? '+' : '-';
    final rotulo = transacao.isReceita ? 'Receita' : (transacao.categoria?.nome ?? 'Despesa');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(rotulo, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                if (transacao.descricao != null && transacao.descricao!.isNotEmpty)
                  Text(
                    transacao.descricao!,
                    style: const TextStyle(fontSize: 11, color: Colors.black54),
                  ),
              ],
            ),
          ),
          Text(
            '$sinal R\$ ${transacao.valor.toStringAsFixed(0)}',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: cor),
          ),
        ],
      ),
    );
  }
}