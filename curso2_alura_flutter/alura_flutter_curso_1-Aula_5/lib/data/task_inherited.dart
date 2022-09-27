import 'package:alura_flutter_curso_1/components/tasks.dart';
import 'package:flutter/material.dart';

class TaskInherited extends InheritedWidget {
   TaskInherited({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  final List<Tasks> taskList = [
    Tasks('Aprender Flutter', 'images/dash.png', 3),
    Tasks('Andar de Bike', 'images/bike.webp', 2),
    Tasks('Meditar', 'images/meditar.jpeg', 5),
    Tasks('Ler', 'images/livro.jpg', 4),
    Tasks('Jogar', 'images/jogar.jpg', 1,)
    ];

  void newTask(String nome, String foto , int dificuldade){
    taskList.add(Tasks(nome, foto, dificuldade));
  }

  static TaskInherited of(BuildContext context) {
    final TaskInherited? result = context.dependOnInheritedWidgetOfExactType<TaskInherited>();
    assert(result != null, 'No TaskInherited found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(TaskInherited oldWidget) {
    return oldWidget.taskList.length != taskList.length;
  }
}
