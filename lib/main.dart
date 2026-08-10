import 'package:flutter/material.dart';
import 'models/categoria.dart';
import 'models/transacao.dart';
import 'screens/home_content.dart';
import 'screens/categorias_content.dart';
import 'screens/metas_content.dart';
import 'screens/perfil_screen.dart';
import 'widgets/progress_rings.dart';
import 'models/meta.dart';

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
      home: const AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _abaAtual = 0;

  late List<Categoria> _categorias;
  double _receitaTotal = 4500;
  final List<Transacao> _transacoes = [];
  final List<Meta> _metas = [];

  static const _titulos = ['FinQuest', 'Categorias', 'Metas', 'Perfil'];

  @override
  void initState() {
    super.initState();
    _categorias = [
      const Categoria(id: '1', nome: 'Alimentação', corHex: '#FF9F0A', orcamentoMensal: 600, gastoAtual: 480),
      const Categoria(id: '2', nome: 'Transporte', corHex: '#40C8E0', orcamentoMensal: 350, gastoAtual: 410),
      const Categoria(id: '3', nome: 'Lazer', corHex: '#BF5AF2', orcamentoMensal: 400, gastoAtual: 190),
    ];
  }

  double get _despesaTotal => _categorias.fold(0.0, (soma, c) => soma + c.gastoAtual);
  double get _saldo => _receitaTotal - _despesaTotal;

  void _adicionarCategoria(Categoria categoria) {
    setState(() {
      _categorias = [..._categorias, categoria];
    });
  }

  void _adicionarMeta(Meta meta) {
    setState(() {
      _metas.add(meta);
    });
  }

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
          _categorias[index] = categoria.copyWith(gastoAtual: categoria.gastoAtual + valor);
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
    Categoria? categoriaSelecionada = _categorias.isNotEmpty ? _categorias.first : null;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Nova transação', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  SegmentedButton<TipoTransacao>(
                    segments: const [
                      ButtonSegment(value: TipoTransacao.despesa, label: Text('Despesa')),
                      ButtonSegment(value: TipoTransacao.receita, label: Text('Receita')),
                    ],
                    selected: {tipo},
                    onSelectionChanged: (novaSelecao) {
                      setModalState(() => tipo = novaSelecao.first);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(controller: valorController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Valor')),
                  if (tipo == TipoTransacao.despesa) ...[
                    const SizedBox(height: 12),
                    DropdownButtonFormField<Categoria>(
                      initialValue: categoriaSelecionada,
                      decoration: const InputDecoration(labelText: 'Categoria'),
                      items: [
                        for (final categoria in _categorias)
                          DropdownMenuItem(value: categoria, child: Text(categoria.nome)),
                      ],
                      onChanged: (nova) {
                        setModalState(() => categoriaSelecionada = nova);
                      },
                    ),
                  ],
                  const SizedBox(height: 12),
                  TextField(controller: descricaoController, decoration: const InputDecoration(labelText: 'Descrição (opcional)')),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final valor = double.tryParse(valorController.text) ?? 0;
                        if (valor <= 0) return;
                        if (tipo == TipoTransacao.despesa && categoriaSelecionada == null) return;

                        _registrarTransacao(
                          valor: valor,
                          tipo: tipo,
                          categoria: tipo == TipoTransacao.despesa ? categoriaSelecionada : null,
                          descricao: descricaoController.text.trim().isEmpty ? null : descricaoController.text.trim(),
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
    final telas = [
      HomeContent(
        categorias: _categorias,
        transacoes: _transacoes,
        receitaTotal: _receitaTotal,
        despesaTotal: _despesaTotal,
        saldo: _saldo,
      ),
      CategoriasContent(
        categorias: _categorias,
        onAdicionarCategoria: _adicionarCategoria,
      ),
      MetasContent(metas: _metas, onAdicionarMeta: _adicionarMeta),
      const PerfilScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titulos[_abaAtual]),
        actions: _abaAtual == 0
            ? const [
                Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Center(
                    child: ProgressRings(xpPercentual: 0.78, hpPercentual: 0.82),
                  ),
                ),
              ]
            : null,
      ),
      body: IndexedStack(index: _abaAtual, children: telas),
      floatingActionButton: _abaAtual == 0
          ? FloatingActionButton(
              onPressed: () => _abrirNovaTransacao(context),
              backgroundColor: const Color(0xFF0A84FF),
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _abaAtual,
        onDestinationSelected: (index) => setState(() => _abaAtual = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Início'),
          NavigationDestination(icon: Icon(Icons.grid_view_outlined), selectedIcon: Icon(Icons.grid_view), label: 'Categorias'),
          NavigationDestination(icon: Icon(Icons.flag_outlined), selectedIcon: Icon(Icons.flag), label: 'Metas'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}