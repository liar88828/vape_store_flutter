// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vape_store/main.dart';
import 'package:vape_store/network/bank_network.dart';
import 'package:vape_store/network/checkout_network.dart';
import 'package:vape_store/network/delivery_network.dart';
import 'package:vape_store/network/favorite_network.dart';
import 'package:vape_store/network/product_network.dart';
import 'package:vape_store/network/trolley_network.dart';
import 'package:vape_store/network/user_network.dart';
import 'package:vape_store/repository/preferences_repo.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp(
      preferencesRepository: PreferencesRepository(),
      userNetwork: UserNetwork(),
      trolleyNetwork: TrolleyNetwork(),
      productNetwork: ProductNetwork(),
      favoriteNetwork: FavoriteNetwork(),
      bankNetwork: BankNetwork(),
      deliveryNetwork: DeliveryNetwork(),
      checkoutNetwork: CheckoutNetwork(),
    ));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
