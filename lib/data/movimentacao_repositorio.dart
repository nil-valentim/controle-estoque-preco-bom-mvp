import '../models/movimentacao.dart';
import 'banco_dados.dart';

class MovimentacaoRepositorio {
  Future<int?> saldoDoProduto(int idProduto) async {
    final db = await BancoDados.instancia.banco;
    final linhas = await db.query(
      'produto',
      columns: ['quantidade_estoque'],
      where: 'id_produto = ?',
      whereArgs: [idProduto],
    );
    if (linhas.isEmpty) return null;
    return linhas.first['quantidade_estoque'] as int;
  }

  Future<void> registrar(Movimentacao movimentacao, int novoSaldo) async {
    final db = await BancoDados.instancia.banco;
    await db.transaction((txn) async {
      await txn.insert('movimentacao_estoque', movimentacao.toMap());
      await txn.update(
        'produto',
        {'quantidade_estoque': novoSaldo},
        where: 'id_produto = ?',
        whereArgs: [movimentacao.idProduto],
      );
    });
  }

  Future<List<Movimentacao>> listarPorProduto(int idProduto) async {
    final db = await BancoDados.instancia.banco;
    final linhas = await db.query(
      'movimentacao_estoque',
      where: 'id_produto = ?',
      whereArgs: [idProduto],
      orderBy: 'data_movimentacao DESC',
    );
    return linhas.map(Movimentacao.fromMap).toList();
  }
}