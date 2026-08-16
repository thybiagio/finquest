import 'package:flutter/material.dart';
import '../models/categoria.dart';
import '../widgets/categoria_card.dart';
import '../widgets/grouped_card.dart';

class CategoriasContent extends StatelessWidget {
  const CategoriasContent({
    super.key,
    required this.categorias,
    required this.onNovaCategoria,
    required this.onEditarCategoria,
    required this.onExcluirCategoria,
  });

  final List<Categoria> categorias;
  final VoidCallback onNovaCategoria;
  final ValueChanged<Categoria> onEditarCategoria;
  final ValueChanged<Categoria> onExcluirCategoria;

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
                onPressed: onNovaCategoria,
                child: const Text('+ Nova'),
              ),
            ],
          ),
        ),
        Expanded(
          child: categorias.isEmpty
              ? const Center(
                  child: Text('Nenhuma categoria ainda', style: TextStyle(color: Colors.black45)),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
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
                  ],
                ),
        ),
      ],
    );
  }
}