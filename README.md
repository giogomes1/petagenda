# 🐾 PetAgenda

Aplicativo acadêmico em Flutter e Dart para organizar pets e seus cuidados, com armazenamento local em SQLite e visual verde e roxo.

## Funcionalidades

- Cadastrar, listar, editar e excluir pets.
- Informar nome, espécie, raça opcional e nascimento opcional.
- Cadastrar, editar e excluir cuidados de cada pet.
- Classificar cuidados como Vacina, Consulta, Banho e tosa ou Outro.
- Registrar descrição, data e observações opcionais.
- Marcar cuidados como concluídos ou voltar para pendente.
- Identificar cuidados pendentes com data passada.
- Consultar a quantidade de pets na tela inicial e de cuidados pendentes na agenda.
- Manter os dados ao fechar e reabrir o aplicativo.

## Tecnologias

Flutter, Dart, Material 3, SQLite (`sqflite`) e composição de caminhos com `path`. As versões e restrições estão em `pubspec.yaml`; as resoluções estão em `pubspec.lock`.

## Executar

Use um Flutter que atenda ao Dart `^3.13.2` declarado no projeto, Android SDK configurado e um dispositivo Android com depuração USB autorizada.

Na pasta que contém `pubspec.yaml`:

```powershell
flutter pub get
flutter devices
```

Copie o identificador Android exibido e substitua `ID_DO_CELULAR`:

```powershell
flutter run -d ID_DO_CELULAR
```

O alvo validado neste projeto é Android. A presença de pastas de outras plataformas não significa que tenham sido testadas. Windows e navegador precisam de adaptação da camada SQLite.

## Verificações

```powershell
flutter analyze
flutter test
```

O teste automatizado verifica a apresentação inicial. Os fluxos de banco, cadastro, edição, exclusão e persistência foram verificados manualmente pelo usuário no Android. Consulte [o plano de testes](docs/TESTES.md).

## Gerar APK

```powershell
flutter build apk --release
```

Saída esperada: `build/app/outputs/flutter-apk/app-release.apk`. O APK não está incluído neste pacote. A assinatura deve ser revisada antes de uma publicação em loja.

## Organização

| Arquivo | Responsabilidade |
| --- | --- |
| `lib/main.dart` | Tema, início, lista e formulário de pets |
| `lib/banco_dados.dart` | Abertura do SQLite e criação das tabelas |
| `lib/cuidados_page.dart` | Agenda, histórico e formulário de cuidados |
| `test/widget_test.dart` | Teste da tela inicial |
| `docs/` | Documentação técnica, testes e apresentação |

## Dados e limites

O banco `petagenda.db` fica no armazenamento local do aplicativo. Não há login, sincronização em nuvem, exportação de backup nem notificações. Desinstalar o app ou limpar seus dados pode apagar os registros. Excluir um pet remove também todos os seus cuidados, após confirmação. O aplicativo não implementa criptografia própria do banco.

## Documentação

- [Documentação técnica](docs/DOCUMENTACAO.md)
- [Plano e registro de testes](docs/TESTES.md)
- [Roteiro para apresentação](docs/APRESENTACAO.md)
- [Publicação no GitHub](docs/GITHUB.md)

Projeto preparado para a apresentação acadêmica de Giovanna Vitória Bonfim de Freitas Gomes. Complete nome, turma, disciplina e participantes conforme a autoria e as contribuições reais antes da entrega.

