import 'package:flutter/material.dart';
import 'package:tadifitnessapp/data/hive_database.dart';
import 'package:tadifitnessapp/datetime/date_time.dart';
import 'package:tadifitnessapp/models/workout.dart';
import 'package:tadifitnessapp/models/exercise.dart';



class WorkoutData extends ChangeNotifier {

  final db = HiveDatabase();
  /* WORKOUT DATA STRUCTURE
  - This Overall List Contains the different workouts
  - Each workout has a name, and a list of exercises
  */ 
  List<Workout> workoutList = [
    //Default Workout
    Workout(
    name: "Upper Body",
    exercises: [
      Exercise (
      name: "Bicep Curls",
      weight: "10",
      reps: "10" ,//reps,
      sets: "4",//sets,
      ),
    ],
    ),
     Workout(
    name: "Lower Body",
    exercises: [
      Exercise (
      name: "Squats",
      weight: "10",
      reps: "10" ,//reps,
      sets: "4",//sets,
      ),
    ],
    ),
  ];

  // If there are workouts already in database, then get that workout list, otherwise use default workouts (Default workouts that the user will see when they initially open the application)
  void initializeWorkoutList()
  {
    if (db.previousDataExists())
    {
      workoutList = db.readFromDatabase();
       //db.saveToDatabase(workoutList);
      
    }
    //otherwise use default workouts
    else
    {
      db.saveToDatabase(workoutList);
    }
    loadHeatMap();
  }
  // get the list of workouts
  List<Workout> getWorkoutList() {
    return workoutList;
  }
  

  //get the length of a given workout
  int numberOfExercisesInWorkout(String workoutName){
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    return relevantWorkout.exercises.length;
  }

  // add a workout
  void addWorkout(String name){
    //add a new workout with blank list of exercises
    workoutList.add(Workout(name: name, exercises: []));
    notifyListeners();
    

    //save to database
    db.saveToDatabase(workoutList);
  }
  //add an exercise to a workout
  void addExercise(String workoutName, String exerciseName, String weight, String reps, String sets){
    //find the relevant workout
    Workout relevantWorkout = 
    workoutList.firstWhere((Workout) => Workout.name == workoutName);
  relevantWorkout.exercises.add(
    Exercise(
    name: exerciseName,
    weight: weight,
    reps: reps,
    sets: sets,
  ),
  );
  notifyListeners();
  //save to database
    db.saveToDatabase(workoutList);
  }
  // Function to delete an exercise from a workout
  void deleteExercise(String workoutName, String exerciseName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);
    relevantWorkout.exercises.removeWhere((exercise) => exercise.name == exerciseName);
    notifyListeners();
    db.saveToDatabase(workoutList);
  }
  // Function to delete a workout
  void deleteWorkout(String workoutName) {
    workoutList.removeWhere((workout) => workout.name == workoutName);
    notifyListeners();
    db.saveToDatabase(workoutList);
  }


  //check off an exercise
  void checkOffExercise(String workoutName, String exerciseName) {
    //find the relevant workout and relevant exercise in that workout
    Exercise	 relevantExercise = getRelevantExercise(workoutName, exerciseName);
    //Check of boolean to show that the user has completed the exercise
    relevantExercise.isCompleted = !relevantExercise.isCompleted;
    print("tapped");
    notifyListeners();
    //save to database
    db.saveToDatabase(workoutList);

    // load heat map
    loadHeatMap();
  }

  //get length of a given exercise

  //return relevant workout object given a workout name
  Workout getRelevantWorkout(String workoutName)
  {
    Workout relevantWorkout = workoutList.firstWhere((Workout) => Workout.name == workoutName);
    return relevantWorkout;
  }

// return relevant exercise object, given a workout name + exercise name
Exercise getRelevantExercise(String workoutName, String exerciseName) {
  //find relevant workout first
  Workout relevantWorkout = getRelevantWorkout(workoutName);

  //Then find the relevant exercise inn that workout
  Exercise relevantExercise = relevantWorkout.exercises.firstWhere((exercise) => exercise.name == exerciseName);
  return relevantExercise;

}

//Get the Start date
String getStartDate()
{
  return db.getStartDate();
}

/* 
HEAT MAP
*/

Map<DateTime, int> heatMapDataSet = {};
void loadHeatMap()
{
  DateTime startDate = createDateTimeObject(getStartDate());
  // count the number of days to load
  int daysInBetween = DateTime.now().difference(startDate).inDays;


  //Go from start date to today, and add each completion status to the dataset
  //"COMPLETION_STATUS_yyyymmdd" will be the key in the database
  for (int i=0; i< daysInBetween+ 1; i++)
  {
    String yyyymmdd = 
    convertDateTimeToYYYYMMDD(startDate.add(Duration(days: i)));

    //completion = 0 or 1
    int completionStatus = db.getCompletionStatus(yyyymmdd);

    //year
    int year = startDate.add(Duration(days: i)).year;

    //month
    int month = startDate.add(Duration(days: i)).month;
    

    //day
    int day = startDate.add(Duration(days: i)).day;

    final percentForEachDay = <DateTime, int> {
      DateTime(year, month, day): completionStatus
    };

    //add to the heatmap dataset
    heatMapDataSet.addEntries(percentForEachDay.entries);



  }

}
}