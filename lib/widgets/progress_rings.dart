import 'dart:math';
import 'package:flutter/material.dart';

class ProgressRings extends StatelessWidget {
  const ProgressRings({
    super.key,
    required this.xpPercentual,
    required this.hpPercentual,
  });

  final double xpPercentual;
  final double hpPercentual;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 72,
      height: 72,
      child: CustomPaint(
        painter: _RingsPainter(
          xpPercentual: xpPercentual,
          hpPercentual: hpPercentual,
        ),
      ),
    );
  }
}

class _RingsPainter extends CustomPainter {
  _RingsPainter({required this.xpPercentual, required this.hpPercentual});

  final double xpPercentual;
  final double hpPercentual;

  static const _corXp = Color(0xFFBF5AF2);
  static const _corHp = Color(0xFF30D158);
  static const _corTrilha = Colors.black12;
  static const _strokeWidth = 7.0;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final raioExterno = size.width / 2 - _strokeWidth / 2;
    final raioInterno = raioExterno - 10;

    _desenharAnel(canvas, center, raioExterno, xpPercentual, _corXp);
    _desenharAnel(canvas, center, raioInterno, hpPercentual, _corHp);
  }

  void _desenharAnel(
    Canvas canvas,
    Offset center,
    double raio,
    double percentual,
    Color cor,
  ) {
    final rect = Rect.fromCircle(center: center, radius: raio);

    final trilha = Paint()
      ..color = _corTrilha
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth;
    canvas.drawArc(rect, 0, 2 * pi, false, trilha);

    final progresso = Paint()
      ..color = cor
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth
      ..strokeCap = StrokeCap.round;
    final anguloVarrido = 2 * pi * percentual.clamp(0.0, 1.0);
    canvas.drawArc(rect, -pi / 2, anguloVarrido, false, progresso);
  }

  @override
  bool shouldRepaint(covariant _RingsPainter oldDelegate) {
    return oldDelegate.xpPercentual != xpPercentual ||
        oldDelegate.hpPercentual != hpPercentual;
  }
}