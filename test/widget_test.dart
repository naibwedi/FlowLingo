import 'package:flutter_test/flutter_test.dart';
import 'package:flowlingo/main.dart';

void main() {
  testWidgets('renders FlowLingo onboarding shell', (WidgetTester tester) async {
    await tester.pumpWidget(const FlowLingoApp());
    await tester.pumpAndSettle();

    expect(find.text('FlowLingo'), findsOneWidget);
    expect(find.text('Translate while you type.'), findsOneWidget);
    expect(find.text('Open settings'), findsOneWidget);
  });
}
