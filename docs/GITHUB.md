# Preparar publicação no GitHub

## Antes do primeiro commit

- Completar identificação acadêmica e contribuições reais no README.
- Conferir os arquivos e evitar dados pessoais, senhas e chaves.
- Manter `pubspec.lock` versionado para registrar as dependências resolvidas.
- Reexecutar `flutter analyze` e `flutter test`.
- Criar um repositório vazio na conta correta, com nome `petagenda`.

## Comandos locais

Execute na pasta que contém `pubspec.yaml`:

```powershell
git init
git add .
git status
git diff --cached --stat
git commit -m "Adiciona PetAgenda com SQLite e documentação"
git branch -M main
```

Revise os arquivos listados antes do commit. Depois copie a URL HTTPS real do repositório criado:

```powershell
git remote add origin URL_HTTPS_DO_REPOSITORIO
git push -u origin main
```

Substitua o marcador pela URL real, sem publicá-lo literalmente. Se `origin` já existir, confira `git remote -v` antes de alterá-lo. Use o fluxo de autenticação do GitHub disponibilizado pelo Git no computador; não coloque tokens em arquivos ou comandos compartilhados.

## Release acadêmica

Depois de validar a versão e enviar os commits, pode ser criada a tag `v1.0.0` e uma release com funcionalidades, limitações e instruções. Um APK só deve ser anexado depois de gerado e testado no dispositivo. Este pacote contém fontes e documentação; não contém APK compilado nem comprova publicação remota.
