import 'dart:io';
import 'dart:typed_data';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';

class Utility {
  static convertImageToBase64(File? houseImage) {
    if (houseImage == null) {
      return null;
    }
    return base64Encode(houseImage.readAsBytesSync());
  }
}
