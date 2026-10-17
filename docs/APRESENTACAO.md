# Roteiro de apresentação — PetAgenda

## Apresentação sugerida (5 a 7 minutos)

1. **Objetivo:** “O PetAgenda organiza os pets e seus cuidados em um aplicativo mobile com Flutter, Dart e banco SQLite local.”
2. **Início:** mostrar a identidade verde e roxa e o contador de pets.
3. **Pets:** cadastrar um pet de demonstração; mostrar listagem, edição e validação de nome obrigatório.
4. **Cuidados:** abrir a agenda desse pet; cadastrar um compromisso, editar a descrição e marcar como concluído.
5. **Persistência:** fechar o aplicativo e reabrir pelo ícone para mostrar os dados preservados.
6. **Código:** abrir os arquivos abaixo e explicar o que cada um faz.
7. **Conclusão:** mencionar que a versão atual funciona localmente e que notificações e backup são evoluções futuras.

## Código para mostrar no VS Code

| Arquivo | O que explicar |
| --- | --- |
| `lib/main.dart` | `runApp`, tema, `Navigator`, formulários e cadastro/edição de pets |
| `lib/banco_dados.dart` | Tabelas, chave estrangeira e exclusão em cascata |
| `lib/cuidados_page.dart` | Filtro por pet, cadastro/edição e conclusão |
| `test/widget_test.dart` | Verificação automatizada da tela inicial |

A pasta correta é aquela que contém `pubspec.yaml`. Abra a pasta inteira no VS Code, não apenas um arquivo isolado.

## Perguntas para treinar

**Qual é o banco?** SQLite local, acessado pelo pacote sqflite.

**Tem mais de uma tela?** Sim: início, pets, formulário de pet, agenda de cuidados e formulário de cuidado.

**O que é CRUD?** Criar, consultar, atualizar e excluir registros. O app faz essas operações com pets e cuidados.

**Como os cuidados pertencem ao pet?** A coluna `pet_id` referencia `pets.id`.

**Por que os dados permanecem?** São gravados no arquivo SQLite; a interface consulta esse arquivo ao abrir.

**O que acontece ao excluir um pet?** Após confirmação, o banco exclui também os cuidados dele pela regra `ON DELETE CASCADE`.

**Envia notificações?** Não. A versão atual organiza e destaca os registros dentro do aplicativo.

**O teste cobre tudo?** Não. O teste automatizado cobre a apresentação inicial; os principais fluxos foram testados manualmente no Android.

## Antes da apresentação

Carregar o telefone, autorizar depuração USB se for demonstrar pelo computador, abrir o projeto, rodar as verificações e preparar dados fictícios. Não desinstalar nem limpar os dados do aplicativo que contém os registros da demonstração.
