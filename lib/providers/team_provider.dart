import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class TeamProvider with ChangeNotifier {
  bool _isLoading = false;

  bool get loading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<dynamic> createTeam(
      String uid,
      String adminId,
      String teamName,
      String city,
      String address1,
      String address2,
      String address3,
      String pincode) async {
    try {
      setLoading(true);
      print("Provier register");
      Response res =
          await http.post(Uri.parse("http://35.78.76.21:8000/team"), body: {
        "teamAdminUID": uid,
        "AdminID": adminId,
        "teamName": teamName,
        "teamCity": city,
        "addressLine1": address1,
        "addressLine2": address2,
        "addressLine3": address3,
        "pinCode": pincode,
        "state": "Maharashtra"
      });

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

  Future<dynamic> getTeamById(String id) async {
    try {
      setLoading(true);
      Response res =
          await http.get(Uri.parse("http://35.78.76.21:8000/getById/team/$id"));

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
    } catch (err) {
      print(err);
      setLoading(false);
    }
  }
}
