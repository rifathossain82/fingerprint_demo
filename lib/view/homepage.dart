import 'package:fingerprint_demo/services/local_auth_api.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {

  bool hasBiometric = false;
  bool isAuthenticate = false;

  @override
  void initState() {
    checkBiometric();
    super.initState();
  }

  checkBiometric()async{
    hasBiometric = await LocalAuthApi().hasBiometrics();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fingerprint Demo'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: hasBiometric ?
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isAuthenticate ? 'Authenticate' : 'Not Authenticate',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue),),
            SizedBox(height: 20,),
            TextButton(
              onPressed: ()async{
                isAuthenticate = await LocalAuthApi().authenticate();
                setState(() {});
              },
              child: Icon(Icons.fingerprint,size: 80,),
            )
          ],
        )
            :
        Text("You are not eligible for biometric"),
      ),
    );
  }
}
