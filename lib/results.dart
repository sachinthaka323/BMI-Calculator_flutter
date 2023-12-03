import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart' hide User;

class BmiHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI History'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => UserForm()));
          },
        ),
      ),
      body: BmiHistoryList(),
    );
  }
}

class BmiHistoryList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return Center(child: Text('User not logged in'));
    }

    CollectionReference bmiCollection =
        FirebaseFirestore.instance.collection('history');

    return StreamBuilder<QuerySnapshot>(
      stream: bmiCollection.where('id', isEqualTo: user.uid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No BMI data available.'));
        }

        List<Widget> bmiEntries = [];
        for (QueryDocumentSnapshot doc in snapshot.data!.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          var date = data['date_time'];
          var name = data['name'];
          var height = data['height'];
          var weight = data['weight'];
          var bmi = data['BMI'];

          bmiEntries.add(
            ListTile(
              title: Text('Date: $date'),
              subtitle:
                  Text('Name: $name\nHeight: $height cm, Weight: $weight kg'),
              trailing: Text(
                'BMI: ${bmi.toStringAsFixed(2)}'
              ),
            ),
          );
        }
        SizedBox(
          height: 10,
        );
        return ListView(
          children: bmiEntries,
        );
      },
    );
  }
}
