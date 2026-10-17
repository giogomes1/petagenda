# Como abrir esta versão

1. Extraia o ZIP em uma pasta nova, por exemplo `C:\dev\petagenda_documentado`.
2. Abra no VS Code a subpasta `petagenda`, que contém `pubspec.yaml`.
3. No terminal dessa pasta, rode `flutter pub get`, `flutter analyze` e `flutter test`.
4. Leia `README.md` e os arquivos em `docs`.
5. Para executar no telefone, use `flutter devices` e depois `flutter run -d ID_DO_CELULAR`, substituindo pelo identificador exibido.

A extração dos fontes não transporta o banco que já está no celular. Preserve a instalação existente e não limpe seus dados. O arquivo `android/local.properties` foi omitido por conter caminhos específicos do computador; o ambiente Flutter local o recria. Se o Flutter indicar arquivos de plataforma ausentes, consulte `docs/EMPACOTAMENTO.md`.
