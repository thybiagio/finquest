import 'package:flutter_test/flutter_test.dart';

import 'package:finquest/main.dart';

void main() {
  testWidgets('FinQuest home renders stat cards', (tester) async {
    await tester.pumpWidget(const FinQuestApp());

    expect(find.text('Receita'), findsOneWidget);
    expect(find.text('Saldo'), findsOneWidget);
  });
}