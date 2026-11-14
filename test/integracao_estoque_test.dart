import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:controle_estoque/models/produto.dart';
import 'package:controle_estoque/services/movimentacao_servico.dart';
import 'package:controle_estoque/services/produto_servico.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  final produtos = ProdutoServico();
  final movimentos = MovimentacaoServico();

  setUpAll(() async {
    final caminho = join(await getDatabasesPath(), 'estoque.db');
    await deleteDatabase(caminho);
  });

  Future<Produto> buscar(String nome) async {
    final lista = await produtos.listar();
    return lista.firstWhere((p) => p.nome == nome);
  }

  test('fluxo completo: cadastro, entrada, saída e bloqueio', () async {
    final erroCadastro = await produtos.cadastrar(
      nome: 'Tomate',
      categoria: 'Hortifruti',
      unidadeMedida: 'kg',
      quantidadeInicial: '8',
      estoqueMinimo: '10',
    );
    expect(erroCadastro, isNull);

    var tomate = await buscar('Tomate');
    expect(tomate.quantidadeEstoque, 8);

    final erroEntrada = await movimentos.registrar(
      idProduto: tomate.id,
      tipo: 'ENTRADA',
      quantidade: '10',
      observacao: 'Entrega do fornecedor',
    );
    expect(erroEntrada, isNull);
    tomate = await buscar('Tomate');
    expect(tomate.quantidadeEstoque, 18);

    final erroSaida = await movimentos.registrar(
      idProduto: tomate.id,
      tipo: 'SAÍDA',
      quantidade: '5',
    );
    expect(erroSaida, isNull);
    tomate = await buscar('Tomate');
    expect(tomate.quantidadeEstoque, 13);

    final erroBloqueio = await movimentos.registrar(
      idProduto: tomate.id,
      tipo: 'SAÍDA',
      quantidade: '100',
    );
    expect(erroBloqueio, contains('Saída maior'));
    tomate = await buscar('Tomate');
    expect(tomate.quantidadeEstoque, 13);
  });

  test('movimentação de produto que não existe retorna erro', () async {
    final erro = await movimentos.registrar(
      idProduto: 9999,
      tipo: 'ENTRADA',
      quantidade: '1',
    );
    expect(erro, 'Produto não encontrado.');
  });
}