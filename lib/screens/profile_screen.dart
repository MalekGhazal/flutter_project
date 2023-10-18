// ignore_for_file: use_build_context_synchronously
import 'package:flutter/services.dart';
import 'package:flutter_project/providers/profile_picture.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/widgets/drawer.dart';
import 'package:flutter_project/services/authentication.dart';
import 'package:provider/provider.dart';

/// `ProfileScreen` is a stateful widget that displays user profile information fetched from Firebase Authentication.
///
/// This widget allows users to:
/// 1. View their profile picture, which can be updated from the device's camera.
/// 2. View their name and email.
/// 3. View the date they joined the application.
/// 4. Sign out from their account.
///
/// Key Features:
/// - **Profile Picture**: Users can view and update their profile picture by accessing the device's camera.
/// - **User Details**: Displays the user's name and email fetched from Firebase.
/// - **Joined Date**: Shows the date when the user created their account on the application.
/// - **Sign Out**: Provides an option for users to sign out from their account.
///
/// Dependencies:
/// - `firestore.dart`: Used for database interactions.
/// - `profile_picture.dart`: Provider to manage and update the profile picture.
/// - `drawer.dart`: Represents the drawer widget used in this screen.
/// - `authentication.dart`: Service for authentication related functionalities.
///
/// Usage:
/// ```dart
/// ProfileScreen()
/// ```
///
/// By providing a seamless interface for viewing and updating profile details, this widget enhances user engagement and ensures a personalized user experience.

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final email = FirebaseAuth.instance.currentUser?.email;
  var name = FirebaseAuth.instance.currentUser?.displayName;
  late TextEditingController usernameController = TextEditingController();

  // ignore: unused_field
  File? _image;

  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      setState(() {
        _image = img;
      });
      Provider.of<ProfilePicture>(context, listen: false).setImage(img);
    } on PlatformException catch (e) {
      print(e);
      Navigator.of(context).pop();
    }
  }

  Future <String?>openDialog() => showDialog<String>(
    context: context,
     builder: (context) => AlertDialog(
      title: const Text('New Username'),
      content: TextField(
        autofocus: true,
        decoration: const InputDecoration(hintText: 'Enter your username'),
        controller: usernameController,
      ),
        
      actions: [
        TextButton(
          onPressed: submit,
          child: const Text('SUBMIT'))
      ],
     ));
  void submit() {
    Navigator.of(context).pop(usernameController.text);
  }


  @override
  Widget build(BuildContext context) {
    File? image = Provider.of<ProfilePicture>(context).userImage;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(),
      drawer: TodoDrawer(), // Adding a drawer to the screen
      body: Align(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: CircleAvatar(
                radius: 80.0,
                backgroundColor: Colors.transparent,
                backgroundImage: image != null
                    ? FileImage(image) as ImageProvider<Object>
                    : const AssetImage(
                        "assets/images/ProfilePlaceholder.png"), // Displaying placeholder profile image
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              (name != null ? name.toString() : "Anonymous user"),
              style: TextStyle(
                  fontSize: 26.0,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 8.0),
            Text(
              (email != null ? email.toString() : ""),
              style: const TextStyle(fontSize: 16.0),
            ),
            const SizedBox(
              height: 50.0,
            ),
            Text(
              "Joined 2DO On:",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 23,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 15.0,
            ),
            Text(
                "${user?.metadata.creationTime?.day}/${user?.metadata.creationTime?.month}/${user?.metadata.creationTime?.year}",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.w400)),
            const SizedBox(
              height: 50.0,
            ),
            ElevatedButton(
              onPressed: () {
                _pickImage(ImageSource.camera);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                ),
              ),
              child: Text(
                "Upload Photo",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.background,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            name != null ? 
              ElevatedButton(onPressed: () async {
                final username = await openDialog();
                if(username == null || username.isEmpty) return;
                FirebaseAuth.instance.currentUser?.updateDisplayName(username);
                setState(() {
                  name = username;
                });
             }, style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                ),
              ),
              child: Text(
                "Update username",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.background,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600),
              ),
            )  : Container(),
            const SizedBox(
              height: 40.0,
            ),
            ElevatedButton(
              onPressed: () async {
                await AuthService().signOut(); // Triggering sign-out action
                Navigator.pushReplacementNamed(context,
                    '/'); // Navigating to the login screen after sign-out
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).colorScheme.secondary,
                ),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                ),
              ),
              child: Text(
                "Sign out",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.background,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose(){
    usernameController.dispose();
    super.dispose();
  }
}
