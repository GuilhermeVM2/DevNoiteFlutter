import 'package:flutter/material.dart';
import 'registro_screen.dart';
import 'task_list_screen.dart';
import 'helpers/database_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login - SA3')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Nome de Usuário'),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Senha'),
              obscureText: true,
            ),
            ElevatedButton(
              onPressed: () {
                _login();
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegistroScreen()),
                );
              },
              child: const Text('Registrar'),
            ),
          ],
        ),
      ),
    );
  }

  void _login() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Verificar as credenciais no banco de dados SQLite
    var dbHelper = DatabaseHelper();
    bool isValidUser = await dbHelper.isValidUser(username, password);

    if (isValidUser) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TaskListScreen(username: username)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nome de usuário ou senha incorretos')),
      );
    }
  }
}
