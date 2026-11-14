# Controle de Estoque Preço Bom

MVP de controle de estoque do Sacolão e Mercearia Preço Bom, feito em Flutter com SQLite.

## Problema

O controle de entrada e saída de mercadorias é manual, o que causa perda de perecíveis e falta de itens essenciais.

## Funções do MVP

- Cadastro de produtos com validação dos campos obrigatórios
- Registro de entrada e saída, com bloqueio de saída maior que o saldo
- Consulta do estoque com alerta de estoque baixo

## Arquitetura

Monolito em camadas, separando telas, regras de negócio e persistência.

- lib/screens: telas
- lib/providers: estado das telas
- lib/services: regras de negócio
- lib/data: acesso ao SQLite
- lib/models: modelos de dados

## Tecnologias

Flutter, Material Design, Provider, SQLite com sqflite e Flutter Test.

## Como executar

1. Instale o Flutter
2. Rode `flutter pub get`
3. Rode `flutter run` com um dispositivo Android conectado

## Testes

Rode `flutter test`.