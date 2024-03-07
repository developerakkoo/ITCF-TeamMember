import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class AuthProvider with ChangeNotifier {
  //App/api/v1/signUp

  bool _isLoading = false;

  bool get loading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<dynamic> register(String fName, String fatherName, String email,
      String age, String dob, String phoneNumber, String specialisation) async {
    try {
      setLoading(true);

      print("Provier register");
      Response res = await http
          .post(Uri.parse("http://35.78.76.21:8000/App/api/v1/signUp"), body: {
        "fName": fName,
        "lName": fatherName,
        "age": age,
        "DOB": dob,
        "email": email,
        "Phone": phoneNumber,
        "Skills": specialisation,
      });

      print(res.body);
      if (res.statusCode == 201) {
        print(res.body);
        setLoading(false);

        print("Successfull");
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
      return e;
    }
  }

  Future<dynamic> registerProfessionalMember(String fName, String email,
      String age, String dob, String phoneNumber, String specialisation) async {
    try {
      setLoading(true);

      print("Provier register");
      Response res =
          await http.post(Uri.parse("http://35.78.76.21:8000/player"), body: {
        "Name": fName,
        "age": age,
        "DOB": dob,
        "email": email,
        "Phone": phoneNumber,
        "Skills": specialisation,
        "isProfessionalMember": "true"
      });

      print(res.body);
      if (res.statusCode == 201) {
        print(res.body);
        setLoading(false);

        print("Successfull");
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
      return e;
    }
  }

  Future<dynamic> login(String uid) async {
    try {
      setLoading(true);

      print("Provier register");
      Response res = await http.post(
          Uri.parse("http://35.78.76.21:8000/App/api/v1/auth/signIn"),
          body: {
            "id": uid,
          });

      print(res.body);
      if (res.statusCode == 200) {
        print(res.body);
        setLoading(false);

        print("Successfull");
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
      return e;
    }
  }

  Future<dynamic> sendOtp(String number) async {
    try {
      Response res = await http.post(
          Uri.parse("http://35.78.76.21:8000/App/verifyUser/sendOtp"),
          body: {
            "phonenumber": number,
          });
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
    } catch (err) {
      print("Error in provider $err");
      setLoading(false);
    }
  }

  Future<dynamic> verifyOtp(String number, String code) async {
    try {
      Response res = await http
          .post(Uri.parse("http://35.78.76.21:8000/App/User/verify"), body: {
        "phonenumber": number,
        "code": code,
      });
      print(res.body);
      if (res.statusCode == 200) {
        print(res.body);
        setLoading(false);

        print("Successfull");
      } else {
        print("Failure");
        print(res.body);
        setLoading(false);
        return res as Response;
      }

      return res as Response;
    } catch (err) {
      print("Error in provider $err");
      setLoading(false);
    }
  }
}
