import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/produto_provider.dart';
import 'screens/cadastro_produto_tela.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProdutoProvider(),
      child: MaterialApp(
        title: 'Controle de Estoque — Preço Bom',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(colorSchemeSeed: Colors.green, useMaterial3: true),
        home: const CadastroProdutoTela(),
      ),
    );
  }
}