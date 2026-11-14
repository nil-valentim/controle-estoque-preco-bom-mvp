import 'package:flutter/material.dart';

import 'cadastro_produto_tela.dart';
import 'consulta_estoque_tela.dart';
import 'movimentar_estoque_tela.dart';

class MenuTela extends StatelessWidget {
  const MenuTela({super.key});

  Widget _botao(BuildContext context, String texto, IconData icone, Widget tela) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: FilledButton.icon(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => tela),
        ),
        icon: Icon(icone),
        label: Text(texto),
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(64),
          textStyle: const TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Controle de Estoque — Preço Bom',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 32),
              _botao(context, 'Cadastrar produto', Icons.inventory_2,
                  const CadastroProdutoTela()),
              _botao(context, 'Movimentar estoque', Icons.swap_horiz,
                  const MovimentarEstoqueTela()),
              _botao(context, 'Consultar estoque', Icons.list_alt,
                  const ConsultaEstoqueTela()),
            ],
          ),
        ),
      ),
    );
  }
}