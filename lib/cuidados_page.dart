import 'package:flutter/material.dart';
import 'banco_dados.dart';

const _verde = Color(0xFF15803D);
const _roxo = Color(0xFF6D28D9);

// A apresentação usa DD/MM/AAAA; o banco mantém AAAA-MM-DD.
String _dataTexto(String data) {
  final partes = data.split('-');
  return '${partes[2]}/${partes[1]}/${partes[0]}';
}

String _dataBanco(DateTime data) {
  final ano = data.year.toString().padLeft(4, '0');
  final mes = data.month.toString().padLeft(2, '0');
  final dia = data.day.toString().padLeft(2, '0');
  return '$ano-$mes-$dia';
}

/// Agenda e histórico de cuidados de um único pet.
class CuidadosPage extends StatefulWidget {
  final int petId;
  final String nomePet;

  const CuidadosPage({
    super.key,
    required this.petId,
    required this.nomePet,
  });

  @override
  State<CuidadosPage> createState() => _CuidadosPageState();
}

class _CuidadosPageState extends State<CuidadosPage> {
  List<Map<String, Object?>> _cuidados = [];
  bool _carregando = true;
  bool _ocupado = false;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  // Filtra pelo pet e ordena pendentes antes dos concluídos, por data.
  Future<void> _carregar() async {
    try {
      final db = await BancoDados.instancia.banco;
      final registros = await db.query(
        'cuidados',
        where: 'pet_id = ?',
        whereArgs: [widget.petId],
        orderBy: 'concluido ASC, data ASC, id ASC',
      );

      if (!mounted) return;
      setState(() {
        _cuidados = registros;
        _carregando = false;
        _erro = null;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _carregando = false;
        _erro = 'Não foi possível carregar os cuidados.';
      });
    }
  }

  void _mensagem(String texto) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto)),
    );
  }

  // Reutiliza o formulário: sem registro cria; com registro edita.
  Future<void> _formulario({
    Map<String, Object?>? cuidado,
  }) async {
    final salvo = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CadastroCuidadoPage(
          petId: widget.petId,
          cuidado: cuidado,
        ),
      ),
    );

    if (salvo == true && mounted) await _carregar();
  }

  // Alterna entre 0 (pendente) e 1 (concluído), restringindo ao pet atual.
  Future<void> _alterarSituacao(
    Map<String, Object?> cuidado,
  ) async {
    if (_ocupado) return;
    setState(() => _ocupado = true);

    try {
      final db = await BancoDados.instancia.banco;
      await db.update(
        'cuidados',
        {'concluido': cuidado['concluido'] == 1 ? 0 : 1},
        where: 'id = ? AND pet_id = ?',
        whereArgs: [cuidado['id'], widget.petId],
      );

      if (mounted) await _carregar();
    } catch (_) {
      _mensagem('Não foi possível atualizar a situação.');
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

  // A exclusão exige confirmação e identifica o cuidado e seu pet.
  Future<void> _excluir(
    Map<String, Object?> cuidado,
  ) async {
    if (_ocupado) return;

    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir cuidado?'),
        content: Text(
          'Excluir "${cuidado['descricao']}"?\n\n'
          'Esta ação não pode ser desfeita.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmar != true || !mounted || _ocupado) return;
    setState(() => _ocupado = true);

    try {
      final db = await BancoDados.instancia.banco;
      await db.delete(
        'cuidados',
        where: 'id = ? AND pet_id = ?',
        whereArgs: [cuidado['id'], widget.petId],
      );

      if (!mounted) return;
      await _carregar();
      _mensagem('Cuidado excluído.');
    } catch (_) {
      _mensagem('Não foi possível excluir o cuidado.');
    } finally {
      if (mounted) setState(() => _ocupado = false);
    }
  }

  // A situação exibida depende da conclusão e da comparação com o dia atual.
  Widget _cartao(Map<String, Object?> cuidado) {
    final concluido = cuidado['concluido'] == 1;
    final data = DateTime.parse(cuidado['data'] as String);
    final hoje = DateUtils.dateOnly(DateTime.now());
    final atrasado = !concluido && data.isBefore(hoje);
    final cor = concluido
        ? _verde
        : atrasado
            ? const Color(0xFFB45309)
            : _roxo;

    final situacao = concluido
        ? 'Concluído'
        : atrasado
            ? 'Pendente • data passada'
            : 'Agendado';

    final observacoes = cuidado['observacoes'] as String;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFE8E2F1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                concluido
                    ? Icons.check_circle_outline
                    : Icons.event_note_outlined,
                color: cor,
                size: 30,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  cuidado['tipo'] as String,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                enabled: !_ocupado,
                tooltip: 'Opções do cuidado',
                onSelected: (opcao) async {
                  if (opcao == 'editar') {
                    await _formulario(cuidado: cuidado);
                  } else {
                    await _excluir(cuidado);
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(
                    value: 'editar',
                    child: Text('Editar cuidado'),
                  ),
                  PopupMenuItem(
                    value: 'excluir',
                    child: Text(
                      'Excluir cuidado',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            cuidado['descricao'] as String,
            style: const TextStyle(fontSize: 17),
          ),
          const SizedBox(height: 10),
          Text('Data: ${_dataTexto(cuidado['data'] as String)}'),
          const SizedBox(height: 8),
          Text(
            situacao,
            style: TextStyle(
              color: cor,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (observacoes.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(observacoes),
          ],
          const Divider(height: 28),
          TextButton.icon(
            onPressed: _ocupado
                ? null
                : () => _alterarSituacao(cuidado),
            icon: Icon(
              concluido
                  ? Icons.undo_rounded
                  : Icons.check_rounded,
            ),
            label: Text(
              concluido
                  ? 'Marcar como pendente'
                  : 'Marcar como concluído',
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendentes = _cuidados
        .where((cuidado) => cuidado['concluido'] == 0)
        .length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cuidados de ${widget.nomePet}'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _ocupado ? null : () => _formulario(),
        icon: const Icon(Icons.add),
        label: const Text('Novo cuidado'),
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _erro != null
              ? Center(
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
                )
              : RefreshIndicator(
                  onRefresh: _carregar,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 120),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.favorite_outline,
                              color: _verde,
                              size: 36,
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'Cuidar é estar presente.',
                              style: TextStyle(
                                color: _verde,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '$pendentes '
                              '${pendentes == 1 ? 'cuidado pendente' : 'cuidados pendentes'}',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Agenda e histórico',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Os cuidados pendentes aparecem primeiro. '
                        'Esta agenda não envia notificações.',
                      ),
                      const SizedBox(height: 20),
                      if (_cuidados.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(24),
                          child: Text(
                            'Nenhum cuidado cadastrado.\n'
                            'Toque em Novo cuidado para começar.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ..._cuidados.map(_cartao),
                    ],
                  ),
                ),
    );
  }
}

/// Formulário compartilhado entre cadastro e edição.
class CadastroCuidadoPage extends StatefulWidget {
  final int petId;
  final Map<String, Object?>? cuidado;

  const CadastroCuidadoPage({
    super.key,
    required this.petId,
    this.cuidado,
  });

  @override
  State<CadastroCuidadoPage> createState() =>
      _CadastroCuidadoPageState();
}

class _CadastroCuidadoPageState extends State<CadastroCuidadoPage> {
  final _formulario = GlobalKey<FormState>();
  final _descricao = TextEditingController();
  final _observacoes = TextEditingController();

  static const _tipos = [
    'Vacina',
    'Consulta',
    'Banho e tosa',
    'Outro',
  ];

  String _tipo = 'Consulta';
  DateTime _data = DateUtils.dateOnly(DateTime.now());
  bool _salvando = false;

  bool get _editando => widget.cuidado != null;

  @override
  void initState() {
    super.initState();
    final cuidado = widget.cuidado;

    if (cuidado != null) {
      _tipo = cuidado['tipo'] as String;
      _descricao.text = cuidado['descricao'] as String;
      _observacoes.text = cuidado['observacoes'] as String;
      _data = DateTime.parse(cuidado['data'] as String);
    }
  }

  @override
  // Libera os controladores quando o formulário é descartado.
  void dispose() {
    _descricao.dispose();
    _observacoes.dispose();
    super.dispose();
  }

  Future<void> _escolherData() async {
    final escolhida = await showDatePicker(
      context: context,
      initialDate: _data,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100, 12, 31),
      helpText: 'Data do cuidado',
      cancelText: 'Cancelar',
      confirmText: 'Selecionar',
    );

    if (escolhida != null && mounted) {
      setState(() => _data = escolhida);
    }
  }

  Future<void> _salvar() async {
    if (_salvando || !_formulario.currentState!.validate()) return;
    setState(() => _salvando = true);

    try {
      final db = await BancoDados.instancia.banco;

      // Na edição, preserva a situação pendente/concluída.
      final dados = <String, Object?>{
        'pet_id': widget.petId,
        'tipo': _tipo,
        'descricao': _descricao.text.trim(),
        'data': _dataBanco(_data),
        'observacoes': _observacoes.text.trim(),
      };

      if (_editando) {
        final alterados = await db.update(
          'cuidados',
          dados,
          where: 'id = ? AND pet_id = ?',
          whereArgs: [widget.cuidado!['id'], widget.petId],
        );

        if (alterados == 0) {
          throw StateError('Cuidado não encontrado.');
        }
      } else {
        // Cuidados novos começam pendentes pelo padrão da tabela.
        await db.insert('cuidados', dados);
      }

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível salvar o cuidado.'),
        ),
      );
    } finally {
      if (mounted) setState(() => _salvando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _editando ? 'Editar cuidado' : 'Novo cuidado',
        ),
      ),
      body: Form(
        key: _formulario,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Text(
              'Um carinho na rotina.',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Organize compromissos e registre cuidados realizados.',
            ),
            const SizedBox(height: 28),
            InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Tipo de cuidado',
                prefixIcon: Icon(Icons.category_outlined),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _tipo,
                  isExpanded: true,
                  isDense: true,
                  items: _tipos.map((tipo) {
                    return DropdownMenuItem(
                      value: tipo,
                      child: Text(tipo),
                    );
                  }).toList(),
                  onChanged: (valor) {
                    if (valor != null) {
                      setState(() => _tipo = valor);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descricao,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                hintText: 'Ex.: Consulta de rotina',
                prefixIcon: Icon(Icons.edit_note_rounded),
              ),
              validator: (valor) {
                if (valor == null || valor.trim().isEmpty) {
                  return 'Informe a descrição.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _escolherData,
              icon: const Icon(Icons.calendar_month_outlined),
              label: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Data: ${_dataTexto(_dataBanco(_data))}',
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _observacoes,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Observações (opcional)',
                prefixIcon: Icon(Icons.notes_rounded),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _salvando ? null : _salvar,
              icon: const Icon(Icons.check_circle_outline),
              label: Text(
                _salvando ? 'Salvando...' : 'Salvar cuidado',
              ),
            ),
          ],
        ),
      ),
    );
  }
}