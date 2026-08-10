import 'package:flutter/material.dart';
import '../models/meta.dart';
import '../widgets/meta_card.dart';

class MetasContent extends StatefulWidget {
  const MetasContent({
    super.key,
    required this.metas,
    required this.onAdicionarMeta,
  });

  final List<Meta> metas;
  final ValueChanged<Meta> onAdicionarMeta;

  @override
  State<MetasContent> createState() => _MetasContentState();
}

class _MetasContentState extends State<MetasContent> {
  Future<void> _abrirFormularioNovaMeta(BuildContext context) async {
    final tituloController = TextEditingController();
    final valorController = TextEditingController();

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
              const Text('Nova meta', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

                    widget.onAdicionarMeta(
                      Meta(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        titulo: titulo,
                        valorAlvo: valorAlvo,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                  child: const Text('Criar meta'),
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
              const Text('Metas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              TextButton(
                onPressed: () => _abrirFormularioNovaMeta(context),
                child: const Text('+ Nova'),
              ),
            ],
          ),
        ),
        Expanded(
          child: widget.metas.isEmpty
              ? const Center(
                  child: Text('Nenhuma meta ainda', style: TextStyle(color: Colors.black45)),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    for (final meta in widget.metas) MetaCard(meta: meta),
                  ],
                ),
        ),
      ],
    );
  }
}