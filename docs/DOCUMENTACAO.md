# Documentação técnica — PetAgenda

## Objetivo e escopo

Organizar os dados dos pets e uma agenda com histórico de cuidados. O projeto demonstra navegação entre telas, formulários, operações CRUD e persistência em banco relacional local.

## Telas e navegação

| Tela/classe | Função | Destino |
| --- | --- | --- |
| `InicioPage` | Conta pets cadastrados | `PetsPage` |
| `PetsPage` | Lista pets e oferece editar/excluir | `CadastroPetPage`, `CuidadosPage` |
| `CadastroPetPage` | Cadastra ou edita dados | Retorna à lista |
| `CuidadosPage` | Lista cuidados e altera situação | `CadastroCuidadoPage` |
| `CadastroCuidadoPage` | Cadastra ou edita cuidado | Retorna à agenda |

São cinco telas principais; os formulários são reutilizados para edição. `Navigator.push` abre telas e `Navigator.pop(context, true)` comunica uma gravação bem-sucedida. A tela anterior consulta novamente o banco ao receber esse retorno.

## Estrutura e estado

A interface usa widgets Material 3. `StatefulWidget` mantém registros carregados, seleção do formulário e indicadores de carregamento. Operações assíncronas usam `Future` e `await`. Verificações de `mounted` evitam atualizar uma tela já descartada. `try/catch` apresenta falhas ao usuário. Flags de gravação desabilitam o botão de salvar durante a operação. Controladores de texto são liberados em `dispose`.

A separação é simples: `main.dart` concentra tema e pets; `cuidados_page.dart` concentra os cuidados; `banco_dados.dart` centraliza abertura e esquema. As telas consultam diretamente o SQLite; não há camada de repositório separada nesta versão.

## Banco de dados

Arquivo: `petagenda.db`. Versão do esquema: 1. `BancoDados.instancia` é compartilhado entre telas; `_abrindo` permite compartilhar uma abertura em andamento. `getDatabasesPath` encontra o diretório do banco e `join` monta o caminho.

### Tabela pets

| Coluna | Tipo | Regra |
| --- | --- | --- |
| id | INTEGER | Chave primária autoincrementada |
| nome | TEXT | Obrigatório |
| especie | TEXT | Obrigatória |
| raca | TEXT | Obrigatória no banco, padrão vazio; opcional na interface |
| nascimento | TEXT | Aceita nulo; formato AAAA-MM-DD |

### Tabela cuidados

| Coluna | Tipo | Regra |
| --- | --- | --- |
| id | INTEGER | Chave primária autoincrementada |
| pet_id | INTEGER | Obrigatório; referência a pets.id |
| tipo | TEXT | Obrigatório |
| descricao | TEXT | Obrigatória |
| data | TEXT | Obrigatória; formato AAAA-MM-DD |
| concluido | INTEGER | 0 ou 1; padrão 0 |
| observacoes | TEXT | Padrão vazio; opcional na interface |

Relacionamento: um pet possui zero ou muitos cuidados. Cada cuidado pertence a um pet. `PRAGMA foreign_keys = ON` ativa a integridade referencial, e `ON DELETE CASCADE` remove os cuidados quando o pet é excluído. Editar o pet usa `UPDATE` preservando seu ID e vínculos.

As operações usam `insert`, `query`, `update` e `delete`. Os filtros com `whereArgs` passam valores separadamente do SQL. O total inicial usa `SELECT COUNT(*)`. Os cuidados são filtrados por `pet_id`; atualização e exclusão de cuidado também incluem o ID do próprio registro.

## Regras da interface

- Nome do pet e descrição do cuidado não podem ficar vazios ou conter apenas espaços.
- Espécies disponíveis: Cachorro, Gato, Ave, Coelho e Outro.
- Nascimento é opcional e o seletor permite de 1900 até o dia atual.
- Tipos de cuidado: Vacina, Consulta, Banho e tosa e Outro.
- Data do cuidado pode ser passada ou futura, entre 1900 e 2100.
- Datas são armazenadas sem horário e apresentadas como DD/MM/AAAA.
- Novos cuidados começam pendentes; editar preserva a situação.
- Pendentes aparecem antes de concluídos; dentro dos grupos, por data crescente e ID crescente.
- Pendente com data anterior ao dia atual recebe destaque de data passada.
- Exclusões exigem confirmação. Cancelar preserva o registro.

## Limitações e evolução

Sem notificações, autenticação, nuvem, backup ou criptografia própria. Não há testes automatizados de SQLite nesta versão. Pastas de outras plataformas são estruturas geradas pelo Flutter; o funcionamento foi validado em Android. Uma mudança no esquema precisa incrementar a versão e implementar migração com `onUpgrade`, sem apagar o banco existente.

Possíveis evoluções: notificações, exportação/importação, fotos dos pets, testes de banco e separação de repositórios. Estas são propostas, não funcionalidades entregues.
