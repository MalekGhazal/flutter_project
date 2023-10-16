import 'dart:io';
import 'package:flutter/foundation.dart';

class ProfilePicture with ChangeNotifier {
  File? _userImage;

  File? get userImage => _userImage;

  void setImage(File? image) {
    _userImage = image;
    notifyListeners();
  }
}
