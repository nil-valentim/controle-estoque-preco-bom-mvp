import '../data/movimentacao_repositorio.dart';
import '../models/movimentacao.dart';

class MovimentacaoServico {
  final MovimentacaoRepositorio _repositorio;

  MovimentacaoServico({MovimentacaoRepositorio? repositorio})
      : _repositorio = repositorio ?? MovimentacaoRepositorio();

  String? validar({
    required String tipo,
    required String quantidade,
    required int saldoAtual,
  }) {
    if (tipo != 'ENTRADA' && tipo != 'SAÍDA') {
      return 'Escolha entrada ou saída.';
    }

    final qtd = int.tryParse(quantidade.trim());
    if (qtd == null || qtd <= 0) {
      return 'Informe uma quantidade válida, maior que zero.';
    }

    if (tipo == 'SAÍDA' && qtd > saldoAtual) {
      return 'Saída maior que o estoque disponível. Saldo atual: $saldoAtual.';
    }

    return null;
  }

  Future<String?> registrar({
    required int? idProduto,
    required String tipo,
    required String quantidade,
    String? observacao,
  }) async {
    if (idProduto == null) return 'Escolha um produto.';

    final saldo = await _repositorio.saldoDoProduto(idProduto);
    if (saldo == null) return 'Produto não encontrado.';

    final erro = validar(tipo: tipo, quantidade: quantidade, saldoAtual: saldo);
    if (erro != null) return erro;

    final qtd = int.parse(quantidade.trim());
    final novoSaldo = tipo == 'ENTRADA' ? saldo + qtd : saldo - qtd;
    final obs = observacao?.trim();

    await _repositorio.registrar(
      Movimentacao(
        idProduto: idProduto,
        tipo: tipo,
        quantidade: qtd,
        data: DateTime.now(),
        observacao: (obs == null || obs.isEmpty) ? null : obs,
      ),
      novoSaldo,
    );
    return null;
  }
}