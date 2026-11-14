import '../models/produto.dart';
import 'banco_dados.dart';

class ProdutoRepositorio {
  Future<int> inserir(Produto produto) async {
    final db = await BancoDados.instancia.banco;
    return db.insert('produto', produto.toMap());
  }

  Future<List<Produto>> listar() async {
    final db = await BancoDados.instancia.banco;
    final linhas = await db.query(
      'produto',
      where: 'ativo = ?',
      whereArgs: [1],
      orderBy: 'nome',
    );
    return linhas.map(Produto.fromMap).toList();
  }
}