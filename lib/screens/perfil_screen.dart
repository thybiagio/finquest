import 'dart:convert';
import 'package:flutter/material.dart';
import '../widgets/progress_rings.dart';
import '../models/rank.dart';
import '../models/medalha.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({
    super.key,
    required this.nome,
    required this.nivel,
    required this.xpPercentual,
    required this.hpPercentual,
    required this.onEditarNome,
    required this.medalhas,
    this.fotoPerfilBase64,
    required this.onTocarFoto,
  });

  final String nome;
  final int nivel;
  final double xpPercentual;
  final double hpPercentual;
  final ValueChanged<String> onEditarNome;
  final List<Medalha> medalhas;
  final String? fotoPerfilBase64;
  final VoidCallback onTocarFoto;

  static const _corXp = Color(0xFFBF5AF2);
  static const _corHp = Color(0xFF30D158);

  Future<void> _abrirEdicaoNome(BuildContext context) async {
    final controller = TextEditingController(text: nome);
    final novoNome = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar nome'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Nome do jogador'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
    if (novoNome != null && novoNome.trim().isNotEmpty) {
      onEditarNome(novoNome.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final rank = rankParaNivel(nivel);
    final desbloqueadas = medalhas.where((m) => m.desbloqueada).length;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: ListView(
        children: [
          const SizedBox(height: 12),
          Center(
            child: GestureDetector(
              onTap: onTocarFoto,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: ProgressRings(xpPercentual: xpPercentual, hpPercentual: hpPercentual),
                  ),
                  Container(
                    width: 104,
                    height: 104,
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [rank.corPrimaria, rank.corSecundaria],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: ClipOval(
                      child: fotoPerfilBase64 != null
                          ? Image.memory(
                              base64Decode(fotoPerfilBase64!),
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            )
                          : Container(
                              color: const Color(0xFF0A84FF),
                              child: const Icon(Icons.person, size: 44, color: Colors.white),
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 100,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0A84FF),
                        shape: BoxShape.circle,
                        border: Border.fromBorderSide(BorderSide(color: Colors.white, width: 2)),
                      ),
                      child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: GestureDetector(
              onTap: () => _abrirEdicaoNome(context),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(nome, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 6),
                  const Icon(Icons.edit, size: 16, color: Colors.black45),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [rank.corPrimaria, rank.corSecundaria]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${rank.nome} · Nível $nivel',
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 28),
          const Text('Progresso', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black54)),
          const SizedBox(height: 10),
          _BarraStat(label: 'XP', percentual: xpPercentual, cor: _corXp),
          const SizedBox(height: 12),
          _BarraStat(label: 'HP', percentual: hpPercentual, cor: _corHp),
          const SizedBox(height: 28),
          Text(
            'Medalhas ($desbloqueadas/${medalhas.length})',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black54),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(16),
            ),
            child: GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 4,
              childAspectRatio: 0.8,
              children: [
                for (final medalha in medalhas) _MedalhaBadge(medalha: medalha),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MedalhaBadge extends StatelessWidget {
  const _MedalhaBadge({required this.medalha});

  final Medalha medalha;

  @override
  Widget build(BuildContext context) {
    final cor = medalha.desbloqueada ? const Color(0xFFFFD60A) : Colors.black26;
    return Tooltip(
      message: '${medalha.nome}\n${medalha.descricao}',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: medalha.desbloqueada ? cor.withValues(alpha: 0.15) : Colors.black.withValues(alpha: 0.05),
              shape: BoxShape.circle,
              border: Border.all(color: cor, width: 2),
            ),
            child: Icon(medalha.icone, color: cor, size: 26),
          ),
          const SizedBox(height: 6),
          Text(
            medalha.nome,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: medalha.desbloqueada ? Colors.black87 : Colors.black38,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _BarraStat extends StatelessWidget {
  const _BarraStat({required this.label, required this.percentual, required this.cor});

  final String label;
  final double percentual;
  final Color cor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
              Text(
                '${(percentual * 100).round()}%',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: cor),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: percentual.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: Colors.black12,
              valueColor: AlwaysStoppedAnimation(cor),
            ),
          ),
        ],
      ),
    );
  }
}