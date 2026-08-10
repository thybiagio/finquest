import 'package:flutter/material.dart';
import 'widgets/stat_card.dart';
import 'widgets/categoria_card.dart';
import 'widgets/transacao_tile.dart';
import 'models/categoria.dart';
import 'models/transacao.dart';
import 'widgets/categoria_donut_chart.dart';
import 'widgets/progress_rings.dart';
import 'screens/categorias_screen.dart';

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Categoria> _categorias;
  double _receitaTotal = 4500;
  final List<Transacao> _transacoes = [];

  @override
  void initState() {
    super.initState();
    _categorias = [
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
  }

  double get _despesaTotal =>
      _categorias.fold(0.0, (soma, categoria) => soma + categoria.gastoAtual);

  double get _saldo => _receitaTotal - _despesaTotal;

  void _registrarTransacao({
    required double valor,
    required TipoTransacao tipo,
    Categoria? categoria,
    String? descricao,
  }) {
    setState(() {
      if (tipo == TipoTransacao.receita) {
        _receitaTotal += valor;
      } else if (categoria != null) {
        final index = _categorias.indexOf(categoria);
        if (index != -1) {
          _categorias[index] =
              categoria.copyWith(gastoAtual: categoria.gastoAtual + valor);
        }
      }

      _transacoes.add(
        Transacao(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          valor: valor,
          tipo: tipo,
          data: DateTime.now(),
          categoria: tipo == TipoTransacao.despesa ? categoria : null,
          descricao: descricao,
        ),
      );
    });
  }

  Future<void> _abrirNovaTransacao(BuildContext context) async {
    final valorController = TextEditingController();
    final descricaoController = TextEditingController();
    var tipo = TipoTransacao.despesa;
    Categoria? categoriaSelecionada =
        _categorias.isNotEmpty ? _categorias.first : null;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nova transação',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SegmentedButton<TipoTransacao>(
                    segments: const [
                      ButtonSegment(
                        value: TipoTransacao.despesa,
                        label: Text('Despesa'),
                      ),
                      ButtonSegment(
                        value: TipoTransacao.receita,
                        label: Text('Receita'),
                      ),
                    ],
                    selected: {tipo},
                    onSelectionChanged: (novaSelecao) {
                      setModalState(() => tipo = novaSelecao.first);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: valorController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Valor'),
                  ),
                  if (tipo == TipoTransacao.despesa) ...[
                    const SizedBox(height: 12),
                    DropdownButtonFormField<Categoria>(
                      initialValue: categoriaSelecionada,
                      decoration: const InputDecoration(labelText: 'Categoria'),
                      items: [
                        for (final categoria in _categorias)
                          DropdownMenuItem(
                            value: categoria,
                            child: Text(categoria.nome),
                          ),
                      ],
                      onChanged: (nova) {
                        setModalState(() => categoriaSelecionada = nova);
                      },
                    ),
                  ],
                  const SizedBox(height: 12),
                  TextField(
                    controller: descricaoController,
                    decoration:
                        const InputDecoration(labelText: 'Descrição (opcional)'),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final valor = double.tryParse(valorController.text) ?? 0;
                        if (valor <= 0) return;
                        if (tipo == TipoTransacao.despesa &&
                            categoriaSelecionada == null) {
                          return;
                        }

                        _registrarTransacao(
                          valor: valor,
                          tipo: tipo,
                          categoria: tipo == TipoTransacao.despesa
                              ? categoriaSelecionada
                              : null,
                          descricao: descricaoController.text.trim().isEmpty
                              ? null
                              : descricaoController.text.trim(),
                        );
                        Navigator.of(context).pop();
                      },
                      child: const Text('Salvar'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FinQuest'),
        actions: [
          IconButton(
            icon: const Icon(Icons.grid_view_rounded),
            tooltip: 'Categorias',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      CategoriasScreen(categoriasIniciais: _categorias),
                ),
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Center(
              child: ProgressRings(xpPercentual: 0.78, hpPercentual: 0.82),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirNovaTransacao(context),
        backgroundColor: const Color(0xFF0A84FF),
        child: const Icon(Icons.add),
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
              children: [
                StatCard(
                  label: 'Receita',
                  value: 'R\$ ${_receitaTotal.toStringAsFixed(0)}',
                ),
                StatCard(
                  label: 'Gastos',
                  value: 'R\$ ${_despesaTotal.toStringAsFixed(0)}',
                ),
                StatCard(
                  label: 'Saldo',
                  value: 'R\$ ${_saldo.toStringAsFixed(0)}',
                  valueColor: const Color(0xFF30D158),
                ),
                const StatCard(
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
            const SizedBox(height: 20),
            const Text(
              'Histórico',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black54),
            ),
            const SizedBox(height: 6),
            if (_transacoes.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Nenhuma transação ainda',
                  style: TextStyle(fontSize: 12, color: Colors.black38),
                ),
              )
            else
              for (final transacao in _transacoes.reversed)
                TransacaoTile(transacao: transacao),
              const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}