import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseStorage storage = FirebaseStorage.instance;
FirebaseFirestore store = FirebaseFirestore.instance;
FirebaseMessaging messaging = FirebaseMessaging.instance;
User? user = auth.currentUser;

Location location = Location();
late LocationData locationData;
String myAddress = "";
String country = "";
String city = "";
String countryState = "";
String zipCode = "";

XFile? image;

List<XFile>? images;

TextEditingController locController = TextEditingController();

int radiusDistance = 25000;
SharedPreferencesWithCache? sharedPreferences;

final Future<SharedPreferencesWithCache> prefs =
    SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(
        // This cache will only accept the key 'counter'.
        allowList: <String>{'darkmode', 'usebiometric'},
      ),
    );
