import 'dart:math';

class PaymentService {
  PaymentService({Random? random}) : _random = random ?? Random();

  final Random _random;

  Future<bool> simulatePayment({bool allowFailure = false}) async {
    await Future<void>.delayed(
      Duration(seconds: 2 + _random.nextInt(2)),
    );

    if (allowFailure) {
      return _random.nextInt(5) != 0;
    }

    return true;
  }
}
