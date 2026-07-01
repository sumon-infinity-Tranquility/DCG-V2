import 'package:dcg_crisis_guard/main.dart';
import 'package:dcg_crisis_guard/services/local_auth_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows authentication screen first', (tester) async {
    await tester.pumpWidget(DcgApp(authRepository: LocalAuthRepository()));

    expect(find.text('Sign in'), findsWidgets);
    expect(find.text('Create a new account'), findsOneWidget);
  });
}
