import 'package:flutter_test/flutter_test.dart';
import 'package:controle_estoque/services/movimentacao_servico.dart';
import 'package:controle_estoque/services/produto_servico.dart';

void main() {
  group('Regras de movimentação', () {
    final servico = MovimentacaoServico();

    test('aceita entrada com quantidade válida', () {
      final erro = servico.validar(
        tipo: 'ENTRADA',
        quantidade: '10',
        saldoAtual: 8,
      );
      expect(erro, isNull);
    });

    test('bloqueia saída maior que o saldo', () {
      final erro = servico.validar(
        tipo: 'SAÍDA',
        quantidade: '9',
        saldoAtual: 8,
      );
      expect(erro, contains('Saída maior'));
    });

    test('aceita saída igual ao saldo', () {
      final erro = servico.validar(
        tipo: 'SAÍDA',
        quantidade: '8',
        saldoAtual: 8,
      );
      expect(erro, isNull);
    });

    test('bloqueia quantidade zero', () {
      final erro = servico.validar(
        tipo: 'ENTRADA',
        quantidade: '0',
        saldoAtual: 8,
      );
      expect(erro, isNotNull);
    });

    test('bloqueia quantidade que não é número', () {
      final erro = servico.validar(
        tipo: 'ENTRADA',
        quantidade: 'abc',
        saldoAtual: 8,
      );
      expect(erro, isNotNull);
    });

    test('bloqueia tipo de movimentação inválido', () {
      final erro = servico.validar(
        tipo: 'OUTRO',
        quantidade: '5',
        saldoAtual: 8,
      );
      expect(erro, isNotNull);
    });
  });

  group('Regras de cadastro de produto', () {
    final servico = ProdutoServico();

    test('aceita cadastro com dados válidos', () {
      final erro = servico.validar(
        nome: 'Tomate',
        categoria: 'Hortifruti',
        unidadeMedida: 'kg',
        quantidadeInicial: '8',
        estoqueMinimo: '10',
      );
      expect(erro, isNull);
    });

    test('bloqueia nome vazio', () {
      final erro = servico.validar(
        nome: '   ',
        categoria: 'Hortifruti',
        unidadeMedida: 'kg',
        quantidadeInicial: '8',
        estoqueMinimo: '10',
      );
      expect(erro, isNotNull);
    });

    test('bloqueia quantidade inicial negativa', () {
      final erro = servico.validar(
        nome: 'Tomate',
        categoria: 'Hortifruti',
        unidadeMedida: 'kg',
        quantidadeInicial: '-1',
        estoqueMinimo: '10',
      );
      expect(erro, isNotNull);
    });
  });
}