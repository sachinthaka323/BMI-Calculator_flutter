import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void savedata(
    name, address, gender, dob, age, weight, height, bmi, comment) async {
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference userdata = FirebaseFirestore.instance.collection('history');

  DateTime? datetime = DateTime.now();
  String finaldate = " ${datetime.year}-${datetime.month}-${datetime.day}";

  Map<String, dynamic> history = {
    "id": user?.uid,
    "date_time": finaldate,
    "name": name,
    'address': address,
    'gender': gender,
    'dob': dob,
    'age': age,
    "weight": weight,
    "height": height,
    "BMI": bmi,
    "comment": comment,
  };
  await userdata.add(history);
}
