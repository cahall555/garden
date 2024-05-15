import 'package:flutter/material.dart';
import 'dart:async';
import 'garden_list.dart';
import '../model/user.dart';
import '../model/apis/auth_api.dart';
import '../provider/auth_provider.dart';
import 'package:provider/provider.dart';

class AuthCreate extends StatefulWidget {
  const AuthCreate({Key? key}) : super(key: key);

  @override
  State<AuthCreate> createState() => _AuthCreateState();
}

class _AuthCreateState extends State<AuthCreate> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('User Login', style: TextStyle(fontFamily: 'Taviraj')),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/garden.webp"),
            fit: BoxFit.cover,
            opacity: 0.15,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            TextField(
              style: TextStyle(
                  color: Color(0XFF987D3F),
                  fontFamily: 'Taviraj',
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle:
                    TextStyle(color: Color(0XFF987D3F), fontFamily: 'Taviraj'),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFF987D3F))),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0XFF987D3F)),
                ),
              ),
              controller: _emailController,
            ),
            const SizedBox(height: 20.0),
            TextField(
              style: TextStyle(
                  color: Color(0XFF987D3F),
                  fontFamily: 'Taviraj',
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle:
                    TextStyle(color: Color(0XFF987D3F), fontFamily: 'Taviraj'),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFF987D3F))),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0XFF987D3F)),
                ),
              ),
              controller: _passwordController,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              style: ButtonStyle(
                elevation: MaterialStateProperty.all<double>(12.0),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.transparent),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
              onPressed: () {
                if (_emailController.text.isNotEmpty &&
                    _passwordController.text.isNotEmpty) {
                  userLogin();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill in all fields')),
                  );
                }
              },
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFED16A),
                      Color(0xFF987D3F),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Container(
                  constraints: BoxConstraints(minWidth: 108.0, minHeight: 45.0),
                  alignment: Alignment.center,
                  child: const Text('Login',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontFamily: 'Taviraj')),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void userLogin() async {
    try {
 	print('1) sending createAuthApi: ${_emailController.text.trim()}');
     final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.createAuth({
        'email': _emailController.text.trim(),
        'password': _passwordController.text.trim(),
      });
      print('createAuthApi sent: ${_emailController.text.trim()}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login successful!')),
      );
//      iNavigator.of(context).push(
//        MaterialPageRoute(
//          builder: (context) =>
//              GardenList(), //update to farm list when farm is available
//        ),
//      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to login: $e')),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
