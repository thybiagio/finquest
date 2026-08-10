import 'package:flutter/material.dart';
import '../models/meta.dart';

class MetaCard extends StatelessWidget {
  const MetaCard({super.key, required this.meta});

  final Meta meta;

  @override
  Widget build(BuildContext context) {
    final cor = meta.concluida ? const Color(0xFF30D158) : const Color(0xFF0A84FF);

    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(meta.titulo, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              Text(
                'R\$ ${meta.valorAtual.toStringAsFixed(0)} / R\$ ${meta.valorAlvo.toStringAsFixed(0)}',
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: meta.percentualAlcancado,
              minHeight: 8,
              backgroundColor: Colors.black12,
              valueColor: AlwaysStoppedAnimation<Color>(cor),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            meta.concluida
                ? 'Meta concluída! 🏆'
                : '${(meta.percentualAlcancado * 100).toStringAsFixed(0)}% alcançado',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: cor),
          ),
        ],
      ),
    );
  }
}