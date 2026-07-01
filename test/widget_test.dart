import 'package:dcg_crisis_guard/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows authentication screen first', (tester) async {
    await tester.pumpWidget(const DcgApp());

    expect(find.text('Sign in'), findsOneWidget);
    expect(find.text('Create a new account'), findsOneWidget);
  });
}
