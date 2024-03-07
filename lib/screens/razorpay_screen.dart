import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayScreen extends StatefulWidget {
  const RazorpayScreen({super.key});

  @override
  State<RazorpayScreen> createState() => _RazorpayScreenState();
}

class _RazorpayScreenState extends State<RazorpayScreen> {
  final _razorpay = Razorpay();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              var options = {
                'key': 'rzp_test_NZPT7cTtpJaWr2',
                'amount': 100 * 100,
                'name': 'Pivot Technosports Private Limited.',
                'description': 'Pay for Player',
                'prefill': {
                  'contact': '8888888888',
                  'email': 'test@razorpay.com'
                }
              };
              _razorpay.open(options);
            },
            child: Text("Pay")),
      ),
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    print("Payment Success");
    print(response.orderId);
    print(response.paymentId);
    print(response.signature);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print("Payment failed");

    print(response.code);
    print(response.error);
    print(response.message);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    print(response.walletName);
  }
}
