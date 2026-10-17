import 'package:flutter/material.dart';
import 'banco_dados.dart';
import 'cuidados_page.dart';

// Cores do aplicativo.
const roxo = Color(0xFF6D28D9);
const verde = Color(0xFF15803D);
const fundo = Color(0xFFF7F5FC);
const textoEscuro = Color(0xFF29213D);
const textoSecundario = Color(0xFF6B6478);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PetAgendaApp());
}

class PetAgendaApp extends StatelessWidget {
  const PetAgendaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PetAgenda',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: roxo,
          primary: roxo,
          secondary: verde,
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: fundo,
        appBarTheme: const AppBarTheme(
          backgroundColor: fundo,
          foregroundColor: textoEscuro,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: textoEscuro,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        floatingActionButtonTheme:
            const FloatingActionButtonThemeData(
          backgroundColor: roxo,
          foregroundColor: Colors.white,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: roxo,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.all(18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          prefixIconColor: roxo,
          contentPadding: const EdgeInsets.all(18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: Color(0xFFE3DDEF),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: roxo,
              width: 2,
            ),
          ),
        ),
      ),
      home: const InicioPage(),
    );
  }
}

// Aparência dos cartões.
BoxDecoration cartaoBranco() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(22),
    border: Border.all(
      color: const Color(0xFFE8E2F1),
    ),
  );
}

// Converte a data do banco para o formato brasileiro.
String formatarDataPet(String data) {
  final partes = data.split('-');

  if (partes.length != 3) return data;

  return '${partes[2]}/${partes[1]}/${partes[0]}';
}

// Tela inicial.
class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  int _quantidade = 0;
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  // Consulta o SQLite e atualiza a tela apenas se ela ainda estiver aberta.
  Future<void> _carregar() async {
    try {
      final db = await BancoDados.instancia.banco;

      final resultado = await db.rawQuery(
        'SELECT COUNT(*) AS quantidade FROM pets',
      );

      if (!mounted) return;

      setState(() {
        _quantidade = resultado.first['quantidade'] as int;
        _carregando = false;
        _erro = null;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _carregando = false;
        _erro = 'Não foi possível carregar seus pets.';
      });
    }
  }

  // Recarrega o contador quando o usuário retorna da lista de pets.
  Future<void> _abrirPets() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const PetsPage(),
      ),
    );

    if (mounted) {
      await _carregar();
    }
  }

  Widget _resumoPets() {
    if (_carregando) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_erro != null) {
      return Column(
        children: [
          Text(_erro!),
          TextButton(
            onPressed: _carregar,
            child: const Text('Tentar novamente'),
          ),
        ],
      );
    }

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFDCFCE7),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.favorite_outline,
            color: verde,
            size: 30,
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$_quantidade',
                style: const TextStyle(
                  fontSize: 32,
                  color: textoEscuro,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                _quantidade == 1
                    ? 'Pet cadastrado'
                    : 'Pets cadastrados',
                style: const TextStyle(
                  color: textoSecundario,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.pets_rounded, color: roxo),
            SizedBox(width: 10),
            Text('PetAgenda'),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _carregar,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(24),
          children: [
            Container(
              padding: const EdgeInsets.all(26),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF4C1D95),
                    Color(0xFF7C3AED),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.pets_rounded,
                    color: Color(0xFFBBF7D0),
                    size: 48,
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Mais cuidado.\nMais momentos juntos.',
                    style: TextStyle(
                      fontSize: 30,
                      height: 1.2,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Um lugar especial para organizar '
                    'a rotina dos seus pets.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Sua família de patinhas',
              style: TextStyle(
                color: textoEscuro,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(22),
              decoration: cartaoBranco(),
              child: _resumoPets(),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _abrirPets,
              icon: const Icon(Icons.pets_outlined),
              label: const Text('Conhecer meus pets'),
            ),
          ],
        ),
      ),
    );
  }
}

// Lista, edição e exclusão dos pets.
class PetsPage extends StatefulWidget {
  const PetsPage({super.key});

  @override
  State<PetsPage> createState() => _PetsPageState();
}

class _PetsPageState extends State<PetsPage> {
  List<Map<String, Object?>> _pets = [];
  bool _carregando = true;
  bool _excluindo = false;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  // Consulta o SQLite e atualiza a tela apenas se ela ainda estiver aberta.
  Future<void> _carregar() async {
    try {
      final db = await BancoDados.instancia.banco;

      final registros = await db.query(
        'pets',
        orderBy: 'id DESC',
      );

      if (!mounted) return;

      setState(() {
        _pets = registros;
        _carregando = false;
        _erro = null;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _carregando = false;
        _erro = 'Não foi possível carregar seus pets.';
      });
    }
  }

  // O retorno true informa que houve gravação e a lista deve ser atualizada.
  Future<void> _abrirFormulario({
    Map<String, Object?>? pet,
  }) async {
    final salvo = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CadastroPetPage(pet: pet),
      ),
    );

    if (!mounted || salvo != true) return;

    await _carregar();
  }

  // Solicita confirmação antes de remover o pet e seus cuidados.
  Future<void> _excluirPet(Map<String, Object?> pet) async {
    if (_excluindo) return;

    final nome = pet['nome'] as String;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (contextoDialogo) {
        return AlertDialog(
          title: const Text('Excluir pet?'),
          content: Text(
            'Deseja excluir "$nome"?\n\n'
            'Todos os cuidados cadastrados para esse pet '
            'também serão excluídos. '
            'Esta ação não pode ser desfeita.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(contextoDialogo, false);
              },
              child: const Text('Cancelar'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(contextoDialogo, true);
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (!mounted || confirmar != true || _excluindo) return;

    setState(() => _excluindo = true);

    try {
      final db = await BancoDados.instancia.banco;

      // O banco também exclui os cuidados vinculados ao pet.
      final removidos = await db.delete(
        'pets',
        where: 'id = ?',
        whereArgs: [pet['id']],
      );

      if (removidos == 0) {
        throw StateError('Pet não encontrado.');
      }

      if (!mounted) return;

      await _carregar();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$nome foi excluído.'),
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível excluir o pet.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _excluindo = false);
      }
    }
  }

  // Passa o ID do pet para que a agenda mostre somente seus cuidados.
  Widget _cartaoPet(Map<String, Object?> pet) {
    final raca = pet['raca'] as String;
    final nascimento = pet['nascimento'] as String?;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(22),
      decoration: cartaoBranco(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E8FF),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.pets_rounded,
                  color: roxo,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pet['nome'] as String,
                      style: const TextStyle(
                        color: textoEscuro,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      pet['especie'] as String,
                      style: const TextStyle(
                        color: verde,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                enabled: !_excluindo,
                tooltip: 'Opções do pet',
                onSelected: (opcao) async {
                  if (opcao == 'editar') {
                    await _abrirFormulario(pet: pet);
                  } else if (opcao == 'excluir') {
                    await _excluirPet(pet);
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem<String>(
                    value: 'editar',
                    child: Row(
                      children: [
                        Icon(Icons.edit_outlined, color: roxo),
                        SizedBox(width: 12),
                        Text('Editar pet'),
                      ],
                    ),
                  ),
                  PopupMenuItem<String>(
                    value: 'excluir',
                    child: Row(
                      children: [
                        Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Excluir pet',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            raca.isEmpty ? 'Raça não informada' : raca,
            style: const TextStyle(color: textoSecundario),
          ),
          if (nascimento != null) ...[
            const SizedBox(height: 8),
            Text(
              'Nascimento: ${formatarDataPet(nascimento)}',
              style: const TextStyle(color: textoSecundario),
            ),
          ],
          const SizedBox(height: 12),
          const Divider(),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: _excluindo
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CuidadosPage(
                            petId: pet['id'] as int,
                            nomePet: pet['nome'] as String,
                          ),
                        ),
                      );
                    },
              icon: const Icon(Icons.calendar_month_outlined),
              label: const Text('Ver cuidados'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _conteudo() {
    if (_carregando) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_erro != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_erro!),
            TextButton(
              onPressed: _carregar,
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _carregar,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 120),
        children: [
          const Text(
            'Cada pet, uma história.',
            style: TextStyle(
              color: textoEscuro,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Guarde as informações de quem '
            'faz parte da sua família.',
            style: TextStyle(color: textoSecundario),
          ),
          const SizedBox(height: 24),
          if (_excluindo) ...[
            const LinearProgressIndicator(),
            const SizedBox(height: 16),
          ],
          if (_pets.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              decoration: cartaoBranco(),
              child: const Column(
                children: [
                  Icon(
                    Icons.pets_outlined,
                    color: verde,
                    size: 64,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Vamos conhecer seu pet?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Toque em Novo pet para cadastrar.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ..._pets.map(_cartaoPet),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus pets')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _excluindo
            ? null
            : () {
                _abrirFormulario();
              },
        icon: const Icon(Icons.add),
        label: const Text('Novo pet'),
      ),
      body: _conteudo(),
    );
  }
}

// Formulário compartilhado pelo cadastro e pela edição.
class CadastroPetPage extends StatefulWidget {
  final Map<String, Object?>? pet;

  const CadastroPetPage({
    super.key,
    this.pet,
  });

  @override
  State<CadastroPetPage> createState() => _CadastroPetPageState();
}

class _CadastroPetPageState extends State<CadastroPetPage> {
  final _formulario = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _raca = TextEditingController();

  static const _especies = [
    'Cachorro',
    'Gato',
    'Ave',
    'Coelho',
    'Outro',
  ];

  String _especie = 'Cachorro';
  DateTime? _nascimento;
  bool _salvando = false;

  bool get _editando => widget.pet != null;

  @override
  void initState() {
    super.initState();

    final pet = widget.pet;

    if (pet != null) {
      _nome.text = pet['nome'] as String;
      _raca.text = pet['raca'] as String;
      _especie = pet['especie'] as String;

      final nascimento = pet['nascimento'] as String?;

      if (nascimento != null) {
        _nascimento = DateTime.tryParse(nascimento);
      }
    }
  }

  @override
  void dispose() {
    _nome.dispose();
    _raca.dispose();
    super.dispose();
  }

  // Datas são armazenadas como texto ISO (AAAA-MM-DD), sem horário.
  String? get _nascimentoBanco {
    final data = _nascimento;

    if (data == null) return null;

    final ano = data.year.toString().padLeft(4, '0');
    final mes = data.month.toString().padLeft(2, '0');
    final dia = data.day.toString().padLeft(2, '0');

    return '$ano-$mes-$dia';
  }

  Future<void> _escolherNascimento() async {
    final hoje = DateUtils.dateOnly(DateTime.now());
    final primeiraData = DateTime(1900);

    var inicial = _nascimento ?? hoje;

    if (inicial.isAfter(hoje)) {
      inicial = hoje;
    }

    if (inicial.isBefore(primeiraData)) {
      inicial = primeiraData;
    }

    final data = await showDatePicker(
      context: context,
      initialDate: inicial,
      firstDate: primeiraData,
      lastDate: hoje,
      helpText: 'Nascimento do pet',
      cancelText: 'Cancelar',
      confirmText: 'Selecionar',
    );

    if (data != null && mounted) {
      setState(() => _nascimento = data);
    }
  }

  // Valida o formulário e impede gravações duplicadas enquanto salva.
  Future<void> _salvar() async {
    if (_salvando || !_formulario.currentState!.validate()) {
      return;
    }

    setState(() => _salvando = true);

    try {
      final db = await BancoDados.instancia.banco;

      final dados = <String, Object?>{
        'nome': _nome.text.trim(),
        'especie': _especie,
        'raca': _raca.text.trim(),
        'nascimento': _nascimentoBanco,
      };

      if (_editando) {
        // Preserva o ID e os cuidados já cadastrados.
        final alterados = await db.update(
          'pets',
          dados,
          where: 'id = ?',
          whereArgs: [widget.pet!['id']],
        );

        if (alterados == 0) {
          throw StateError('Pet não encontrado.');
        }
      } else {
        await db.insert('pets', dados);
      }

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível salvar o pet.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _salvando = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editando ? 'Editar pet' : 'Novo pet'),
      ),
      body: Form(
        key: _formulario,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              _editando
                  ? 'Os detalhes fazem parte do cuidado.'
                  : 'Quem chegou por aqui?',
              style: const TextStyle(
                color: textoEscuro,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _editando
                  ? 'Atualize as informações do seu companheiro.'
                  : 'Preencha os dados do seu companheiro.',
              style: const TextStyle(color: textoSecundario),
            ),
            const SizedBox(height: 28),
            TextFormField(
              controller: _nome,
              enabled: !_salvando,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Nome do pet',
                hintText: 'Ex.: Luna',
                prefixIcon: Icon(Icons.favorite_outline),
              ),
              validator: (valor) {
                if (valor == null || valor.trim().isEmpty) {
                  return 'Informe o nome do pet.';
                }

                return null;
              },
            ),
            const SizedBox(height: 16),
            InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Espécie',
                prefixIcon: Icon(Icons.pets_outlined),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _especie,
                  isExpanded: true,
                  isDense: true,
                  items: _especies.map((especie) {
                    return DropdownMenuItem(
                      value: especie,
                      child: Text(especie),
                    );
                  }).toList(),
                  onChanged: _salvando
                      ? null
                      : (valor) {
                          if (valor != null) {
                            setState(() => _especie = valor);
                          }
                        },
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _raca,
              enabled: !_salvando,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Raça (opcional)',
                hintText: 'Ex.: Sem raça definida',
                prefixIcon: Icon(Icons.info_outline),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(18),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: _salvando ? null : _escolherNascimento,
              icon: const Icon(Icons.cake_outlined),
              label: Text(
                _nascimento == null
                    ? 'Informar nascimento (opcional)'
                    : 'Nascimento: '
                        '${formatarDataPet(_nascimentoBanco!)}',
              ),
            ),
            if (_nascimento != null)
              TextButton(
                onPressed: _salvando
                    ? null
                    : () {
                        setState(() => _nascimento = null);
                      },
                child: const Text('Remover data de nascimento'),
              ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _salvando ? null : _salvar,
              icon: const Icon(Icons.check_circle_outline),
              label: Text(
                _salvando
                    ? 'Salvando...'
                    : _editando
                        ? 'Salvar alterações'
                        : 'Salvar pet',
              ),
            ),
          ],
        ),
      ),
    );
  }
}