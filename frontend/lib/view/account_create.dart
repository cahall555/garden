import 'package:flutter/material.dart';
import 'dart:async';
import 'garden_list.dart';
import '../model/account.dart';
import '../model/user.dart';
import '../model/users_account.dart';
import '../model/apis/account_api.dart';
import '../model/apis/users_account_api.dart';
import '../provider/account_provider.dart';
import '../provider/users_account_provider.dart';
import 'package:provider/provider.dart';

class AccountCreate extends StatefulWidget {
  final User user;
  const AccountCreate({Key? key, required this.user}) : super(key: key);

  @override
  State<AccountCreate> createState() => _AccountCreateState();
}

class _AccountCreateState extends State<AccountCreate> {
   String? _currentPlanValue;
  final List<String> _planValues = [
    "Free",
    "Basic",
    "Premium",
  ];

  @override
  Widget build(BuildContext context) {
    AccountProvider accountProvider = Provider.of<AccountProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Account', style: TextStyle(fontFamily: 'Taviraj')),
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
            const SizedBox(height: 20.0),
            DropdownButtonFormField<String>(
              style: TextStyle(color: Color(0xFF263B61), fontFamily: 'Taviraj'),
              decoration: InputDecoration(
                labelText: "Plan",
                labelStyle:
                    TextStyle(color: Color(0xFF263B61), fontFamily: 'Taviraj'),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF263B61))),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF263B61)),
                ),
              ),
              value: _currentPlanValue,
              onChanged: (String? newPlanValue) {
                setState(() {
                  _currentPlanValue = newPlanValue;
                });
              },
              items: _planValues.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,
                      style: TextStyle(
                          color: _currentPlanValue == value
                              ? Color(0xFF4E7AC7)
                              : Color(0xFF263B61),
                          fontFamily: 'Taviraj',
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0)),
                );
              }).toList(),
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
                if (_currentPlanValue?.isNotEmpty ?? false) {
                  submitAccount();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select a plan.')),
                  );
                }
              },
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF4E7AC7),
                      Color(0xFF263B61),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Container(
                  constraints: BoxConstraints(minWidth: 108.0, minHeight: 45.0),
                  alignment: Alignment.center,
                  child: const Text('Submit',
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

  void submitAccount() async {
    try {
      final accountProvider =
          Provider.of<AccountProvider>(context, listen: false);
      if (widget.user != null) {
        print('User ID: ${widget.user!.id}');
        Account newAccount = await accountProvider.createAccount({
          'plan': _currentPlanValue,
        });

        if (newAccount.id != null) {
          var accountId = newAccount.id;
          print('New Account: $newAccount');
          print('User ID: ${widget.user!.id} Account ID: ${accountId}');
          UsersAccountsProvider usersAccountsProvider =
              Provider.of<UsersAccountsProvider>(context, listen: false);
          UserAccounts newUserAccounts =
              await usersAccountsProvider.createUserAccounts({
            'user_id': widget.user!.id,
            'account_id': accountId,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Account created successfully!')),
          );
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => GardenList(
                  userAccounts:
                      newUserAccounts),
            ),
          );
        } else {
          throw Exception('Account ID is null');
        }
      } else {
        throw Exception('User is null');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create account: $e')),
      );
    }
  }
}
