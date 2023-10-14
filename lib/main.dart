import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_project/login/login_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_project/providers/todo_provider.dart';
import 'package:flutter_project/routes/drawer_routes.dart';
import 'package:flutter_project/screens/profile_screen.dart';
import 'package:flutter_project/screens/todos_screen.dart';
import 'package:flutter_project/screens/weather_screen.dart';
import 'package:flutter_project/services/authentication.dart';
import 'package:flutter_project/widgets/drawer.dart';
import '../theme/dark_theme.dart';
import '../theme/light_theme.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

void main(List<String> args) async {
  // Ensure that Flutter is initialized and ready to use
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with the default options for the current platform
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Run the app, providing a TodoProvider to manage todos
  runApp(
    MultiProvider(
      providers: [
        // Create a provider for managing todos using ChangeNotifier
        ChangeNotifierProvider<TodoProvider>(
          create: (_) => TodoProvider(),
        ),
      ],
      // Start the app by calling the TodoApp widget
      child: const TodoApp(),
    ),
  );
}

bool googleUser = false;

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: AuthService().userStream,
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (AuthService().user?.email != null) {
              googleUser = true;
            } else {
              googleUser = false;
            }
          }

          return MaterialApp(
            // Disable the debug banner in the top-right corner
            debugShowCheckedModeBanner: false,

            // Define the light and dark themes for the app
            theme: lightTheme,
            darkTheme: darkTheme,

            // Define the app's routes for different screens
            routes: {
              // The default route ("/") leads to the LoginCheck screen
              "/": (context) => const LoginCheck(),

              // Other routes are accessible through the drawer
              DrawerRoutes.todos: (context) => TodosScreen(
                  dataSource: (googleUser == true
                      ? TodoDataSource.google
                      : TodoDataSource.local)),
              DrawerRoutes.weather: (context) => const WeatherScreen(),
              DrawerRoutes.profile: (context) => ProfileScreen(),
            },
          );
        });
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
      // Add the TodoDrawer widget as the drawer for this screen
      drawer: TodoDrawer(),

      // Set the body of this screen to the LoginCheck widget
      body: const LoginCheck(),
    );
  }
}
