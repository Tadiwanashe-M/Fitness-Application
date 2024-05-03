 import 'package:flutter/material.dart';
class ExerciseTile extends StatefulWidget {
  final String exerciseName;
  final String weight;
  final String reps;
  final String sets;
  final bool isCompleted;
  final void Function(bool?)? onCheckBoxChanged;
  final VoidCallback onDelete;

  ExerciseTile({
    Key? key,
    required this.exerciseName,
    required this.weight,
    required this.reps,
    required this.sets,
    required this.isCompleted,
    required this.onCheckBoxChanged,
    required this.onDelete,
  }) : super(key: key);

  @override
  _ExerciseTileState createState() => _ExerciseTileState();
}

class _ExerciseTileState extends State<ExerciseTile> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        setState(() {
          _hovering = !_hovering;
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: _hovering ? Colors.grey[200] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          title: Text(
            widget.exerciseName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Wrap(
            spacing: 8,
            children: [
              Chip(
                label: Text("${widget.weight} kg"),
                backgroundColor: Colors.blue[100],
              ),
              Chip(
                label: Text("${widget.reps} reps"),
                backgroundColor: Colors.green[100],
              ),
              Chip(
                label: Text("${widget.sets} sets"),
                backgroundColor: Colors.orange[100],
              ),
            ],
          ),
          trailing: Checkbox(
            value: widget.isCompleted,
            onChanged: widget.onCheckBoxChanged,
          ),
          leading: _hovering
              ? IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: widget.onDelete,
                  color: Colors.red,
                )
              : null,
        ),
      ),
    );
  }
}
