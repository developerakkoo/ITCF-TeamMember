import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:teammember/providers/team_provider.dart';
import 'package:teammember/screens/add-player-to-team-screen.dart';
import 'package:teammember/screens/home-screen.dart';

import 'package:http_parser/http_parser.dart';

class CreateTeamScreen extends StatefulWidget {
  const CreateTeamScreen({super.key});

  @override
  State<CreateTeamScreen> createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  String? fileName;
  File? selectedTeamImage;

  final _formKey = GlobalKey<FormState>();
  String _teamName = '';
  String _uid = '';
  String _adminId = '';
  String _teamId = '';
  String _addressOne = '';
  String _addressTwo = '';
  String _addressThree = '';
  String _pincode = '';
  String _state = '';
  String _city = '';
  bool _isPayforWholeTeam = false;
  bool _isTeamMemberPay = true;

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _uid = prefs.getString("id")!;
    _adminId = prefs.getString("adminId")!;
    print(_uid);
    print(_adminId);
  }

  void pickImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        // print(result.files.single.path.toString());
        fileName = result.files.single.name.toString();
        print(fileName);
        print("---------");
        print(selectedTeamImage);
        setState(() {
          selectedTeamImage = File(result.files.single.path!);
          _uploadFile();
        });
      } else {
        // User canceled the picker
      }
    } catch (err) {
      print(err);
    }
  }

  Future<void> _uploadFile() async {
    if (selectedTeamImage == null) {
      return;
    }

    FormData formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(selectedTeamImage!.path,
          filename: fileName, contentType: new MediaType('pdf', 'png')),
    });

    print("Selected Panfile: $selectedTeamImage ");
    print("Selected NAme: $fileName ");
    Dio dio = Dio();

    var response = await dio
        .put(
          'http://35.78.76.21:8000/upload/teamLogo/Team/$_teamId',
          data: formData,
          options: Options(headers: {
            "accept": "*/*",
            "Authorization": "Bearer token",
            "Content-Type": "multipart/form-data"
          }),
          onSendProgress: (int sent, int total) {
            setState(() {
              // progressPan = ((sent / total) * 90);
            });
          },
        )
        .then((success) => {
              print(success),
              print(success.statusCode),
              print("-----RESPONSE------"),
              setData()
            })
        .catchError((error) => {print(error)});
  }

  void setData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString("teamId", _teamId);
    prefs.setBool("isPayforWholeTeam", _isPayforWholeTeam);
    Navigator.push(
        context,
        PageTransition(
            child: AddPlayerToTeam(), type: PageTransitionType.rightToLeft));
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isChecked = false;
    var result;
    final teamProvider = Provider.of<TeamProvider>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
        // titleTextStyle: TextStyle(),
        title: const Text(
          "Create your Team",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white),
        ),
        leading: InkWell(
            onTap: () => {
                  Navigator.push(
                      context,
                      PageTransition(
                          child: HomeScreen(),
                          type: PageTransitionType.leftToRight))
                },
            child: Icon(Icons.arrow_back_ios_new, color: Colors.white)),
      ),
      body: teamProvider.loading
          ? Center(
              child: LoadingAnimationWidget.bouncingBall(
                  color: Color(0xff5264F9), size: 30),
            )
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: () {},
                          child: Image.asset("assets/images/upload.png")),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Team Name';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _teamName = newValue!;
                          },
                          decoration: new InputDecoration(
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white70, width: 2.0),
                              ),
                              hintText: 'Team Name*',
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Team City';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _city = newValue!;
                          },
                          decoration: new InputDecoration(
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white70, width: 2.0),
                              ),
                              hintText: 'City/Town*',
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter address';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _addressOne = newValue!;
                          },
                          decoration: new InputDecoration(
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white70, width: 2.0),
                              ),
                              hintText: 'Address Line 1*',
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter address';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _addressTwo = newValue!;
                          },
                          decoration: new InputDecoration(
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white70, width: 2.0),
                              ),
                              hintText: 'Address Line 2*',
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter address';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _addressThree = newValue!;
                          },
                          decoration: new InputDecoration(
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white70, width: 2.0),
                              ),
                              hintText: 'Address Line 3*',
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: TextFormField(
                          style: TextStyle(color: Colors.white),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter pincode';
                            }
                            return null;
                          },
                          onSaved: (newValue) {
                            _pincode = newValue!;
                          },
                          decoration: new InputDecoration(
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 2.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.white70, width: 2.0),
                              ),
                              hintText: 'Pincode*',
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                      MaterialButton(
                        minWidth: 200.0,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            print(_addressOne);
                            print(_addressTwo);
                            print(_addressThree);
                            print(_city);
                            print(_teamName);
                            print(_pincode);

                            teamProvider
                                .createTeam(
                                    _uid,
                                    _adminId,
                                    _teamName,
                                    _city,
                                    _addressOne,
                                    _addressTwo,
                                    _addressThree,
                                    _pincode)
                                .then((value) => {
                                      print(value),
                                      result = json.decode(value.body),
                                      print("VAlue returned is:- "),
                                      print(result),
                                      if (value.statusCode == 200)
                                        {
                                          print("Success"),
                                          print(result['message']),
                                          _teamId = result['data']['_id'],
                                          print("Team Id $_teamId"),
                                          showModalBottomSheet(
                                              isScrollControlled: false,
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  Container(
                                                    child: Wrap(
                                                      alignment:
                                                          WrapAlignment.center,
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            const SizedBox(
                                                              height: 30,
                                                            ),
                                                            const Text(
                                                              "Upload Team Image",
                                                              style: TextStyle(
                                                                  fontSize: 25,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color: Color(
                                                                      0xff5264F9)),
                                                            ),
                                                            const SizedBox(
                                                              height: 70,
                                                            ),

                                                            //Add  a Image to select files and on click pick image
                                                            GestureDetector(
                                                              onTap: pickImage,
                                                              child: Image.asset(
                                                                  "assets/images/upload.png"),
                                                            ),
                                                            //Once image is picked upload image and if  uploaded go to next screeen
                                                            const SizedBox(
                                                              height: 70,
                                                            ),
                                                            MaterialButton(
                                                              minWidth: 200.0,
                                                              onPressed: () {
                                                                _uploadFile();
                                                              },
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              8.0)),
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      20.0),
                                                              child: Ink(
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  gradient:
                                                                      LinearGradient(
                                                                    colors: <
                                                                        Color>[
                                                                      Color.fromARGB(
                                                                          255,
                                                                          82,
                                                                          154,
                                                                          249),
                                                                      Color.fromARGB(
                                                                          255,
                                                                          82,
                                                                          154,
                                                                          249),
                                                                    ],
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              8.0)),
                                                                ),
                                                                child:
                                                                    Container(
                                                                  constraints: const BoxConstraints(
                                                                      minWidth:
                                                                          230.0,
                                                                      minHeight:
                                                                          50.0), // min sizes for Material buttons
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child:
                                                                      const Text(
                                                                    'UPLOAD',
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ))
                                        }
                                      else if (value.statusCode == 404)
                                        {
                                          print("400 error"),
                                          print(result['message']),

                                          //Show snakbar
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  content:
                                                      Text(result['message']))),
                                        }
                                      else
                                        {
                                          print(value.message),
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  backgroundColor: Colors.red,
                                                  content:
                                                      Text(result['message'])))
                                        }
                                    })
                                .catchError((err) => {print(err)});
                          }

                          // Navigator.push(
                          //     context,
                          //     PageTransition(
                          //         child: AddPlayerToTeam(),
                          //         type: PageTransitionType.bottomToTop));
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
                  ),
                ),
              ),
            ),
    );
  }
}
