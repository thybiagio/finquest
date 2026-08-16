import 'package:flutter_test/flutter_test.dart';

import 'package:finquest/main.dart';

void main() {
  testWidgets('FinQuest inicia e mostra a barra de navegação', (tester) async {
    await tester.pumpWidget(const FinQuestApp());
    await tester.pump();

    expect(find.text('FinQuest'), findsOneWidget);
    expect(find.text('Início'), findsOneWidget);
    expect(find.text('Perfil'), findsOneWidget);
  });
}