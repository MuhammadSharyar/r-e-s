// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class ResultPage extends StatelessWidget {
//   final User? user = FirebaseAuth.instance.currentUser;

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance.collection('results').snapshots(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }

//         List<QueryDocumentSnapshot> documents = snapshot.data!.docs;

//         if (user != null && user!.role == 'student') {
//           documents =
//               documents.where((doc) => doc['studentId'] == user!.uid).toList();
//         }

//         return GridView.builder(
//           padding: EdgeInsets.all(8),
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
//             crossAxisSpacing: 8,
//             mainAxisSpacing: 8,
//             childAspectRatio: MediaQuery.of(context).size.width /
//                 (MediaQuery.of(context).size.height / 2),
//           ),
//           itemCount: documents.length,
//           itemBuilder: (context, index) {
//             Map<String, dynamic> data = documents[index].data();
//             String courseName = data['courseName'];
//             int marks = data['marks'];
//             return ResultCard(
//               courseName: courseName,
//               marks: marks,
//             );
//           },
//         );
//       },
//     );
//   }
// }

// class ResultCard extends StatelessWidget {
//   final String courseName;
//   final int marks;

//   ResultCard({required this.courseName, required this.marks});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             courseName,
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 16),
//           Text(
//             '$marks marks',
//             style: TextStyle(fontSize: 18),
//           ),
//         ],
//       ),
//     );
//   }
// }
