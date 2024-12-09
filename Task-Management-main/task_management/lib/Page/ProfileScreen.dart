import 'package:flutter/material.dart';
import 'package:task_management/service/ApiService.dart';


class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _profileData;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  void _loadProfile() async {
    try {
      final data = await ApiService.getProfile();
      setState(() {
        _profileData = data['data'];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: _profileData == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(
                  'http://206.189.138.45:8052/uploads/${_profileData!['image']}'),
              radius: 50,
            ),
            Text('Name: ${_profileData!['firstName']} ${_profileData!['lastName']}'),
            Text('Email: ${_profileData!['email']}'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/update-profile');
              },
              child: Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
