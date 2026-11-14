class Produto {
  final int? id;
  final String nome;
  final String categoria;
  final int quantidadeEstoque;
  final String unidadeMedida;
  final String? dataValidade;
  final int estoqueMinimo;
  final bool ativo;

  Produto({
    this.id,
    required this.nome,
    required this.categoria,
    required this.quantidadeEstoque,
    required this.unidadeMedida,
    this.dataValidade,
    required this.estoqueMinimo,
    this.ativo = true,
  });

  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id_produto': id,
      'nome': nome,
      'categoria': categoria,
      'quantidade_estoque': quantidadeEstoque,
      'unidade_medida': unidadeMedida,
      'data_validade': dataValidade,
      'estoque_minimo': estoqueMinimo,
      'ativo': ativo ? 1 : 0,
    };
  }

  factory Produto.fromMap(Map<String, Object?> mapa) {
    return Produto(
      id: mapa['id_produto'] as int?,
      nome: mapa['nome'] as String,
      categoria: mapa['categoria'] as String,
      quantidadeEstoque: mapa['quantidade_estoque'] as int,
      unidadeMedida: mapa['unidade_medida'] as String,
      dataValidade: mapa['data_validade'] as String?,
      estoqueMinimo: mapa['estoque_minimo'] as int,
      ativo: (mapa['ativo'] as int) == 1,
    );
  }
}