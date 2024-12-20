import 'package:flutter/material.dart';
import 'dart:async';
import 'garden_list.dart';
import '../model/users_account.dart';
import '../model/user.dart';
import '../model/apis/auth_api.dart';
import '../model/apis/users_account_api.dart';
import '../provider/users_account_provider.dart';
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
  UserAccounts? userAccounts;
  bool obscureText = true;

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
              obscureText: obscureText,
              style: TextStyle(
                  color: Color(0XFF987D3F),
                  fontFamily: 'Taviraj',
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Color(0XFF987D3F),
                  ),
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                ),
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
      if (_emailController.text.trim().isNotEmpty ||
          _passwordController.text.trim().isNotEmpty) {
        print('sending createAuthApi: ${_emailController.text.trim()}');
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        User login = await authProvider.createAuth({
          'email': _emailController.text.trim(),
          'password': _passwordController.text.trim(),
        });
        print('createAuthApi sent: ${_emailController.text.trim()}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful!')),
        );
        if (login.id != null) {
          var userId = login.id;
          UsersAccountsProvider usersAccountsProvider =
              Provider.of<UsersAccountsProvider>(context, listen: false);

          print('User ID: $userId');
          userAccounts = await usersAccountsProvider.fetchUserAccount(userId);
          print('User Accounts: $userAccounts');

          if (userAccounts != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => GardenList(
                  userAccounts: userAccounts!,
                ),
              ),
            );
          }
        }
      } else {
        throw Exception('Email and password cannot be empty');
      }
    } catch (e) {
      print('Error logging in: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to login.')),
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
