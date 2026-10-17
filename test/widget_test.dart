import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:petagenda/main.dart';

void main() {
  testWidgets('Exibe a tela inicial do PetAgenda', (tester) async {
    await tester.pumpWidget(const PetAgendaApp());

    expect(find.text('PetAgenda'), findsOneWidget);

    expect(
      find.text('Mais cuidado.\nMais momentos juntos.'),
      findsOneWidget,
    );

    expect(
      find.widgetWithText(
        FilledButton,
        'Conhecer meus pets',
      ),
      findsOneWidget,
    );
  });
}