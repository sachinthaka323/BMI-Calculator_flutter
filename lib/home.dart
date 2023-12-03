import 'package:flutter/material.dart';
import 'package:flutter_application_6/results.dart';
import 'package:flutter_application_6/save.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

String? user = FirebaseAuth.instance.currentUser!.email;
class User {
  String userName;
  String address;
  String gender;
  DateTime dateOfBirth;
  double weight;
  double height;
  

  User({
    required this.userName,
    required this.address,
    required this.gender,
    required this.dateOfBirth,
    required this.weight,
    required this.height,
  });
}

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
  
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  String _gender = 'Male';
  DateTime _selectedDate = DateTime.now();
  String _result = '';
  void _resetForm() {
  setState(() {
    _nameController.clear();
    _addressController.clear();
    _weightController.clear();
    _heightController.clear();
    _gender = 'Male';
    _selectedDate = DateTime.now();
    _result = '';
  });
}


  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text;
      String address = _addressController.text;
      String gender = _gender;
      DateTime dateOfBirth = _selectedDate;
      double weight = double.parse(_weightController.text);
      double height = double.parse(_heightController.text);

      User user = User(
        userName: name,
        address: address,
        gender: gender,
        dateOfBirth: dateOfBirth,
        weight: weight,
        height: height,
      );

      // Calculate age
      DateTime currentDate = DateTime.now();
      int age = currentDate.year - user.dateOfBirth.year;
      if (currentDate.month < user.dateOfBirth.month ||
          (currentDate.month == user.dateOfBirth.month &&
              currentDate.day < user.dateOfBirth.day)) {
        age--;
      }

      // Calculate BMI
      double bmi = user.weight / ((user.height / 100) * (user.height / 100));

      // Determine weight and height comment
      String comment = '';
      if (bmi < 18.5) {
        comment = 'Underweight';
      } else if (bmi >= 18.5 && bmi < 25) {
        comment = 'Normal weight';
      } else if (bmi >= 25 && bmi < 30) {
        comment = 'Overweight';
      } else {
        comment = 'Obese';
      }

      // Update the result text
      setState(() {
        _result =
            'Name: ${user.userName}\nAddress: ${user.address}\nGender: ${user.gender}\nDate of Birth: ${DateFormat('yyyy-MM-dd').format(user.dateOfBirth)}\nAge: $age\nWeight: ${user.weight} kg\nHeight: ${user.height} cm\nBMI: ${bmi.toStringAsFixed(2)}\nComment: $comment';
            savedata(user.userName, user.address,user.gender,user.dateOfBirth, age, user.weight, user.height, bmi, comment);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      
      appBar: AppBar(
        
        //title: Text(  'mySelf ',),
        centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
      
           const SizedBox(
            width: 10,
           ),
          const Text(
            'mySelf',
             style: TextStyle(color: Color.fromARGB(255, 238, 234, 234),fontWeight: FontWeight.bold),
           ),
        ],
        ),
        
      ),
      
      
      drawer: Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:AssetImage("images/one.jpg"),
                    fit: BoxFit.cover
                    )
                ),
                   child: Text("Header"),
                 ),
              const ListTile(
                  leading:Icon(Icons.home_filled),
                  title: Text("Home"),
                  
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => BmiHistoryPage()));
                  },
                  child: const ListTile(
                    leading:Icon(Icons.history),
                    title: Text('Profile'),
                    trailing: Icon(Icons.arrow_forward), // Add an icon or any other widget you prefer
                  ),
                ),

                const ListTile(
                  leading:Icon(Icons.settings),
                  title: Text("Setting"),
                  
                )
        ],
      ),
  ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/p.jpg"),
            fit: BoxFit.cover,
            
          )
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'User Name',
                      labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                      hintStyle: TextStyle(color: Colors.grey),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                          ),
                        ),
                        style: TextStyle(color: Color.fromARGB(255, 4, 2, 2),fontWeight: FontWeight.bold),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                  ),

                  
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      labelStyle: TextStyle(color:Colors.black,fontWeight: FontWeight.bold),
                      hintStyle: TextStyle(color: Colors.grey), // Change hint text color
                      enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                       ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                          ),
                    ),
                    style: TextStyle(color: Color.fromARGB(255, 4, 2, 2),fontWeight: FontWeight.bold),

                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Gender',
                    style: TextStyle(color: Color.fromARGB(255, 4, 2, 2),fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: <Widget>[
                      Radio(
                        value: 'Male',
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value.toString();
                          });
                        },
                      ),
                      Text(
                        'Male',
                        style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                        ),
                      Icon(Icons.male_outlined),
                      Radio(
                        value: 'Female',
                        
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value.toString();
                          });
                        },
                      ),
                      
                      Text(
                        'Female',
                        style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                        ),
                      Icon(Icons.female_outlined),
                    ],
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    'Date of Birth',
                    style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text(
                      'Select Date',
                      style: TextStyle(color: Color.fromARGB(255, 244, 242, 242),fontWeight: FontWeight.bold),
                      
                      ),
                  ),
                  

                  SizedBox(height: 10.0),
                  TextFormField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Weight (kg)',
                      labelStyle: TextStyle(color:Colors.black,fontWeight: FontWeight.bold)
                      
                      ),
                      style: TextStyle(color: Color.fromARGB(255, 22, 21, 21),fontWeight: FontWeight.bold),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your weight';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Height (cm)',
                      labelStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)
                    ),
                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your height';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                 Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _submitForm,
                            child: Text('Submit'),
                            ),
                        ),
                        SizedBox(width: 16.0),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _resetForm,
                            child: Text('Reset'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                  SizedBox(height: 16.0),
                  Text('Result:', style: TextStyle(fontSize: 18.0,color: Color.fromARGB(255, 4, 2, 2),fontWeight: FontWeight.bold)),
                  SizedBox(height: 8.0),
                 Text(
                  _result,
                  style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold,
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}