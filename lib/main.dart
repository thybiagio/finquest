import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'models/categoria.dart';
import 'models/transacao.dart';
import 'models/medalha.dart';
import 'screens/home_content.dart';
import 'screens/categorias_content.dart';
import 'screens/metas_content.dart';
import 'screens/perfil_screen.dart';
import 'widgets/progress_rings.dart';
import 'widgets/long_press_action_menu.dart';
import 'models/meta.dart';
import 'services/storage_service.dart';

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
      builder: (context, child) {
        return Container(
          color: const Color(0xFFD1D1D6),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: child,
            ),
          ),
        );
      },
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

  String _nomeJogador = 'Aventureiro';
  int _nivel = 1;
  int _xpAtual = 0;
  static const int _xpPorNivel = 100;
  String? _fotoPerfilBase64;

  final ImagePicker _imagePicker = ImagePicker();

  final StorageService _storage = StorageService();
  bool _carregando = true;

  static const _titulos = ['FinQuest', 'Categorias', 'Metas', 'Perfil'];

  @override
  void initState() {
    super.initState();
    _categorias = [
      const Categoria(id: '1', nome: 'Alimentação', corHex: '#FF9F0A', orcamentoMensal: 600, gastoAtual: 480),
      const Categoria(id: '2', nome: 'Transporte', corHex: '#40C8E0', orcamentoMensal: 350, gastoAtual: 410),
      const Categoria(id: '3', nome: 'Lazer', corHex: '#BF5AF2', orcamentoMensal: 400, gastoAtual: 190),
    ];
    _carregarEstadoSalvo();
  }

  Future<void> _carregarEstadoSalvo() async {
    final estado = await _storage.carregar();
    if (estado != null) {
      setState(() {
        _categorias = estado.categorias;
        _transacoes
          ..clear()
          ..addAll(estado.transacoes);
        _metas
          ..clear()
          ..addAll(estado.metas);
        _receitaTotal = estado.receitaTotal;
        _nomeJogador = estado.nomeJogador;
        _nivel = estado.nivel;
        _xpAtual = estado.xpAtual;
        _fotoPerfilBase64 = estado.fotoPerfilBase64;
        _carregando = false;
      });
    } else {
      setState(() => _carregando = false);
    }
  }

  void _salvarEstadoAtual() {
    _storage.salvar(
      EstadoFinQuest(
        categorias: _categorias,
        transacoes: _transacoes,
        metas: _metas,
        receitaTotal: _receitaTotal,
        nomeJogador: _nomeJogador,
        nivel: _nivel,
        xpAtual: _xpAtual,
        fotoPerfilBase64: _fotoPerfilBase64,
      ),
    );
  }

  double get _despesaTotal => _categorias.fold(0.0, (soma, c) => soma + c.gastoAtual);
  double get _saldo => _receitaTotal - _despesaTotal;
  double get _economiaTotal => _metas.fold(0.0, (soma, m) => soma + m.valorAtual);

  double get _xpPercentual => _xpAtual / _xpPorNivel;

  double get _hpPercentual {
    final categoriasEstouradas = _categorias.where((c) => c.estourouOrcamento).length;
    var hp = 100.0;
    hp -= categoriasEstouradas * 15;
    if (_saldo < 0) hp -= 20;
    return (hp / 100).clamp(0.0, 1.0);
  }

  void _ganharXp(int quantidade) {
    _xpAtual += quantidade;
    while (_xpAtual >= _xpPorNivel) {
      _xpAtual -= _xpPorNivel;
      _nivel++;
    }
  }

  void _editarNome(String novoNome) {
    final nome = novoNome.trim();
    if (nome.isEmpty) return;
    setState(() {
      _nomeJogador = nome;
    });
    _salvarEstadoAtual();
  }

  Future<void> _escolherFotoPerfil(ImageSource origem) async {
    final arquivo = await _imagePicker.pickImage(source: origem, maxWidth: 512, imageQuality: 80);
    if (arquivo == null) return;
    final bytes = await arquivo.readAsBytes();
    setState(() {
      _fotoPerfilBase64 = base64Encode(bytes);
    });
    _salvarEstadoAtual();
  }

  void _removerFotoPerfil() {
    setState(() {
      _fotoPerfilBase64 = null;
    });
    _salvarEstadoAtual();
  }

  Future<void> _abrirMenuFotoPerfil(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Escolher da galeria'),
                onTap: () {
                  Navigator.of(context).pop();
                  _escolherFotoPerfil(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('Tirar foto'),
                onTap: () {
                  Navigator.of(context).pop();
                  _escolherFotoPerfil(ImageSource.camera);
                },
              ),
              if (_fotoPerfilBase64 != null)
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text('Remover foto', style: TextStyle(color: Colors.red)),
                  onTap: () {
                    Navigator.of(context).pop();
                    _removerFotoPerfil();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  // ---------------------- Categorias ----------------------

  void _adicionarCategoria(Categoria categoria) {
    setState(() {
      _categorias = [..._categorias, categoria];
    });
    _salvarEstadoAtual();
  }

  void _editarCategoria(Categoria categoria, {required String nome, required double orcamentoMensal}) {
    final index = _categorias.indexWhere((c) => c.id == categoria.id);
    if (index == -1) return;
    setState(() {
      _categorias[index] = _categorias[index].copyWith(nome: nome, orcamentoMensal: orcamentoMensal);
    });
    _salvarEstadoAtual();
  }

  void _excluirCategoria(Categoria categoria) {
    setState(() {
      _transacoes.removeWhere((t) => t.categoria?.id == categoria.id);
      _categorias.removeWhere((c) => c.id == categoria.id);
    });
    _salvarEstadoAtual();
  }

  // ------------------------- Metas -------------------------

  void _adicionarMeta(Meta meta) {
    setState(() {
      _metas.add(meta);
    });
    _salvarEstadoAtual();
  }

  void _editarMeta(Meta meta, {required String titulo, required double valorAlvo}) {
    final index = _metas.indexWhere((m) => m.id == meta.id);
    if (index == -1) return;
    setState(() {
      _metas[index] = _metas[index].copyWith(titulo: titulo, valorAlvo: valorAlvo);
    });
    _salvarEstadoAtual();
  }

  void _excluirMeta(Meta meta) {
    setState(() {
      _transacoes.removeWhere((t) => t.meta?.id == meta.id);
      _metas.removeWhere((m) => m.id == meta.id);
    });
    _salvarEstadoAtual();
  }

  void _contribuirParaMeta(Meta meta, double valor) {
    final index = _metas.indexWhere((m) => m.id == meta.id);
    if (index != -1) {
      final metaAtualizada = _metas[index].copyWith(valorAtual: _metas[index].valorAtual + valor);
      final estavaConcluida = _metas[index].concluida;
      _metas[index] = metaAtualizada;
      if (!estavaConcluida && metaAtualizada.concluida) {
        _ganharXp(50);
      }
    }
  }

  // ---------------------- Transações ----------------------

  /// Desfaz o efeito de uma transação no saldo/orçamento/meta — usado antes
  /// de editar ou excluir, para não deixar valores "fantasmas" contados.
  void _reverterEfeitoTransacao(Transacao transacao) {
    if (transacao.isReceita) {
      if (transacao.meta != null) {
        final index = _metas.indexWhere((m) => m.id == transacao.meta!.id);
        if (index != -1) {
          _metas[index] = _metas[index].copyWith(valorAtual: _metas[index].valorAtual - transacao.valor);
        }
      } else {
        _receitaTotal -= transacao.valor;
      }
    } else if (transacao.categoria != null) {
      final index = _categorias.indexWhere((c) => c.id == transacao.categoria!.id);
      if (index != -1) {
        _categorias[index] = _categorias[index].copyWith(gastoAtual: _categorias[index].gastoAtual - transacao.valor);
      }
    }
  }

  void _registrarTransacao({
    required double valor,
    required TipoTransacao tipo,
    Categoria? categoria,
    String? descricao,
    Meta? metaDestino,
  }) {
    setState(() {
      _ganharXp(5);
      if (tipo == TipoTransacao.receita) {
        if (metaDestino != null) {
          _contribuirParaMeta(metaDestino, valor);
        } else {
          _receitaTotal += valor;
        }
      } else if (categoria != null) {
        final index = _categorias.indexWhere((c) => c.id == categoria.id);
        if (index != -1) {
          _categorias[index] = _categorias[index].copyWith(gastoAtual: _categorias[index].gastoAtual + valor);
        }
      }
      _transacoes.add(
        Transacao(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          valor: valor,
          tipo: tipo,
          data: DateTime.now(),
          categoria: tipo == TipoTransacao.despesa ? categoria : null,
          meta: tipo == TipoTransacao.receita ? metaDestino : null,
          descricao: descricao,
        ),
      );
    });
    _salvarEstadoAtual();
  }

  void _editarTransacao(
    Transacao original, {
    required double valor,
    required TipoTransacao tipo,
    Categoria? categoria,
    String? descricao,
    Meta? metaDestino,
  }) {
    setState(() {
      _reverterEfeitoTransacao(original);

      if (tipo == TipoTransacao.receita) {
        if (metaDestino != null) {
          _contribuirParaMeta(metaDestino, valor);
        } else {
          _receitaTotal += valor;
        }
      } else if (categoria != null) {
        final index = _categorias.indexWhere((c) => c.id == categoria.id);
        if (index != -1) {
          _categorias[index] = _categorias[index].copyWith(gastoAtual: _categorias[index].gastoAtual + valor);
        }
      }

      final indexTransacao = _transacoes.indexWhere((t) => t.id == original.id);
      if (indexTransacao != -1) {
        _transacoes[indexTransacao] = Transacao(
          id: original.id,
          valor: valor,
          tipo: tipo,
          data: original.data,
          categoria: tipo == TipoTransacao.despesa ? categoria : null,
          meta: tipo == TipoTransacao.receita ? metaDestino : null,
          descricao: descricao,
        );
      }
    });
    _salvarEstadoAtual();
  }

  void _excluirTransacao(Transacao transacao) {
    setState(() {
      _reverterEfeitoTransacao(transacao);
      _transacoes.removeWhere((t) => t.id == transacao.id);
    });
    _salvarEstadoAtual();
  }

  Future<void> _abrirFormularioTransacao(BuildContext context, {Transacao? transacaoEditando}) async {
    final editando = transacaoEditando != null;
    final valorController = TextEditingController(
      text: editando ? transacaoEditando.valor.toStringAsFixed(2) : '',
    );
    final descricaoController = TextEditingController(text: transacaoEditando?.descricao ?? '');
    var tipo = transacaoEditando?.tipo ?? TipoTransacao.despesa;
    Categoria? categoriaSelecionada = transacaoEditando?.categoria ??
        (_categorias.isNotEmpty ? _categorias.first : null);
    Meta? metaSelecionada = transacaoEditando?.meta;

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
                  Text(
                    editando ? 'Editar transação' : 'Nova transação',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
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
                  if (tipo == TipoTransacao.receita && _metas.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    DropdownButtonFormField<Meta?>(
                      initialValue: metaSelecionada,
                      decoration: const InputDecoration(
                        labelText: 'Destino',
                        helperText: 'Vai para o saldo ou inteiro para uma meta',
                      ),
                      items: [
                        const DropdownMenuItem<Meta?>(value: null, child: Text('Saldo disponível')),
                        for (final meta in _metas)
                          DropdownMenuItem(value: meta, child: Text('Meta: ${meta.titulo}')),
                      ],
                      onChanged: (nova) {
                        setModalState(() => metaSelecionada = nova);
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

                        if (editando) {
                          _editarTransacao(
                            transacaoEditando,
                            valor: valor,
                            tipo: tipo,
                            categoria: tipo == TipoTransacao.despesa ? categoriaSelecionada : null,
                            descricao: descricaoController.text.trim().isEmpty ? null : descricaoController.text.trim(),
                            metaDestino: tipo == TipoTransacao.receita ? metaSelecionada : null,
                          );
                        } else {
                          _registrarTransacao(
                            valor: valor,
                            tipo: tipo,
                            categoria: tipo == TipoTransacao.despesa ? categoriaSelecionada : null,
                            descricao: descricaoController.text.trim().isEmpty ? null : descricaoController.text.trim(),
                            metaDestino: tipo == TipoTransacao.receita ? metaSelecionada : null,
                          );
                        }
                        Navigator.of(context).pop();
                      },
                      child: Text(editando ? 'Salvar alterações' : 'Salvar'),
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

  Future<void> _abrirFormularioCategoria(BuildContext context, {Categoria? categoriaEditando}) async {
    final editando = categoriaEditando != null;
    final nomeController = TextEditingController(text: categoriaEditando?.nome ?? '');
    final orcamentoController = TextEditingController(
      text: editando ? categoriaEditando.orcamentoMensal.toStringAsFixed(2) : '',
    );

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                editando ? 'Editar categoria' : 'Nova categoria',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(controller: nomeController, decoration: const InputDecoration(labelText: 'Nome da categoria')),
              const SizedBox(height: 12),
              TextField(controller: orcamentoController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Orçamento mensal')),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final nome = nomeController.text.trim();
                    final orcamento = double.tryParse(orcamentoController.text) ?? 0;
                    if (nome.isEmpty || orcamento <= 0) return;

                    if (editando) {
                      _editarCategoria(categoriaEditando, nome: nome, orcamentoMensal: orcamento);
                    } else {
                      _adicionarCategoria(
                        Categoria(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          nome: nome,
                          corHex: '#0A84FF',
                          orcamentoMensal: orcamento,
                        ),
                      );
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text(editando ? 'Salvar alterações' : 'Criar categoria'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _abrirFormularioMeta(BuildContext context, {Meta? metaEditando}) async {
    final editando = metaEditando != null;
    final tituloController = TextEditingController(text: metaEditando?.titulo ?? '');
    final valorController = TextEditingController(
      text: editando ? metaEditando.valorAlvo.toStringAsFixed(2) : '',
    );

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                editando ? 'Editar meta' : 'Nova meta',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(controller: tituloController, decoration: const InputDecoration(labelText: 'Título da meta')),
              const SizedBox(height: 12),
              TextField(controller: valorController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Valor alvo')),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final titulo = tituloController.text.trim();
                    final valorAlvo = double.tryParse(valorController.text) ?? 0;
                    if (titulo.isEmpty || valorAlvo <= 0) return;

                    if (editando) {
                      _editarMeta(metaEditando, titulo: titulo, valorAlvo: valorAlvo);
                    } else {
                      _adicionarMeta(
                        Meta(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          titulo: titulo,
                          valorAlvo: valorAlvo,
                        ),
                      );
                    }
                    Navigator.of(context).pop();
                  },
                  child: Text(editando ? 'Salvar alterações' : 'Criar meta'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmarExcluirTransacao(BuildContext context, Transacao transacao) async {
    final confirmado = await confirmarExclusao(context, mensagem: 'Essa transação será removida e seu efeito no saldo/orçamento desfeito.');
    if (confirmado) _excluirTransacao(transacao);
  }

  Future<void> _confirmarExcluirCategoria(BuildContext context, Categoria categoria) async {
    final confirmado = await confirmarExclusao(
      context,
      mensagem: 'A categoria "${categoria.nome}" e as transações associadas a ela serão excluídas.',
    );
    if (confirmado) _excluirCategoria(categoria);
  }

  Future<void> _confirmarExcluirMeta(BuildContext context, Meta meta) async {
    final confirmado = await confirmarExclusao(
      context,
      mensagem: 'A meta "${meta.titulo}" e as transações associadas a ela serão excluídas.',
    );
    if (confirmado) _excluirMeta(meta);
  }

  @override
  Widget build(BuildContext context) {
    if (_carregando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final telas = [
      HomeContent(
        categorias: _categorias,
        transacoes: _transacoes,
        receitaTotal: _receitaTotal,
        despesaTotal: _despesaTotal,
        saldo: _saldo,
        economiaTotal: _economiaTotal,
        onEditarTransacao: (t) => _abrirFormularioTransacao(context, transacaoEditando: t),
        onExcluirTransacao: (t) => _confirmarExcluirTransacao(context, t),
        onEditarCategoria: (c) => _abrirFormularioCategoria(context, categoriaEditando: c),
        onExcluirCategoria: (c) => _confirmarExcluirCategoria(context, c),
      ),
      CategoriasContent(
        categorias: _categorias,
        onNovaCategoria: () => _abrirFormularioCategoria(context),
        onEditarCategoria: (c) => _abrirFormularioCategoria(context, categoriaEditando: c),
        onExcluirCategoria: (c) => _confirmarExcluirCategoria(context, c),
      ),
      MetasContent(
        metas: _metas,
        onNovaMeta: () => _abrirFormularioMeta(context),
        onEditarMeta: (m) => _abrirFormularioMeta(context, metaEditando: m),
        onExcluirMeta: (m) => _confirmarExcluirMeta(context, m),
      ),
      PerfilScreen(
        nome: _nomeJogador,
        nivel: _nivel,
        xpPercentual: _xpPercentual,
        hpPercentual: _hpPercentual,
        onEditarNome: _editarNome,
        fotoPerfilBase64: _fotoPerfilBase64,
        onTocarFoto: () => _abrirMenuFotoPerfil(context),
        medalhas: calcularMedalhas(
          transacoesCount: _transacoes.length,
          categoriasCount: _categorias.length,
          metasCount: _metas.length,
          metasConcluidasCount: _metas.where((m) => m.concluida).length,
          nivel: _nivel,
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(_titulos[_abaAtual]),
        actions: _abaAtual == 0
            ? [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Center(
                    child: ProgressRings(xpPercentual: _xpPercentual, hpPercentual: _hpPercentual),
                  ),
                ),
              ]
            : null,
      ),
      body: IndexedStack(index: _abaAtual, children: telas),
      floatingActionButton: _abaAtual == 0
          ? FloatingActionButton(
              onPressed: () => _abrirFormularioTransacao(context),
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