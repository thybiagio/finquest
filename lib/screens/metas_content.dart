import 'package:flutter/material.dart';
import '../models/meta.dart';
import '../widgets/meta_card.dart';
import '../widgets/grouped_card.dart';

class MetasContent extends StatelessWidget {
  const MetasContent({
    super.key,
    required this.metas,
    required this.onNovaMeta,
    required this.onEditarMeta,
    required this.onExcluirMeta,
  });

  final List<Meta> metas;
  final VoidCallback onNovaMeta;
  final ValueChanged<Meta> onEditarMeta;
  final ValueChanged<Meta> onExcluirMeta;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Metas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: onNovaMeta,
                child: const Text('+ Nova'),
              ),
            ],
          ),
        ),
        Expanded(
          child: metas.isEmpty
              ? const Center(
                  child: Text('Nenhuma meta ainda', style: TextStyle(color: Colors.black45)),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    GroupedCard(
                      children: [
                        for (final meta in metas)
                          MetaCard(
                            meta: meta,
                            onEditar: () => onEditarMeta(meta),
                            onExcluir: () => onExcluirMeta(meta),
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