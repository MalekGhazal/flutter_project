import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_project/login/login_check.dart';
import 'package:flutter_project/providers/todo_provider.dart';
import 'package:flutter_project/routes/drawer_routes.dart';
import 'package:flutter_project/screens/profile_screen.dart';
import 'package:flutter_project/screens/todos_screen.dart';
import 'package:flutter_project/screens/weather_screen.dart';
import 'package:flutter_project/widgets/drawer.dart';
import '../theme/dark_theme.dart';
import '../theme/light_theme.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<TodoProvider>(
          create: (_) => TodoProvider(),
        ),
      ],
      child: const TodoApp(),
    ),
  );
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      routes: {
        "/": (context) => const LoginCheck(),
        DrawerRoutes.todos: (context) => const TodosScreen(),
        DrawerRoutes.weather: (context) => const WeatherScreen(),
        DrawerRoutes.profile: (context) => const ProfileScreen(),
      },
    );
  }
}

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your App Name'),
      ),
      drawer: const TodoDrawer(), // Use your existing TodoDrawer
      body: const LoginCheck(),
    );
  }
}
