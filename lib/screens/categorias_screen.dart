import 'package:flutter/material.dart';
import '../models/categoria.dart';
import '../widgets/categoria_card.dart';

class CategoriasScreen extends StatefulWidget { 
  const CategoriasScreen({super.key, required this.categoriasIniciais});

  final List<Categoria> categoriasIniciais;

  @override
  State<CategoriasScreen> createState() => _CategoriasScreenState();
}

class _CategoriasScreenState extends State<CategoriasScreen> {
  late List<Categoria> _categorias;

  @override
  void initState() {
    super.initState();
    _categorias = List.of(widget.categoriasIniciais);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categorias'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
          child: TextButton( 
            onPressed: () {},
            child: const Text('+ Nova'),
          ),
        ),
      ],
    ),
    body: ListView(
      padding: const EdgeInsets.all(16),
        children: [
          for (final categoria in _categorias) CategoriaCard(categoria: categoria),
        ],
      ),
    );
  }
}
      