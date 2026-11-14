
import '../data/produto_repositorio.dart';
import '../models/produto.dart';

class ProdutoServico {
  final ProdutoRepositorio _repositorio;

  ProdutoServico({ProdutoRepositorio? repositorio})
      : _repositorio = repositorio ?? ProdutoRepositorio();

  String? validar({
    required String nome,
    required String categoria,
    required String unidadeMedida,
    required String quantidadeInicial,
    required String estoqueMinimo,
  }) {
    if (nome.trim().isEmpty) return 'Informe o nome do produto.';
    if (categoria.trim().isEmpty) return 'Informe a categoria.';
    if (unidadeMedida.trim().isEmpty) return 'Informe a unidade de medida.';

    final quantidade = int.tryParse(quantidadeInicial.trim());
    if (quantidade == null || quantidade < 0) {
      return 'Informe uma quantidade inicial válida, sem números negativos.';
    }

    final minimo = int.tryParse(estoqueMinimo.trim());
    if (minimo == null || minimo < 0) {
      return 'Informe um estoque mínimo igual ou maior que zero.';
    }

    return null;
  }

  Future<String?> cadastrar({
    required String nome,
    required String categoria,
    required String unidadeMedida,
    required String quantidadeInicial,
    required String estoqueMinimo,
  }) async {
    final erro = validar(
      nome: nome,
      categoria: categoria,
      unidadeMedida: unidadeMedida,
      quantidadeInicial: quantidadeInicial,
      estoqueMinimo: estoqueMinimo,
    );
    if (erro != null) return erro;

    await _repositorio.inserir(
      Produto(
        nome: nome.trim(),
        categoria: categoria.trim(),
        quantidadeEstoque: int.parse(quantidadeInicial.trim()),
        unidadeMedida: unidadeMedida.trim(),
        estoqueMinimo: int.parse(estoqueMinimo.trim()),
      ),
    );
    return null;
  }

  Future<List<Produto>> listar() => _repositorio.listar();
}