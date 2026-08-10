import 'package:flutter/material.dart';
import '../models/categoria.dart';
import '../models/transacao.dart';
import '../widgets/stat_card.dart';
import '../widgets/categoria_card.dart';
import '../widgets/categoria_donut_chart.dart';
import '../widgets/transacao_tile.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({
    super.key,
    required this.categorias,
    required this.transacoes,
    required this.receitaTotal,
    required this.despesaTotal,
    required this.saldo,
  });

  final List<Categoria> categorias;
  final List<Transacao> transacoes;
  final double receitaTotal;
  final double despesaTotal;
  final double saldo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.6,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              StatCard(label: 'Receita', value: 'R\$ ${receitaTotal.toStringAsFixed(0)}'),
              StatCard(label: 'Gastos', value: 'R\$ ${despesaTotal.toStringAsFixed(0)}'),
              StatCard(label: 'Saldo', value: 'R\$ ${saldo.toStringAsFixed(0)}', valueColor: const Color(0xFF30D158)),
              const StatCard(label: 'Economia', value: 'R\$ 800', valueColor: Color(0xFF30D158)),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Gastos por categoria', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black54)),
          const SizedBox(height: 10),
          CategoriaDonutChart(categorias: categorias),
          const SizedBox(height: 20),
          const Text('Categorias', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black54)),
          const SizedBox(height: 10),
          for (final categoria in categorias) CategoriaCard(categoria: categoria),
          const SizedBox(height: 20),
          const Text('Histórico', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black54)),
          const SizedBox(height: 6),
          if (transacoes.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('Nenhuma transação ainda', style: TextStyle(fontSize: 12, color: Colors.black38)),
            )
          else
            for (final transacao in transacoes.reversed) TransacaoTile(transacao: transacao),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}