import 'package:flutter/material.dart';
import '../models/categoria.dart';
import 'long_press_action_menu.dart';

/// Uma linha de categoria, pensada para ser usada dentro de um GroupedCard.
/// Segurar o item abre o menu de Editar/Excluir.
class CategoriaCard extends StatelessWidget {
  const CategoriaCard({
    super.key,
    required this.categoria,
    required this.onEditar,
    required this.onExcluir,
  });

  final Categoria categoria;
  final VoidCallback onEditar;
  final VoidCallback onExcluir;

  @override
  Widget build(BuildContext context) {
    final cor = categoria.estourouOrcamento ? Colors.red : Colors.green;

    return GestureDetector(
      onLongPress: () => mostrarMenuEditarExcluir(
        context,
        onEditar: onEditar,
        onExcluir: onExcluir,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  categoria.nome,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                Text(
                  'R\$ ${categoria.gastoAtual.toStringAsFixed(0)} / R\$ ${categoria.orcamentoMensal.toStringAsFixed(0)}',
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: categoria.percentualUsado,
                minHeight: 8,
                backgroundColor: Colors.black12,
                valueColor: AlwaysStoppedAnimation<Color>(cor),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              categoria.estourouOrcamento ? 'Acima do orçamento' : 'Dentro do orçamento',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: cor),
            ),
          ],
        ),
      ),
    );
  }
}