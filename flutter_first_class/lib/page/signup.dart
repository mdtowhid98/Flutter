import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController dob = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  String? gender; // Variable to hold the selected gender

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now())
      setState(() {
        dob.text = "${picked.toLocal()}".split(' ')[0]; // Format as YYYY-MM-DD
      });
  }

  void _signup() {
    if (name.text.isEmpty ||
        email.text.isEmpty ||
        phone.text.isEmpty ||
        address.text.isEmpty ||
        dob.text.isEmpty ||
        password.text.isEmpty ||
        confirmPassword.text.isEmpty ||
        gender == null) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    if (password.text != confirmPassword.text) {
      // Passwords do not match
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    // All validations passed
    String nam = name.text;
    String em = email.text;
    String phn = phone.text;
    String add = address.text;
    String db = dob.text;
    String pass = password.text;
    print('Name: $nam, Email: $em, Gender: $gender, Phone: $phn, DOB: $db, Address: $add, Password: $pass');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView( // Make the entire page scrollable
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: name,
                decoration: InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: email,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 15),

              // Gender Radio Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("Gender: "),
                  Radio<String>(
                    value: "Male",
                    groupValue: gender,
                    onChanged: (String? value) {
                      setState(() {
                        gender = value;
                      });
                    },
                  ),
                  Text("Male"),
                  Radio<String>(
                    value: "Female",
                    groupValue: gender,
                    onChanged: (String? value) {
                      setState(() {
                        gender = value;
                      });
                    },
                  ),
                  Text("Female"),
                  Radio<String>(
                    value: "Others",
                    groupValue: gender,
                    onChanged: (String? value) {
                      setState(() {
                        gender = value;
                      });
                    },
                  ),
                  Text("Others"),
                ],
              ),
              SizedBox(height: 15),

              TextField(
                controller: phone,
                decoration: InputDecoration(
                  labelText: "Phone",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 15),

              TextField(
                controller: dob,
                decoration: InputDecoration(
                  labelText: "Date Of Birth",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDate(context), // Show date picker
              ),
              SizedBox(height: 15),

              TextField(
                controller: address,
                decoration: InputDecoration(
                  labelText: "Address",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.home),
                ),
              ),
              SizedBox(height: 15),

              TextField(
                controller: password,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),

              TextField(
                controller: confirmPassword,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20),

              ElevatedButton(
                onPressed: _signup,
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.lato().fontFamily,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.lightGreenAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
