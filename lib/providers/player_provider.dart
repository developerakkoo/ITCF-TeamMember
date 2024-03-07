import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:teammember/models/bulk_player_modal.dart';
import 'package:teammember/models/player_modal.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class PlayerProvider with ChangeNotifier {
  bool _isLoading = false;
  final _razorpay = Razorpay();
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  List<PlayerModal> _players = [];
  List<PlayerModalBulk> _playersbulk = [];

  bool get loading => _isLoading;

  get players => _players;
  get playerList => _players;
  // get playerListBulk => playersbulk;
  List<PlayerModalBulk> get playersbulk => _playersbulk;

  addPlayer(PlayerModal player) {
    print(player.number);
    _players.add(player);
    notifyListeners();
  }

  removePlayer(PlayerModal player) {
    _players.remove(player);
    notifyListeners();
  }

  void toggleSelection(int index) {
    _players[index].isSelected = !_players[index].isSelected;
    notifyListeners();
  }

  List<int> getSelectedPlayerIndices() {
    List<int> selectedIndices = [];
    for (int i = 0; i < _playersbulk.length; i++) {
      if (_playersbulk[i].isSelected) {
        selectedIndices.add(i);
      }
    }
    return selectedIndices;
  }

  List<PlayerModalBulk> getSelectedPlayers() {
    return _playersbulk.where((player) => player.isSelected).toList();
  }

  PlayerModal getPlayerByIndex(int index) {
    // if (index < 0 || index >= _players.length) {
    //   throw Exception('Invalid index');
    // }
    return _players[index];
  }

  addPlayerBulk(PlayerModalBulk player) {
    print(player.number);
    _playersbulk.add(player);
    notifyListeners();
  }

  removePlayerBulk(PlayerModalBulk player) {
    _playersbulk.remove(player);
    notifyListeners();
  }

  clearPlayerList() {
    _players.clear();
    _playersbulk.clear();
    notifyListeners();
  }

  void setValuesAtZeroIndex(String name, String number, bool isSelected) {
    if (playerList.isNotEmpty) {
      playerList[0] = PlayerModal(name, number, "", isSelected);
    }
  }

  makePayment() {
    var amount = playersbulk.length * 300;
    var options = {
      'key': 'rzp_test_NZPT7cTtpJaWr2',
      'amount': amount * 100,
      'name': 'Pivot Technosports Private Limited.',
      'description': 'Fees',
      // 'prefill': {
      //   'contact': '8888888888',
      //   'email': 'test@razorpay.com'
      // }
    };
    _razorpay.open(options);

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<dynamic> AddBulkPlayers(String teamId, String teamAdminId,
      List<Map<String, dynamic>> items) async {
    try {
      setLoading(true);
      print("Provier bulk");
      String jsonBody = json.encode(items);
      print(jsonBody);
      Response res = await http.post(
          Uri.parse(
              "http://35.78.76.21:8000/TeamAdmin/bulkCreate/$teamAdminId/$teamId"),
          body: {"Players": jsonBody});

      print(res.body);
      if (res.statusCode == 200) {
        print(res.body);
        setLoading(false);
        print("Successfull");
        return res as Response;
      } else {
        print("Failure");
        print(res.body);
        setLoading(false);
        return res as Response;
      }

      return res as Response;
    } catch (e) {
      setLoading(false);
      print(e);
    }
  }

  Future<dynamic> AddSinglePlayers(
      String teamId, String teamAdminId, String name, String number) async {
    try {
      setLoading(true);
      print("Provier bulk");
      print(name);
      print(number);
      Response res = await http.post(
          Uri.parse("http://35.78.76.21:8000/add/player/$teamAdminId/$teamId"),
          body: {"Name": name, "Phone": number, "AdminID": teamAdminId});

      print(res.body);
      if (res.statusCode == 201) {
        print(res.body);
        setLoading(false);

        print("Successfull");
        return res as Response;
      } else {
        print("Failure");
        print(res.body);
        setLoading(false);
        return res as Response;
      }

      return res as Response;
    } catch (e) {
      setLoading(false);
      print(e);
    }
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
