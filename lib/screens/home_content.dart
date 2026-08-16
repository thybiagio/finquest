import 'package:flutter/material.dart';
import '../models/categoria.dart';
import '../models/transacao.dart';
import '../widgets/categoria_card.dart';
import '../widgets/categoria_donut_chart.dart';
import '../widgets/transacao_tile.dart';
import '../widgets/grouped_card.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({
    super.key,
    required this.categorias,
    required this.transacoes,
    required this.receitaTotal,
    required this.despesaTotal,
    required this.saldo,
    required this.economiaTotal,
    required this.onEditarTransacao,
    required this.onExcluirTransacao,
    required this.onEditarCategoria,
    required this.onExcluirCategoria,
  });

  final List<Categoria> categorias;
  final List<Transacao> transacoes;
  final double receitaTotal;
  final double despesaTotal;
  final double saldo;
  final double economiaTotal;
  final ValueChanged<Transacao> onEditarTransacao;
  final ValueChanged<Transacao> onExcluirTransacao;
  final ValueChanged<Categoria> onEditarCategoria;
  final ValueChanged<Categoria> onExcluirCategoria;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(child: _StatCell(label: 'Receita', value: 'R\$ ${receitaTotal.toStringAsFixed(0)}')),
                      const VerticalDivider(width: 1, thickness: 1, color: Color(0x14000000)),
                      Expanded(child: _StatCell(label: 'Gastos', value: 'R\$ ${despesaTotal.toStringAsFixed(0)}')),
                    ],
                  ),
                ),
                const Divider(height: 1, thickness: 1, color: Color(0x14000000)),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: _StatCell(
                          label: 'Saldo',
                          value: 'R\$ ${saldo.toStringAsFixed(0)}',
                          valueColor: const Color(0xFF30D158),
                        ),
                      ),
                      const VerticalDivider(width: 1, thickness: 1, color: Color(0x14000000)),
                      Expanded(
                        child: _StatCell(
                          label: 'Economia',
                          value: 'R\$ ${economiaTotal.toStringAsFixed(0)}',
                          valueColor: const Color(0xFF30D158),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Gastos por categoria', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black54)),
          const SizedBox(height: 10),
          CategoriaDonutChart(categorias: categorias),
          const SizedBox(height: 24),
          const Text('Categorias', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black54)),
          const SizedBox(height: 10),
          if (categorias.isNotEmpty)
            GroupedCard(
              children: [
                for (final categoria in categorias)
                  CategoriaCard(
                    categoria: categoria,
                    onEditar: () => onEditarCategoria(categoria),
                    onExcluir: () => onExcluirCategoria(categoria),
                  ),
              ],
            ),
          const SizedBox(height: 24),
          const Text('Histórico', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black54)),
          const SizedBox(height: 10),
          if (transacoes.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text('Nenhuma transação ainda', style: TextStyle(fontSize: 12, color: Colors.black38)),
              ),
            )
          else
            GroupedCard(
              children: [
                for (final transacao in transacoes.reversed)
                  TransacaoTile(
                    transacao: transacao,
                    onEditar: () => onEditarTransacao(transacao),
                    onExcluir: () => onExcluirTransacao(transacao),
                  ),
              ],
            ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({required this.label, required this.value, this.valueColor});

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: valueColor ?? Colors.black87),
          ),
        ],
      ),
    );
  }
}