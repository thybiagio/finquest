import 'package:flutter/material.dart';

/// Abre um menu simples de Editar/Excluir, acionado por long-press em um item.
Future<void> mostrarMenuEditarExcluir(
  BuildContext context, {
  required VoidCallback onEditar,
  required VoidCallback onExcluir,
}) async {
  await showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (context) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Editar'),
              onTap: () {
                Navigator.of(context).pop();
                onEditar();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Excluir', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.of(context).pop();
                onExcluir();
              },
            ),
          ],
        ),
      );
    },
  );
}

/// Pede confirmação antes de excluir algo. Retorna true se o usuário confirmou.
Future<bool> confirmarExclusao(BuildContext context, {required String mensagem}) async {
  final confirmado = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Excluir?'),
      content: Text(mensagem),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Excluir'),
        ),
      ],
    ),
  );
  return confirmado ?? false;
}