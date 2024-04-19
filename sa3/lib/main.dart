import 'package:flutter/material.dart';
import 'package:sa3/models/task.dart';
import 'package:sa3/helpers/database_helper.dart';

class TaskListScreen extends StatefulWidget {
  final String username;

  const TaskListScreen({Key? key, required this.username}) : super(key: key);

  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _taskController = TextEditingController();
  late List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  _loadTasks() async {
    try {
      var dbHelper = DatabaseHelper();
      _tasks = await dbHelper.getTasks(widget.username);
      setState(() {});
    } catch (e) {
      _showSnackbar("Erro ao carregar tarefas: $e");
    }
  }

  _addTask() async {
    try {
      if (_taskController.text.isNotEmpty) {
        var dbHelper = DatabaseHelper();
        await dbHelper.insertTask(Task(
          title: _taskController.text,
          username: widget.username,
          isCompleted: false,
        ));
        _taskController.clear();
        _loadTasks();
        _showSnackbar('Tarefa adicionada com sucesso');
      } else {
        _showSnackbar('Por favor, insira uma tarefa');
      }
    } catch (e) {
      _showSnackbar("Erro ao adicionar tarefa: $e");
    }
  }

  _updateTask(Task task) async {
    try {
      var dbHelper = DatabaseHelper();
      await dbHelper.updateTask(task);
      _loadTasks();
      _showSnackbar('Tarefa atualizada com sucesso');
    } catch (e) {
      _showSnackbar("Erro ao atualizar tarefa: $e");
    }
  }

  _deleteTask(int id) async {
    try {
      var dbHelper = DatabaseHelper();
      await dbHelper.deleteTask(id);
      _loadTasks();
      _showSnackbar('Tarefa excluída com sucesso');
    } catch (e) {
      _showSnackbar("Erro ao excluir tarefa: $e");
    }
  }

  _showEditTaskDialog(Task task) {
    _taskController.text = task.title;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Tarefa'),
          content: TextFormField(
            controller: _taskController,
            decoration: const InputDecoration(labelText: 'Título da Tarefa'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                _taskController.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Atualizar'),
              onPressed: () {
                task.title = _taskController.text;
                _updateTask(task);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Tarefas - SA3')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _taskController,
                    decoration: const InputDecoration(labelText: 'Nova Tarefa'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _addTask();
                  },
                  child: const Text('Adicionar'),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_tasks[index].title),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            _showEditTaskDialog(_tasks[index]);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            _deleteTask(_tasks[index].id!);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
