import 'package:flutter/material.dart';
import '../../../theme/theme_constants.dart';

class StudentDetails extends StatelessWidget {
  var name, email, contact, address, gender, permissions;

  StudentDetails({
    Key? key,
    required this.name,
    required this.email,
    required this.contact,
    required this.address,
    required this.gender,
    required this.permissions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Details"),
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: const EdgeInsets.all(18.0),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Name :\t",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: large,
                      ),
                    ),
                    Text(
                      name,
                      maxLines: 3,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: large,
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.black),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Email :\t",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: large,
                      ),
                    ),
                    Text(
                      email,
                      style: TextStyle(
                        fontSize: large,
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.black),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Contact :\t",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: large,
                      ),
                    ),
                    Text(
                      contact,
                      style: TextStyle(
                        fontSize: large,
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.black),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Address :\t",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: large,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        address,
                        maxLines: 3,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontSize: large,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.black),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Gender :\t",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: large,
                      ),
                    ),
                    Text(
                      gender,
                      style: TextStyle(
                        fontSize: large,
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.black),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
