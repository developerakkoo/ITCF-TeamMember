import 'package:flutter/material.dart';

class AddPlayerWidget extends StatefulWidget {
  final String name;
  final String number;
  const AddPlayerWidget({
    Key? key,
    required this.name,
    required this.number,
  }) : super(key: key);

  @override
  State<AddPlayerWidget> createState() => _AddPlayerWidgetState();
}

class _AddPlayerWidgetState extends State<AddPlayerWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var nameCtrl = TextEditingController();
    var numberCtrl = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 1.0, color: Colors.black),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/avatar.png'),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      style: TextStyle(color: Colors.white),
                      controller: nameCtrl,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                      ),
                    ),
                    TextField(
                      style: TextStyle(color: Colors.white),
                      controller: numberCtrl,
                      decoration: InputDecoration(
                        labelStyle: TextStyle(color: Colors.white),
                        labelText: 'Mobile Number',
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Add your button click logic here
                        },
                        child: Text('Add as a New Player'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
