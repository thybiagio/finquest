import 'package:flutter/material.dart';
import 'widgets/stat_card.dart';
import 'widgets/categoria_card.dart';
import 'models/categoria.dart';
import 'widgets/categoria_donut_chart.dart';
import 'widgets/progress_rings.dart';

void main() {
  runApp(const FinQuestApp());
}

class FinQuestApp extends StatelessWidget {
  const FinQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinQuest',
        debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF2F2F7),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static final List<Categoria> _categorias = [
    const Categoria(
      id: '1',
      nome: 'Alimentação',
      corHex: '#FF9F0A',
      orcamentoMensal: 600,
      gastoAtual: 480,
    ),
    const Categoria(
      id: '2',
      nome: 'Transporte',
      corHex: '#40C8E0',
      orcamentoMensal: 350,
      gastoAtual: 410,
    ),
    const Categoria(
      id: '3',
      nome: 'Lazer',
      corHex: '#BF5AF2',
      orcamentoMensal: 400,
      gastoAtual: 190,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FinQuest'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: ProgressRings(xpPercentual: 0.78, hpPercentual: 0.82),
            ),
          ),
        ],
      ),
      body: Padding(
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
              children: const [
                StatCard(label: 'Receita', value: 'R\$ 4.500'),
                StatCard(label: 'Gastos', value: 'R\$ 2.870'),
                StatCard(
                  label: 'Saldo',
                  value: 'R\$ 1.630',
                  valueColor: Color(0xFF30D158),
                ),
                StatCard(
                  label: 'Economia',
                  value: 'R\$ 800',
                  valueColor: Color(0xFF30D158),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Gastos por categoria',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black54),
            ),
            const SizedBox(height: 10),
            CategoriaDonutChart(categorias: _categorias),
            const SizedBox(height: 20),
            const Text(
              'Categorias',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black54),
            ),
            const SizedBox(height: 10),
            for (final categoria in _categorias) CategoriaCard(categoria: categoria),
          ],
        ),
      ),
    );
  }
}