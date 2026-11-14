import 'package:flutter/foundation.dart';

import '../models/movimentacao.dart';
import '../services/movimentacao_servico.dart';

class MovimentacaoProvider extends ChangeNotifier {
  final MovimentacaoServico _servico;

  MovimentacaoProvider({MovimentacaoServico? servico})
      : _servico = servico ?? MovimentacaoServico();

  Future<String?> registrar({
    required int? idProduto,
    required String tipo,
    required String quantidade,
    String? observacao,
  }) {
    return _servico.registrar(
      idProduto: idProduto,
      tipo: tipo,
      quantidade: quantidade,
      observacao: observacao,
    );
  }

  Future<List<Movimentacao>> historico(int idProduto) {
    return _servico.listarHistorico(idProduto);
  }
}