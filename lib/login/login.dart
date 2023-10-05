import 'package:flutter/material.dart';
import 'package:flutter_project/services/authentication.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "2DO",
                style: TextStyle(
                    fontSize: 75,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 150),
              const Text(
                "Welcome",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF494949)),
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(
                    onPressed: () async {
                      await AuthService().anonymousLogin();
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FontAwesomeIcons.userClock),
                        SizedBox(width: 20),
                        Text(
                          "Anonymous login",
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    )),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(
                    onPressed: () async {
                      await AuthService().googleLogin();
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(FontAwesomeIcons.google),
                        SizedBox(width: 20),
                        Text(
                          "Login with Google",
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    )),
              ),
            ],
          ),
        ));
  }
}
