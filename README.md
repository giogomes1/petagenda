# 🐾 PetAgenda

2. SUGESTAO DO QUE FALAR

"Este projeto se chama PetAgenda. A ideia e ajudar a pessoa a organizar seus
animais de estimacao e lembrar dos cuidados de cada um. Eu desenvolvi o
aplicativo em Flutter, usando a linguagem Dart. A interface usa componentes
Material 3 e tem cores roxa e verde.

Na tela inicial, o aplicativo mostra o acesso aos pets e a quantidade
cadastrada. Na lista de pets, posso cadastrar, editar e excluir um animal.
Cada pet tem uma agenda propria. Nela posso cadastrar cuidados como vacina,
consulta, banho e tosa ou outro compromisso, informar a data e observacoes,
editar o registro e marcar como concluido ou pendente.

Para salvar as informacoes, usei SQLite. Existem duas tabelas: pets e
cuidados. A tabela de cuidados guarda o identificador do pet ao qual pertence.
Assim, cada agenda mostra somente os cuidados daquele pet. Se um pet for
excluido, o banco tambem remove os cuidados relacionados, depois de uma
confirmacao na tela.

Os formularios validam campos obrigatorios. As datas sao guardadas no formato
AAAA-MM-DD e apresentadas ao usuario no formato brasileiro DD/MM/AAAA. Os
cuidados pendentes aparecem antes dos concluidos, e os que estao com a data
passada recebem um destaque.

O banco e local, entao nao ha conta, sincronizacao pela internet, notificacoes
ou backup automatico nesta versao. No navegador, os dados ficam no
armazenamento daquele navegador e endereco local. Como melhoria futura,
poderiam ser adicionados lembretes, backup e sincronizacao."


4. ARQUIVOS PARA MOSTRAR NO VS CODE

Comece por estes tres arquivos, nesta ordem:

- lib/main.dart
  Mostre a funcao main, que inicia o aplicativo, o tema visual e as telas
  relacionadas aos pets. Explique que a classe InicioPage mostra a entrada e
  que PetsPage lista, cadastra, edita e exclui os animais. Os formularios sao
  usados tanto para criar quanto para editar.

- lib/banco_dados.dart
  Este e o principal arquivo para explicar o banco de dados. Mostre a criacao
  das tabelas pets e cuidados, o campo pet_id e a chave estrangeira. Explique
  que ON DELETE CASCADE remove os cuidados vinculados quando um pet e excluido.
  A classe BancoDados compartilha a abertura do banco entre as telas.

- lib/cuidados_page.dart
  Mostre como a agenda recebe o identificador do pet e consulta somente os
  cuidados dele. Explique cadastro, edicao, exclusao, ordenacao por situacao e
  data, e a opcao de marcar um cuidado como concluido.

5. CONCEITOS QUE PODEM SER PERGUNTADOS

O que significa CRUD?
Sao as operacoes de criar, consultar, atualizar e excluir dados.

O que e Flutter e o que e Dart?
Flutter e o framework usado para construir a interface e executar o app em
mais de uma plataforma. Dart e a linguagem de programacao usada neste projeto.

O que e um widget?
Widget e uma peca da interface do Flutter. Textos, botoes, espacamentos e
telas sao montados combinando widgets.

Qual e a diferenca entre StatelessWidget e StatefulWidget?
StatelessWidget e usado quando o widget nao precisa manter estado mutavel
proprio. StatefulWidget e usado quando a tela precisa atualizar dados, por
exemplo, quando carrega a lista ou altera um cuidado.

O que fazem main e runApp?
main e o ponto de entrada do programa. runApp inicia a arvore de widgets e
mostra o widget principal PetAgendaApp.

Para que serve MaterialApp?
MaterialApp configura elementos gerais do app, como tema e tela inicial.

O que e Navigator?
Navigator controla a navegacao entre telas. Navigator.push abre uma tela e
Navigator.pop volta para a anterior. O formulario pode devolver um resultado
para a lista saber que precisa carregar os dados novamente.

O que significam async, Future e await?
Operacoes como ler ou gravar no banco podem demorar. async indica que uma
funcao executa trabalho assincrono e retorna um Future. await espera a
operacao terminar sem bloquear a interface durante esse tempo.

Para que serve setState?
setState informa ao Flutter que o estado da tela mudou e que a interface deve
ser desenhada novamente com os valores atualizados.

Por que o codigo verifica mounted?
Uma consulta pode terminar depois que o usuario ja saiu da tela. mounted
verifica se o widget ainda esta ativo antes de atualizar a interface.

Para que servem try e catch?
Eles tratam erros de operacoes como acessar o banco. Se uma operacao falha,
o app pode mostrar uma mensagem em vez de agir como se tivesse dado certo.

O que e SQLite?
E um banco de dados relacional que armazena informacoes em tabelas. Neste app,
ele guarda os pets e os cuidados.

O que e uma chave primaria?
E um identificador unico de cada linha. Aqui, id identifica cada pet ou
cuidado e e gerado automaticamente.

Como o cuidado e associado ao pet?
A tabela cuidados tem o campo pet_id, que referencia o id na tabela pets.

Por que pet_id e uma chave estrangeira?
Ela liga cada cuidado ao pet correspondente usando o id desse pet. Isso
permite filtrar a agenda e manter o relacionamento entre as tabelas.

O que significa ON DELETE CASCADE?
Ao excluir um pet, o banco tambem apaga os cuidados que fazem referencia a
ele. A tela pede confirmacao antes da exclusao.

Para que serve whereArgs?
Ele envia os valores de uma consulta separados do comando SQL. Por exemplo,
permite filtrar pelo pet_id sem juntar valores diretamente ao texto SQL.

Como o formulario serve para cadastrar e editar?
Sem receber um registro existente, o formulario cria um novo. Se recebe os
dados de um pet ou cuidado, preenche os campos e salva as alteracoes daquele
registro.

O que e o singleton no BancoDados?
E um padrao em que a classe oferece uma unica instancia compartilhada. Assim,
as telas usam o mesmo gerenciador do banco.

Por que os dados continuam salvos?
Porque sao gravados em um banco local. No Android, o SQLite fica no
armazenamento do aplicativo; no navegador, o armazenamento e feito pelo
IndexedDB do Chrome.

O que e uma chave estrangeira?
E uma regra que liga um registro a outro e ajuda a manter o relacionamento
entre cuidados e pets.

O aplicativo envia notificacoes?
Nao. Ele mostra os cuidados e destaca os que estao atrasados quando a agenda
esta aberta, mas nao envia notificacoes.

O aplicativo sincroniza com a internet?
Nao. Os dados sao locais e nao sao compartilhados entre dispositivos.

Por que existe uma configuracao especifica para o navegador?
O pacote sqflite usa uma implementacao nas plataformas nativas. No navegador
e necessario selecionar uma implementacao compativel com web. Os arquivos de
selecao condicional fazem essa escolha sem trocar a configuracao nativa.

O que responder se eu nao souber um detalhe?
Responda com sinceridade: "Eu ainda estou aprendendo essa parte. Pelo que
entendi, esse trecho faz [diga o que voce sabe]. Posso verificar os detalhes
para confirmar." Nao precisa decorar cada linha nem inventar uma resposta.

Uma forma simples de explicar um trecho e dizer primeiro qual e o objetivo
dele e depois apontar onde ele carrega, grava ou atualiza os dados. Entender
o fluxo geral e mais importante do que decorar o codigo.

## Documentação

- [Documentação técnica](docs/DOCUMENTACAO.md)
- [Plano e registro de testes](docs/TESTES.md)
- [Roteiro para apresentação](docs/APRESENTACAO.md)
- [Publicação no GitHub](docs/GITHUB.md)

Projeto preparado para a apresentação acadêmica de Giovanna Vitória Bonfim de Freitas Gomes. Complete nome, turma, disciplina e participantes conforme a autoria e as contribuições reais antes da entrega.

