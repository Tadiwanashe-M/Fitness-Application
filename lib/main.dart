import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
import 'package:tadifitnessapp/data/workout_data.dart';
import 'package:tadifitnessapp/pages/home_page.dart';
import 'package:tadifitnessapp/pages/login_page.dart';

void main() async {
  // initialize hive
  await Hive.initFlutter();

  // open a hive box
  await Hive.openBox("workout_database1");
  await Hive.openBox("weight_database1"); // Open the box before using it
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WorkoutData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const LoginPage(), // Start with the login page
      ),
    );
  }
}
