import 'package:flutter_test/flutter_test.dart';
import 'package:portfolio_yoush_kk/main.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    expect(find.text('<SouravKK />'), findsOneWidget);
  });
}
