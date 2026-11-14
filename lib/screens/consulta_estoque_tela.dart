import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/produto.dart';
import '../providers/produto_provider.dart';

class ConsultaEstoqueTela extends StatefulWidget {
  const ConsultaEstoqueTela({super.key});

  @override
  State<ConsultaEstoqueTela> createState() => _ConsultaEstoqueTelaState();
}

class _ConsultaEstoqueTelaState extends State<ConsultaEstoqueTela> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProdutoProvider>().carregar();
    });
  }

  bool _estoqueBaixo(Produto p) => p.quantidadeEstoque <= p.estoqueMinimo;

  Widget _cartao(Produto p) {
    final baixo = _estoqueBaixo(p);
    final cor = baixo ? Colors.orange.shade900 : Colors.green.shade800;

    return Card(
      color: baixo ? Colors.orange.shade50 : null,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: baixo ? Colors.orange.shade700 : Colors.grey.shade400,
          width: baixo ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    p.nome,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  '${p.quantidadeEstoque} ${p.unidadeMedida}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text('Mínimo: ${p.estoqueMinimo} ${p.unidadeMedida}'),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  baixo ? Icons.warning_amber : Icons.check_circle_outline,
                  color: cor,
                ),
                const SizedBox(width: 6),
                Text(
                  baixo ? 'Estoque baixo' : 'Estoque normal',
                  style: TextStyle(color: cor, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final produtos = context.watch<ProdutoProvider>().produtos;
    final qtdBaixo = produtos.where(_estoqueBaixo).length;

    return Scaffold(
      appBar: AppBar(title: const Text('Consultar estoque')),
      body: produtos.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('Nenhum produto cadastrado ainda.'),
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (qtdBaixo > 0)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      border: Border.all(color: Colors.orange.shade700),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning_amber,
                            color: Colors.orange.shade900),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            qtdBaixo == 1
                                ? '1 produto com estoque baixo'
                                : '$qtdBaixo produtos com estoque baixo',
                            style: TextStyle(color: Colors.orange.shade900),
                          ),
                        ),
                      ],
                    ),
                  ),
                ...produtos.map(_cartao),
              ],
            ),
    );
  }
}