import 'package:flutter/material.dart';
import 'widgets/stat_card.dart';

void main() {
  runApp(const FinQuestApp());
}

class FinQuestApp extends StatelessWidget {
  const FinQuestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FinQuest',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FinQuest')),
      body:  Padding(
        padding: EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.6,
          children: [
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
      ),
    );
  }
}