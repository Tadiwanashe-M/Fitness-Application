import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tadifitnessapp/components/exercise_tile.dart';
import 'package:tadifitnessapp/data/workout_data.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  const WorkoutPage({Key? key, required this.workoutName}) : super(key: key);

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {
  final exerciseNameController = TextEditingController();
  final weightController = TextEditingController();
  final repsController = TextEditingController();
  final setsController = TextEditingController();

  void createNewExercise() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add a New Exercise'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: exerciseNameController,
                decoration: InputDecoration(labelText: 'Exercise Name'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: weightController,
                decoration: InputDecoration(labelText: 'Weight/Distance'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: repsController,
                decoration: InputDecoration(labelText: 'Reps/Time'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: setsController,
                decoration: InputDecoration(labelText: 'Sets/Laps'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => save(),
            child: Text('Save'),
          ),
          TextButton(
            onPressed: () => cancel(),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void save() {
    String newExerciseName = exerciseNameController.text;
    String weight = weightController.text;
    String reps = repsController.text;
    String sets = setsController.text;

    Provider.of<WorkoutData>(context, listen: false).addExercise(
      widget.workoutName,
      newExerciseName,
      weight,
      reps,
      sets,
    );

    Navigator.pop(context);
    clear();
  }

  void cancel() {
    Navigator.pop(context);
    clear();
  }

  void clear() {
    exerciseNameController.clear();
    weightController.clear();
    repsController.clear();
    setsController.clear();
  }

  void onCheckBoxChanged(String workoutName, String exerciseName) {
    Provider.of<WorkoutData>(context, listen: false).checkOffExercise(workoutName, exerciseName);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: Text(widget.workoutName),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => createNewExercise(),
          child: Icon(Icons.add),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.separated(
            itemCount: value.numberOfExercisesInWorkout(widget.workoutName),
            separatorBuilder: (context, index) => Divider(), // Add separators between exercises
            itemBuilder: (context, index) => ExerciseTile(
              exerciseName: value.getRelevantWorkout(widget.workoutName).exercises[index].name,
              weight: value.getRelevantWorkout(widget.workoutName).exercises[index].weight,
              reps: value.getRelevantWorkout(widget.workoutName).exercises[index].reps,
              sets: value.getRelevantWorkout(widget.workoutName).exercises[index].sets,
              isCompleted: value.getRelevantWorkout(widget.workoutName).exercises[index].isCompleted,
              onCheckBoxChanged: (val) {
                onCheckBoxChanged(widget.workoutName, value.getRelevantWorkout(widget.workoutName).exercises[index].name);
              },
              onDelete: () {
                value.deleteExercise(widget.workoutName, value.getRelevantWorkout(widget.workoutName).exercises[index].name);
              },
            ),
          ),
        ),
      ),
    );
  }
}
