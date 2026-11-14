import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/movimentacao.dart';
import '../models/produto.dart';
import '../providers/movimentacao_provider.dart';

class HistoricoTela extends StatelessWidget {
  final Produto produto;

  const HistoricoTela({super.key, required this.produto});

  String _data(DateTime d) {
    String dois(int n) => n.toString().padLeft(2, '0');
    return '${dois(d.day)}/${dois(d.month)}/${d.year} ${dois(d.hour)}:${dois(d.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Histórico — ${produto.nome}')),
      body: FutureBuilder<List<Movimentacao>>(
        future: context.read<MovimentacaoProvider>().historico(produto.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Não foi possível carregar o histórico.'),
            );
          }
          final lista = snapshot.data ?? [];
          if (lista.isEmpty) {
            return const Center(child: Text('Nenhuma movimentação registrada.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: lista.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final m = lista[index];
              final entrada = m.tipo == 'ENTRADA';
              final obs = m.observacao;
              return Card(
                child: ListTile(
                  leading: Icon(
                    entrada
                        ? Icons.add_circle_outline
                        : Icons.remove_circle_outline,
                  ),
                  title: Text(
                    '${entrada ? 'Entrada' : 'Saída'}: ${m.quantidade} ${produto.unidadeMedida}',
                  ),
                  subtitle: Text(
                    obs == null ? _data(m.data) : '${_data(m.data)}\n$obs',
                  ),
                  isThreeLine: obs != null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}