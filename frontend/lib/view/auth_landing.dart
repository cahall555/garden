import 'package:flutter/material.dart';
import 'dart:async';
import 'garden_list.dart';
import 'user_create.dart';
import 'auth_login.dart';
import '../model/user.dart';
import '../model/apis/auth_api.dart';
import '../provider/auth_provider.dart';
import 'package:provider/provider.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome', style: TextStyle(fontFamily: 'Taviraj')),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/garden.webp"),
            fit: BoxFit.cover,
            opacity: 0.15,
          ),
        ),
        alignment: Alignment.center,
        child: authProvider.email.isNotEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('So nice to see you ${authProvider.FirstName}',
                      style: TextStyle(fontFamily: 'Taviraj', fontSize: 20.0)),
                  //Add Farm List when available
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
                     // authProvider.logOut();
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
                        constraints:
                            BoxConstraints(minWidth: 108.0, minHeight: 45.0),
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
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const UserCreate()));
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
                        constraints:
                            BoxConstraints(minWidth: 108.0, minHeight: 45.0),
                        alignment: Alignment.center,
                        child: const Text('Register',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0,
                                fontFamily: 'Taviraj')),
                      ),
                    ),
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
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AuthCreate()));
		      print('Login button pressed');
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
                        constraints:
                            BoxConstraints(minWidth: 108.0, minHeight: 45.0),
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
}
