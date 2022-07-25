import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

void main() {
  runApp(MyApp());
}

//flutterant - Biometric Authentication
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final LocalAuthentication auth = LocalAuthentication();

  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });

      authenticated = await auth.authenticate(
          localizedReason: 'Let OS determine authentication method',
          options: const AuthenticationOptions(
            useErrorDialogs: true,
            stickyAuth: true
          )
      );

      setState(() {
        _isAuthenticating = false;
      });

    } on PlatformException catch (e) {
      print(e);
      setState(() {
        _isAuthenticating = false;
        _authorized = "Error - ${e.message}";
      });
      return;
    }
    if (!mounted) return;

    setState(() => _authorized = authenticated ? 'Authorized' : 'Not Authorized');
  }

  void _cancelAuthentication() async {
    await auth.stopAuthentication();
    setState(() => _isAuthenticating = false);
  }

//flutter - Biometric Authentication
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Biometric Authentication'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Current State: $_authorized\n'),
              (_isAuthenticating) ?
              ElevatedButton(
                 onPressed: _cancelAuthentication,
                 child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                       Text("Cancel Authentication"),
                        Icon(Icons.cancel),
                     ],
                 ),
              )
                  :
              Column(
                 children: [
                    ElevatedButton(
                       child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text('Authenticate'),
                            Icon(Icons.fingerprint),
                          ],
                       ),
                       onPressed: _authenticate,
                    ),
                 ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
