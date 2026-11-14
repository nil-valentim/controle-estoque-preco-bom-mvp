class Movimentacao {
  final int? id;
  final int idProduto;
  final String tipo;
  final int quantidade;
  final DateTime data;
  final String? observacao;

  Movimentacao({
    this.id,
    required this.idProduto,
    required this.tipo,
    required this.quantidade,
    required this.data,
    this.observacao,
  });

  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id_movimentacao': id,
      'id_produto': idProduto,
      'tipo_movimentacao': tipo,
      'quantidade': quantidade,
      'data_movimentacao': data.toIso8601String(),
      'observacao': observacao,
    };
  }

  factory Movimentacao.fromMap(Map<String, Object?> mapa) {
    return Movimentacao(
      id: mapa['id_movimentacao'] as int?,
      idProduto: mapa['id_produto'] as int,
      tipo: mapa['tipo_movimentacao'] as String,
      quantidade: mapa['quantidade'] as int,
      data: DateTime.parse(mapa['data_movimentacao'] as String),
      observacao: mapa['observacao'] as String?,
    );
  }
}