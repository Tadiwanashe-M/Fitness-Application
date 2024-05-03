 import 'package:flutter/material.dart';
import 'package:tadifitnessapp/components/heat_map.dart';
import 'package:tadifitnessapp/data/workout_data.dart';
import 'package:provider/provider.dart';
import 'workout_page.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';


class HomePage extends StatefulWidget {
   final String userName;

  const HomePage({Key? key, required this.userName}) : super(key: key);
  //const HomePage({Key? key}) : super(key: key);

  

  @override 
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _showDeleteIcon = false;
  String currentWeight = ''; // Current weight

  @override
  void initState() {
    super.initState();
    Provider.of<WorkoutData>(context, listen: false).initializeWorkoutList();
     currentWeight = readWeight();
    
  }

  final newWorkoutNameController = TextEditingController();
  final weightController = TextEditingController(); // Controller for weight
  final _myBox = Hive.box("workout_database1");
  final _myBox2 = Hive.box("weight_database1");
 

  void createNewWorkout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Create New Workout"),
        content: TextField(
          controller: newWorkoutNameController,
        ),
        actions: [
          TextButton(
            onPressed: save,
            child: Text("Save"),
          ),
          TextButton(
            onPressed: cancel,
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  void goToWorkoutPage(String workoutName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WorkoutPage(workoutName: workoutName),
      ),
    );
  }

  void save() {
    String newWorkoutName = newWorkoutNameController.text;
    Provider.of<WorkoutData>(context, listen: false)
        .addWorkout(newWorkoutNameController.text);
    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    newWorkoutNameController.clear();
  }

  void deleteWorkout(String workoutName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Deletion"),
        content: Text("Are you sure you want to delete this workout?"),
        actions: [
          TextButton(
            onPressed: () {
              Provider.of<WorkoutData>(context, listen: false)
                  .deleteWorkout(workoutName);
              Navigator.pop(context);
            },
            child: Text("Yes"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("No"),
          ),
        ],
      ),
    );
  }

  

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: /* Colors.blueGrey[900],*/Color.fromARGB(255, 158, 205, 207),
        appBar: AppBar(
          title: Text('EaziFit Workout Tracker'),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewWorkout,
          child: Icon(Icons.add),
          backgroundColor: Colors.blueAccent,
        ),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ListView(
                children: [
                  // Your existing widget content...
                  // Header Image (Placeholder)
                  Center(child: Image.asset('assets/app_logo3.png',fit: BoxFit.scaleDown,width: MediaQuery.sizeOf(context).width*0.7, height: MediaQuery.sizeOf(context).height*0.3,)), // Replace with your image
                  SizedBox(height: 20), // Add space between components

                  // HEAT MAP
                  Row(
  children: [
    Expanded(
      child: MyHeatMap(
        datasets: value.heatMapDataSet,
        startDateYYYYMMDD: value.getStartDate(),
      ),
    ),
    Spacer(),
  ],
),

                  SizedBox(height: 20), // Add space between components

                  // Workout List
                  Text(
                    'Your Workouts',
                    
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,)// color: Colors.white),
                  ),
                  SizedBox(
                    height: 500,
                    child: Expanded(
                      child: ListView.builder(
                        itemCount: value.getWorkoutList().length,
                        itemBuilder: (context, index) => GestureDetector(
                          onTap: () {
                            setState(() {
                              _showDeleteIcon = false; // Reset delete icon visibility
                            });
                            goToWorkoutPage(value.getWorkoutList()[index].name);
                          },
                          onLongPress: () {
                            setState(() {
                              if(_showDeleteIcon == false){
                                 _showDeleteIcon = true;
                              }
                              else{
                                _showDeleteIcon = false;
                              }
                           //   _showDeleteIcon = false;
                              
                            });
                           // _showDeleteIcon = false;
                          },
                          child: Card(
                            elevation: 3, // Add elevation for a card-like effect
                            margin: EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(value.getWorkoutList()[index].name),
                              trailing: _showDeleteIcon
                                  ? GestureDetector(
                                      onTap: () {
                                        deleteWorkout(value.getWorkoutList()[index].name);
                                      //  db.saveToDatabase(workoutList);
                                      },
                                      child: Icon(Icons.delete),
                                    )
                                  : null,
                              onTap: () => goToWorkoutPage(value.getWorkoutList()[index].name),
                              ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              bottom: 16.0,
              left: 16.0,
              child: GestureDetector(
                onTap: () => changeWeight(context),
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  color: Color.fromARGB(255, 149, 230, 230),
                  child: Text(
                    'Weight: $currentWeight kg',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
            ),
          ],
        ), 
         
    
      ),
      );
            
  } 

  void changeWeight(BuildContext context) {
    TextEditingController weightController = TextEditingController();
    String? currentWeight;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Change Weight"),
        content: TextField(
          controller: weightController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter your current weight',
            labelText: 'Weight (kg)',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              currentWeight = weightController.text;
              writeWeight(currentWeight);
              setState(() {
                this.currentWeight = currentWeight!;
              });
              Navigator.pop(context);
              weightController.clear();
            },
            child: Text("Save"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
        ],
      ),
    );
  }

  String readWeight() {
    return _myBox2.get("USER_WEIGHT", defaultValue: "") as String;
  }

  void writeWeight(String? weight) {
    _myBox2.put("USER_WEIGHT", weight);
  }
}