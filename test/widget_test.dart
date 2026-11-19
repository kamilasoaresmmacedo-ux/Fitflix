import 'package:flutter_test/flutter_test.dart';
import 'package:nextfit/main.dart';

void main() {
  testWidgets('exibe o painel inicial e navega entre as áreas do aluno', (
    tester,
  ) async {
    await tester.pumpWidget(const NextFitApp());

    expect(find.text('Vamos com tudo,\nAna.'), findsOneWidget);
    expect(find.text('Peito, ombro e tríceps'), findsOneWidget);

    await tester.tap(find.text('Treino').last);
    await tester.pumpAndSettle();
    expect(find.text('Treino de hoje'), findsOneWidget);

    await tester.tap(find.text('Hábitos').last);
    await tester.pumpAndSettle();
    expect(find.text('Seus hábitos'), findsOneWidget);
  });

  testWidgets('permite marcar e desmarcar hábitos', (tester) async {
    await tester.pumpWidget(const NextFitApp());
    await tester.tap(find.text('Hábitos').last);
    await tester.pumpAndSettle();

    expect(find.text('1/3'), findsOneWidget);
    await tester.tap(find.text('Dormir 8 horas'));
    await tester.pumpAndSettle();
    expect(find.text('2/3'), findsOneWidget);
  });
}
