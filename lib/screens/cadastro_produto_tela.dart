import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/produto_provider.dart';

class CadastroProdutoTela extends StatefulWidget {
  const CadastroProdutoTela({super.key});

  @override
  State<CadastroProdutoTela> createState() => _CadastroProdutoTelaState();
}

class _CadastroProdutoTelaState extends State<CadastroProdutoTela> {
  final _nome = TextEditingController();
  final _categoria = TextEditingController();
  final _unidade = TextEditingController();
  final _quantidade = TextEditingController();
  final _minimo = TextEditingController();
  String? _erro;

  @override
  void dispose() {
    _nome.dispose();
    _categoria.dispose();
    _unidade.dispose();
    _quantidade.dispose();
    _minimo.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    final erro = await context.read<ProdutoProvider>().cadastrar(
          nome: _nome.text,
          categoria: _categoria.text,
          unidadeMedida: _unidade.text,
          quantidadeInicial: _quantidade.text,
          estoqueMinimo: _minimo.text,
        );
    if (!mounted) return;
    setState(() => _erro = erro);
    if (erro == null) {
      _nome.clear();
      _categoria.clear();
      _unidade.clear();
      _quantidade.clear();
      _minimo.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produto cadastrado com sucesso')),
      );
    }
  }

  Widget _campo(String rotulo, TextEditingController controlador,
      {bool numerico = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controlador,
        keyboardType: numerico ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: rotulo,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar produto')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('* campo obrigatório'),
            const SizedBox(height: 12),
            _campo('Nome do produto *', _nome),
            _campo('Categoria *', _categoria),
            _campo('Unidade de medida *', _unidade),
            _campo('Quantidade inicial *', _quantidade, numerico: true),
            _campo('Estoque mínimo *', _minimo, numerico: true),
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
              label: const Text('Salvar produto'),
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