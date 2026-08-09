import 'dart:math';
import 'package:flutter/material.dart';
import '../models/categoria.dart';

class CategoriaDonutChart extends StatelessWidget {
  const CategoriaDonutChart({super.key, required this.categorias});

  final List<Categoria> categorias;

  double get _total =>
      categorias.fold(0.0, (soma, categoria) => soma + categoria.gastoAtual);

  @override
  Widget build(BuildContext context) {
    final total = _total;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 104,
            height: 104,
            child: CustomPaint(
              painter: _DonutPainter(categorias: categorias, total: total),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Total', style: TextStyle(fontSize: 10, color: Colors.black54)),
                    Text(
                      'R\$ ${total.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (final categoria in categorias)
                  _LegendRow(categoria: categoria, total: total),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.categoria, required this.total});

  final Categoria categoria;
  final double total;

  @override
  Widget build(BuildContext context) {
    final percentual = total <= 0 ? 0.0 : categoria.gastoAtual / total;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: categoria.cor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(categoria.nome, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          ),
          Text(
            '${(percentual * 100).toStringAsFixed(0)}%',
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter({required this.categorias, required this.total});

  final List<Categoria> categorias;
  final double total;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    const strokeWidth = 16.0;

    if (total <= 0) {
      final paint = Paint()
        ..color = Colors.black12
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      canvas.drawArc(rect, 0, 2 * pi, false, paint);
      return;
    }

    var anguloInicial = -pi / 2;
    for (final categoria in categorias) {
      final fatia = (categoria.gastoAtual / total) * 2 * pi;
      final paint = Paint()
        ..color = categoria.cor
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      canvas.drawArc(rect, anguloInicial, fatia, false, paint);
      anguloInicial += fatia;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.categorias != categorias || oldDelegate.total != total;
  }
}