import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/movimentacao_provider.dart';
import '../providers/produto_provider.dart';

class MovimentarEstoqueTela extends StatefulWidget {
  const MovimentarEstoqueTela({super.key});

  @override
  State<MovimentarEstoqueTela> createState() => _MovimentarEstoqueTelaState();
}

class _MovimentarEstoqueTelaState extends State<MovimentarEstoqueTela> {
  final _quantidade = TextEditingController();
  final _observacao = TextEditingController();
  int? _idProduto;
  String _tipo = 'ENTRADA';
  String? _erro;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProdutoProvider>().carregar();
    });
  }

  @override
  void dispose() {
    _quantidade.dispose();
    _observacao.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    final erro = await context.read<MovimentacaoProvider>().registrar(
          idProduto: _idProduto,
          tipo: _tipo,
          quantidade: _quantidade.text,
          observacao: _observacao.text,
        );
    if (!mounted) return;
    setState(() => _erro = erro);
    if (erro == null) {
      await context.read<ProdutoProvider>().carregar();
      if (!mounted) return;
      _quantidade.clear();
      _observacao.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Movimentação registrada com sucesso')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final produtos = context.watch<ProdutoProvider>().produtos;
    final selecionados = produtos.where((p) => p.id == _idProduto).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Movimentar estoque')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('* campo obrigatório'),
            const SizedBox(height: 12),
            if (produtos.isEmpty)
              const Text('Nenhum produto cadastrado. Cadastre um produto primeiro.')
            else
              DropdownButtonFormField<int>(
                initialValue: _idProduto,
                decoration: const InputDecoration(
                  labelText: 'Produto *',
                  border: OutlineInputBorder(),
                ),
                items: produtos
                    .map((p) => DropdownMenuItem<int>(
                          value: p.id,
                          child: Text(p.nome),
                        ))
                    .toList(),
                onChanged: (valor) => setState(() => _idProduto = valor),
              ),
            if (selecionados.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Saldo atual: ${selecionados.first.quantidadeEstoque} ${selecionados.first.unidadeMedida}',
                ),
              ),
            const SizedBox(height: 16),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: 'ENTRADA',
                  label: Text('Entrada'),
                  icon: Icon(Icons.add_circle_outline),
                ),
                ButtonSegment(
                  value: 'SAÍDA',
                  label: Text('Saída'),
                  icon: Icon(Icons.remove_circle_outline),
                ),
              ],
              selected: {_tipo},
              onSelectionChanged: (valor) =>
                  setState(() => _tipo = valor.first),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _quantidade,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantidade *',
                helperText: 'Informe um número maior que zero.',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _observacao,
              decoration: const InputDecoration(
                labelText: 'Observação',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            if (_erro != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _erro!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            FilledButton.icon(
              onPressed: _salvar,
              icon: const Icon(Icons.save),
              label: const Text('Salvar movimentação'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
              ),
            ),
          ],
        ),
      ),
    );
  }
}