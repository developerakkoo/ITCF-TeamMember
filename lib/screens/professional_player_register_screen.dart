import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teammember/screens/Login-screen.dart';
import 'package:teammember/screens/home-screen.dart';
import 'package:teammember/screens/otp-screen.dart';

import '../providers/auth_provider.dart';

class ProfessionalPlayerRegisterScreen extends StatefulWidget {
  const ProfessionalPlayerRegisterScreen({super.key});

  @override
  State<ProfessionalPlayerRegisterScreen> createState() =>
      _ProfessionalPlayerRegisterScreenState();
}

class _ProfessionalPlayerRegisterScreenState
    extends State<ProfessionalPlayerRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _firstName = '';
  String _lastName = '';
  String _email = '';
  String _age = "";
  String _dob = "";
  String _mobileNumber = '';
  String _postalAddress = '';
  String _specialization = '';
  DateTime _selectedDate = DateTime.now();

  List<String> _specializations = [
    'Batting',
    'Bowling',
    'All Rounder',
  ];

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Perform form submission logic here
      print('Submitted!');
      print('First Name: $_firstName');
      print('Email: $_email');
      print('Mobile Number: $_mobileNumber');
      print('Specialization: $_specialization');
      print('Age: $_age');
      print('Selected Date: $_selectedDate');
      Navigator.pushNamed(context, '/upload');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    var result;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          // titleTextStyle: TextStyle(),
          title: const Text(
            "Professional Player",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black),
          ),
          leading: InkWell(
              onTap: () => {
                    Navigator.push(
                        context,
                        PageTransition(
                            child: HomeScreen(),
                            type: PageTransitionType.leftToRight))
                  },
              child: Icon(Icons.arrow_back_ios_new, color: Colors.black)),
        ),
        body: authProvider.loading
            ? Center(
                child: LoadingAnimationWidget.bouncingBall(
                    color: Color(0xff5264F9), size: 30),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your first name';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _firstName = value!;
                                  },
                                  style: TextStyle(height: 1.6),
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xffE9F7FE),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue, width: 5.0),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff85D3FB), width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff85D3FB), width: 2.0),
                                    ),
                                    hintText: 'First Name',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            style: TextStyle(height: 1.6),
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color(0xffE9F7FE),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 5.0),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff85D3FB), width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff85D3FB), width: 2.0),
                              ),
                              hintText: 'Email',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your email';
                              }
                              // Add additional email validation logic if needed
                              return null;
                            },
                            onSaved: (value) {
                              _email = value!;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            style: TextStyle(height: 1.6),
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color(0xffE9F7FE),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 5.0),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff85D3FB), width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff85D3FB), width: 2.0),
                              ),
                              hintText: 'Mobile Number',
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your mobile number';
                              }
                              // Add additional email validation logic if needed
                              return null;
                            },
                            onSaved: (value) {
                              _mobileNumber = value!;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  style: TextStyle(height: 1.6),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your age';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _age = value!;
                                  },
                                  decoration: const InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xffE9F7FE),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.blue, width: 5.0),
                                    ),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff85D3FB), width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color(0xff85D3FB), width: 2.0),
                                    ),
                                    hintText: 'Age',
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                  child: TextFormField(
                                readOnly: true,
                                controller: TextEditingController(
                                    text: _formatDate(_selectedDate)),
                                style: TextStyle(height: 1.6),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your DOB';
                                  }
                                  return null;
                                },
                                onTap: () {
                                  _selectDate(context);
                                },
                                onSaved: (value) {
                                  _dob = value!;
                                },
                                decoration: const InputDecoration(
                                  filled: true,
                                  fillColor: Color(0xffE9F7FE),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.blue, width: 5.0),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xff85D3FB), width: 2.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xff85D3FB), width: 2.0),
                                  ),
                                  hintText: 'DOB',
                                ),
                              )),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          DropdownButtonFormField<String>(
                            style: TextStyle(height: 1.6, color: Colors.black),
                            value: _specialization.isNotEmpty
                                ? _specialization
                                : null,
                            decoration: const InputDecoration(
                              filled: true,
                              fillColor: Color(0xffE9F7FE),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blue, width: 2.0),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff85D3FB), width: 2.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff85D3FB), width: 2.0),
                              ),
                              hintText: 'Skill',
                            ),
                            items:
                                _specializations.map((String specialization) {
                              return DropdownMenuItem<String>(
                                value: specialization,
                                child: Text(specialization),
                              );
                            }).toList(),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a skill';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                _specialization = value!;
                              });
                            },
                            onSaved: (value) {
                              _specialization = value!;
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          MaterialButton(
                            minWidth: 200.0,
                            onPressed: () {
                              print("Pressed");
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                authProvider
                                    .registerProfessionalMember(
                                        _firstName,
                                        _email,
                                        _age,
                                        _dob,
                                        _mobileNumber,
                                        _specialization)
                                    .then((value) => {
                                          print(value),
                                          result = json.decode(value.body),
                                          print("VAlue returned is:- "),
                                          print(result),
                                          if (value.statusCode == 201)
                                            {
                                              print("Success"),
                                              print(result['message']),

                                              //Show snakbar
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          result['message']))),
                                            }
                                          else if (value.statusCode == 400)
                                            {
                                              print("400 error"),
                                              print(result['message']),

                                              //Show snakbar
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      content: Text(
                                                          result['message']))),
                                            }
                                          else
                                            {
                                              print(value.message),
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(SnackBar(
                                                      backgroundColor:
                                                          Colors.red,
                                                      content: Text(
                                                          result['message'])))
                                            }
                                        })
                                    .catchError((error) => {
                                          print(error),
                                        });
                              }
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            padding: const EdgeInsets.all(20.0),
                            child: Ink(
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Color.fromARGB(255, 82, 154, 249),
                                    Color.fromARGB(255, 82, 154, 249),
                                  ],
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0)),
                              ),
                              child: Container(
                                constraints: const BoxConstraints(
                                    minWidth: 230.0,
                                    minHeight:
                                        50.0), // min sizes for Material buttons
                                alignment: Alignment.center,
                                child: const Text(
                                  'Continue',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ));
  }
}
