# Plano e registro de testes

## Evidências disponíveis

Em 17/10/2026, o usuário compartilhou saída de `flutter analyze` sem problemas e `flutter test` com `+1: All tests passed!`, antes desta revisão documental. Também confirmou manualmente os fluxos abaixo no Android. Esses relatos não são uma certificação de cobertura completa.

Nesta revisão foram adicionados comentários sem alterar as instruções executáveis Dart. Não havia Flutter disponível no ambiente de revisão; execute novamente os comandos após extrair o pacote.

## Teste automatizado existente

`test/widget_test.dart` verifica título, mensagem de apresentação e botão de acesso aos pets na tela inicial. Não comprova operações SQLite, persistência ou navegação completa.

## Testes manuais

| Caso | Procedimento | Resultado esperado | Situação relatada |
| --- | --- | --- | --- |
| Pet: cadastro/lista | Cadastrar e voltar à lista | Dados exibidos | Funcionou |
| Pet: edição | Alterar e salvar | Dados atualizados | Funcionou |
| Pet: exclusão | Excluir pet de teste | Registro desaparece | Funcionou |
| Cuidado: cadastro | Criar cuidado de um pet | Aparece na agenda | Funcionou |
| Cuidado: edição | Alterar descrição | Alteração exibida | Funcionou |
| Conclusão | Marcar concluído e voltar a pendente | Situação muda | Funcionou |
| Cuidado: exclusão | Confirmar exclusão | Registro desaparece | Funcionou |
| Persistência de pet | Fechar e reabrir | Pet permanece | Funcionou |
| Persistência de cuidado | Fechar e reabrir | Cuidado permanece | Funcionou |

## Verificações adicionais antes da entrega

Estes casos ainda precisam de evidência específica:

- Cancelar uma exclusão mantém o registro.
- Cadastrar dois pets e verificar isolamento de seus cuidados.
- Editar um pet mantém os cuidados existentes vinculados a ele.
- Excluir um pet com cuidados remove os vínculos, sem afetar outro pet.
- Tentar salvar nome e descrição vazios exibe validação.
- Cadastrar cuidado passado pendente e conferir o destaque.
- Conferir rolagem com teclado aberto e textos maiores.

## Reexecutar verificações

Na pasta com `pubspec.yaml`:

```powershell
flutter pub get
flutter analyze
flutter test
```

Use registros de teste para exclusões. Guarde as saídas e capturas de tela como evidência da execução final.
