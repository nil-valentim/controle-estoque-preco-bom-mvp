import 'package:flutter/foundation.dart';

import '../models/produto.dart';
import '../services/produto_servico.dart';

class ProdutoProvider extends ChangeNotifier {
  final ProdutoServico _servico;

  ProdutoProvider({ProdutoServico? servico})
      : _servico = servico ?? ProdutoServico();

  List<Produto> _produtos = [];
  List<Produto> get produtos => List.unmodifiable(_produtos);

  Future<void> carregar() async {
    _produtos = await _servico.listar();
    notifyListeners();
  }

  Future<String?> cadastrar({
    required String nome,
    required String categoria,
    required String unidadeMedida,
    required String quantidadeInicial,
    required String estoqueMinimo,
  }) async {
    final erro = await _servico.cadastrar(
      nome: nome,
      categoria: categoria,
      unidadeMedida: unidadeMedida,
      quantidadeInicial: quantidadeInicial,
      estoqueMinimo: estoqueMinimo,
    );
    if (erro == null) await carregar();
    return erro;
  }
}