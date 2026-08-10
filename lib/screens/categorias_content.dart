import 'package:flutter/material.dart';
import '../models/categoria.dart';
import '../widgets/categoria_card.dart';

class CategoriasContent extends StatefulWidget {
  const CategoriasContent({
    super.key,
    required this.categorias,
    required this.onAdicionarCategoria,
  });

  final List<Categoria> categorias;
  final ValueChanged<Categoria> onAdicionarCategoria;

  @override
  State<CategoriasContent> createState() => _CategoriasContentState();
}

class _CategoriasContentState extends State<CategoriasContent> {
  Future<void> _abrirFormularioNovaCategoria(BuildContext context) async {
    final nomeController = TextEditingController();
    final orcamentoController = TextEditingController();

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
              const Text('Nova categoria', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

                    widget.onAdicionarCategoria(
                      Categoria(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        nome: nome,
                        corHex: '#0A84FF',
                        orcamentoMensal: orcamento,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                  child: const Text('Criar categoria'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Categorias', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () => _abrirFormularioNovaCategoria(context),
                child: const Text('+ Nova'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              for (final categoria in widget.categorias) CategoriaCard(categoria: categoria),
            ],
          ),
        ),
      ],
    );
  }
}