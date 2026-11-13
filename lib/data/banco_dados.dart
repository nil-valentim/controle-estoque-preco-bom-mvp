import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class BancoDados {
  static final BancoDados instancia = BancoDados._();
  BancoDados._();

  Database? _db;

  Future<Database> get banco async {
    _db ??= await _abrir();
    return _db!;
  }

  Future<Database> _abrir() async {
    final caminho = join(await getDatabasesPath(), 'estoque.db');
    return openDatabase(
      caminho,
      version: 1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: (db, versao) async {
        await db.execute('''
          CREATE TABLE produto (
            id_produto INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            categoria TEXT NOT NULL,
            quantidade_estoque INTEGER NOT NULL CHECK (quantidade_estoque >= 0),
            unidade_medida TEXT NOT NULL,
            data_validade TEXT,
            estoque_minimo INTEGER NOT NULL CHECK (estoque_minimo >= 0),
            ativo INTEGER NOT NULL DEFAULT 1
          )
        ''');
        await db.execute('''
          CREATE TABLE movimentacao_estoque (
            id_movimentacao INTEGER PRIMARY KEY AUTOINCREMENT,
            id_produto INTEGER NOT NULL,
            tipo_movimentacao TEXT NOT NULL CHECK (tipo_movimentacao IN ('ENTRADA', 'SAÍDA')),
            quantidade INTEGER NOT NULL CHECK (quantidade > 0),
            data_movimentacao TEXT NOT NULL,
            observacao TEXT,
            FOREIGN KEY (id_produto) REFERENCES produto (id_produto)
          )
        ''');
      },
    );
  }
}