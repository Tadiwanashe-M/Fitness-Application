import 'package:flutter/material.dart';
import 'package:tadifitnessapp/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/app_logo3.png',
              height: 100,
            ),
            SizedBox(height: 20),
            Text(
              'Welcome to EaziFitness',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Track your fitness journey with us!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: nameController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Name/Nickname',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final String name = nameController.text;
                if (name.isNotEmpty) {
                  final Box<String> box = await Hive.openBox<String>('user_data');
                  await box.put('user_name', name);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomePage(userName: name),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
               // primary: Colors.orange,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: Text(
                'Get Started',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Stay motivated and achieve your fitness goals!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lock,
                  color: Colors.white,
                ),
                SizedBox(width: 5),
                Text(
                  'Your privacy is our top priority',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
