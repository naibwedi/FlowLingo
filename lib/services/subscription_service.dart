import 'package:purchases_flutter/purchases_flutter.dart';

class SubscriptionService {
  Future<void> configure() {
    // RevenueCat public SDK key will be wired in during Milestone 5.
    return Purchases.setLogLevel(LogLevel.warn);
  }
}
