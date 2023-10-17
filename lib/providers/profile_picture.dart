import 'dart:io';
import 'package:flutter/foundation.dart';

/// `ProfilePicture` is a state management class using the `ChangeNotifier` mixin from Flutter's Provider package.
///
/// This class manages a user's profile picture, allowing for the setting and retrieval of the image.
///
/// Attributes:
/// - `_userImage`: Represents the file containing the user's profile picture.
///
/// Key methods:
/// - `setImage`: Allows for setting the user's profile picture. This method updates the `_userImage` attribute and notifies listeners of the change.
///
/// Usage:
/// ```dart
/// ProfilePicture profilePictureProvider = ProfilePicture();
/// profilePictureProvider.setImage(File('path_to_image'));
/// File? currentImage = profilePictureProvider.userImage;  // Access the user's current profile picture
/// ```
/// With the Provider package in Flutter:
/// ```dart
/// ChangeNotifierProvider(
///   create: (context) => ProfilePicture(),
///   child: YourWidget(),
/// )
/// ```
/// In a widget to get the provider:
/// ```dart
/// ProfilePicture profilePictureProvider = Provider.of<ProfilePicture>(context);
/// ```

class ProfilePicture with ChangeNotifier {
  File? _userImage;

  File? get userImage => _userImage;

  void setImage(File? image) {
    _userImage = image;
    notifyListeners();
  }
}
