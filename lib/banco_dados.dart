import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

/// Gerencia o banco local do PetAgenda.
class BancoDados {
  BancoDados._();

  // Singleton: as telas compartilham a mesma instância de acesso ao banco.
  static final BancoDados instancia = BancoDados._();

  Database? _banco;
  Future<Database>? _abrindo;

  /// Abre sob demanda e reutiliza a conexão existente.
  Future<Database> get banco async {
    if (_banco != null) return _banco!;

    // Evita abrir o banco duas vezes ao mesmo tempo.
    final abertura = _abrindo ??= _abrir();

    try {
      final db = await abertura;
      _banco = db;
      return db;
    } finally {
      _abrindo = null;
    }
  }

  Future<Database> _abrir() async {
    final pasta = await getDatabasesPath();
    final caminho = join(pasta, 'petagenda.db');

    return openDatabase(
      caminho,
      version: 1,
      // Ativa a integridade referencial antes de criar ou usar as tabelas.
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      // Executado somente na criação inicial; mudanças futuras exigem migração.
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE pets (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            especie TEXT NOT NULL,
            raca TEXT NOT NULL DEFAULT '',
            nascimento TEXT
          )
        ''');

        await db.execute('''
          CREATE TABLE cuidados (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            pet_id INTEGER NOT NULL,
            tipo TEXT NOT NULL,
            descricao TEXT NOT NULL,
            data TEXT NOT NULL,
            concluido INTEGER NOT NULL DEFAULT 0
              CHECK (concluido IN (0, 1)),
            observacoes TEXT NOT NULL DEFAULT '',
            FOREIGN KEY (pet_id)
              REFERENCES pets (id)
              ON DELETE CASCADE
          )
        ''');
      },
    );
  }
}