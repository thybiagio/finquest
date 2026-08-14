import 'package:flutter/material.dart';

/// Agrupa vários itens dentro de um único card, separados por divisórias finas —
/// como uma lista "grouped" de iOS/apps bancários, em vez de vários cards soltos
/// e espaçados entre si.
class GroupedCard extends StatelessWidget {
  const GroupedCard({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1)
              const Divider(height: 1, thickness: 1, color: Color(0x14000000), indent: 14, endIndent: 14),
          ],
        ],
      ),
    );
  }
}