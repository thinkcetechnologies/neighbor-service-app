import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_directions/google_maps_directions.dart' as gmd;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:nsapp/core/constants/app_colors.dart';
import 'package:nsapp/core/constants/dimension.dart';
import 'package:nsapp/core/initialize/init.dart';
import 'package:nsapp/core/models/customer.dart';
import 'package:nsapp/core/models/profile.dart';
import 'package:nsapp/core/models/request_distance.dart';
import 'package:nsapp/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:nsapp/features/shared/presentation/bloc/shared_bloc.dart';
import 'package:nsapp/features/shared/presentation/widget/custom_text_widget.dart';
import 'package:uuid/uuid.dart';

import '../constants/string_constants.dart';
import '../models/subscription.dart';

List<String> specialCharacters = [
  "\"",
  "'",
  "`",
  "@",
  "#",
  "\$",
  "&",
  "|",
  "^",
  "~",
  "!",
  "?",
  ":",
  ";",
  ",",
  ".",
  "=",
  "+",
  "-",
  "*",
  "/",
  "%",
  ">",
  "<",
  ">=",
  "<=",
  "==",
  "!=",
  "&&",
  "||",
  "++",
  "--",
  "<<",
  ">>",
  "??",
  "??=",
  "[",
  "]",
  "{",
  "}",
  "(",
  ")",
];

bool containSpecial(String name) {
  for (int i = 0; i < name.length; i++) {
    if (specialCharacters.contains(name[i])) {
      return true;
    }
  }
  return false;
}

class Helpers {
  static Future<gmd.DistanceValue> dis(double lon, double lat) async {
    var directions = await gmd.distance(
      locationData.latitude!,
      locationData.longitude!,
      lat,
      lon,
      googleAPIKey: mapAPIKey,
    );
    return directions;
  }

  static Future<DateTime?> selectBirthDate(BuildContext context) async {
    return await showDatePicker(
      context: context,
      lastDate: DateTime.now().subtract(Duration(days: 6570)),
      initialDate: DateTime.now().subtract(Duration(days: 6570)),
      firstDate: DateTime(1940),
    );
  }

  static Future<void> selectImageFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      image = pickedFile;
    }
  }

  static Future<void> selectImagesFromGallery() async {
    List<XFile> pickedFiles = await ImagePicker().pickMultiImage(limit: 10);
    if (pickedFiles.isNotEmpty) {
      images = pickedFiles;
    }
  }

  static Future<String> uploadMedia({
    required String folder,
    required Uint8List file,
  }) async {
    Uuid uuid = Uuid();
    final ref = storage.ref().child(folder).child(uuid.v4());
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String url = await snapshot.ref.getDownloadURL();
    return url;
  }

  static Future<void> selectImageFromCamera() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      image = pickedFile;
    }
  }

  static void getLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    List<Placemark> placemarks = await placemarkFromCoordinates(
      locationData.latitude!,
      locationData.longitude!,
    );
    city = placemarks.first.locality.toString();
    countryState = placemarks.first.administrativeArea.toString();
    zipCode = placemarks.first.postalCode.toString();
    country = placemarks.first.country.toString();

    myAddress = '${placemarks.first.locality} ${placemarks.first.country}';
    location.onLocationChanged.listen((data) async {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        locationData.latitude!,
        locationData.longitude!,
      );
      myAddress = '${placemarks.first.locality} ${placemarks.first.country}';
    });
  }

  static Future<String> getAddressFromMap(LatLng loc) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        loc.latitude,
        loc.longitude,
      );
      city = placemarks.first.locality.toString();
      countryState = placemarks.first.administrativeArea.toString();
      zipCode = placemarks.first.postalCode.toString();
      country = placemarks.first.country.toString();
      return '${placemarks.first.locality} ${placemarks.first.country}';
    } catch (e) {
      print(e.toString());
      return "";
    }
  }

  static String createChatRoom({String? sender, String? receiver}) {
    final ids = [sender, receiver];
    ids.sort();
    return ids.join("_");
  }

  static Future<Profile> getSeekerProfile(String uid) async {
    try {
      final user = await store.collection("profiles").doc(uid).get();

      return Profile.fromJson(user);
    } catch (e) {
      return Profile();
    }
  }

  static Future<double> averageRate(String id, double myRate) async {
    final Profile profile = await getSeekerProfile(id);
    if (profile.ratings!.isNotEmpty) {
      List rates = profile.ratings!;
      rates.add(myRate);
      double total = 0.0;
      for (var rate in rates) {
        total = total + rate;
      }
      return total / rates.length;
    }
    return myRate;
  }

  static Future<RequestDistance> getProfile(
    String uid,
    double lon,
    double lat,
  ) async {
    try {
      final distance = await dis(lon, lat);
      final user = await store.collection("profiles").doc(uid).get();

      return RequestDistance(
        distance: distance.text,
        dis: distance.meters,
        profile: Profile.fromJson(user),
      );
    } catch (e) {
      return RequestDistance();
    }
  }

  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "neighbor-service-app",
      "private_key_id": "137f52bee43f7579ea1a853ffa07556d8d77e04f",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDHXElNz7+8I/29\nBEKaVqVcBqj1XkiTe8NO3Kk7BZSEc2Xu5tv9cJUAlwdAnlJds0kAZN+tLQo507qM\nPxVFJZi/rLdmzaLjgPQvmmvpux+GPlvsaaFFFIR5lVO3wtO/HAUxZILDkBi5cPGg\nnGxVdbGrvR/1qXrKVF8LDnqI7zLRX0+OT+8Nk09+4hmvlnfJp06HFo26nNkIAOn1\nhVXPstFkXsX9YgbAQfhSbn+NsvRGkQQO3mA2+Mk6an6iuK4cdQV3fPbo4J6RnKqq\n9pwrHtB4q/Viby03GsD/Ne5M0y/FsomNlCTGmUUAx38iYpvOklS1+Q3zc6Yw2dcI\n509wGLx/AgMBAAECggEAErLqQT0iK8BodUkoAhfsbKRHRrRwND0ghY4W5W1Rj9bP\nEchfi/b6UtLXoEz5RsahK0NK45Bc7C2ayrrEAPdUy22kyiSxiYs33Bss0gB2JX5F\n2vfRY4xYHJtP/eVtPPig2BAoX7VtTD92umzRkHZ4krYrgDxEQyQEwiG6houBBbgz\nMEebirglqxCfbARls3Uyl0j0M/AV4iRR+O0gkVxPUWiDBkKkvOfMFgjskMZrffMJ\nLSmXKjddUr2aO67xkapeYCvVVx7tbSje1t/epBfG/PBaiNdDZcJQ9M0qA3mgdlNU\n3vaoZYxfq0kYaf6HLzZSZw/7EelWhwEqdq1gJAWXaQKBgQD909hm4lDIewYbYim0\nhScsnat1s7LZvvA3SsmZejDievl2idmA62gPf9YMzT3r9JD8AJwWskvzxnvHQPgQ\no4DPX01JypKf76BsC3OlUO/g4uyyvZRxOEMvI9cx1BLIPnzkwT41/AzhASG2pOhR\ngRpMdGzWTZ4QcPsRSfdf2XBzrQKBgQDJERmLJ2ZTvVcJuoEOZ1IxzPOBxYRt43s5\nd0Ebuba2aMyImXynVXl0+DOjnY7iPXz3GO4bNzDfMZfNMU9zl7EIuBl1GyDeb79b\nk/IuHldJrYNPwSQFoBEjB/fgor79tPIgebqeXRHbqahgtCln1za/MT9/00uM/U+y\nov/Pi8HWWwKBgEK7hXNXIMH0hiCA6FILh8cVFNT3D5hruJ/wy5vMIjoI9rkReNuK\nCGu6wj3PX+4++DcoueDFs249yqESFaXaNq1OcvVpiq79wwFk6VyXMNnBD1XWvcYe\ncptcIuF4zg9TTmad34s13vTw5TotlN6IwK9FFLAq69mKupdLCPxsIEJpAoGAbkm+\n5SFbc5tr3p46pBfwcfilqQ0astwQf1j2kaqwmiWp61OlmHO+B3cNfDW0Zkyr+y3l\njXAckpC1X4wotJMEPHAfJqkWwmwxXp4sPTfPUU6ntFuQ0rUWMUzxnnomoStblIyw\n3KTYYtEQ1tp7y8W09fKhjg/sZQ2dZbMa9lEGpfkCgYAMxAELygKSWeWQGUWYpAx2\n1rwHFJehF7vmWSYCiloxdibLfWJxXNo6y8S5rRauN5071zkD8iCQqZhgXZG0vbfG\n+ZAYnX8HarWDWf0diLQnE66rmCtskxTkktzIT7BglfhViAHIyfgOmTQUEgqvZudP\nKkT2kAKbPPC0FkVtvDqHHw==\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-t4zg2@neighbor-service-app.iam.gserviceaccount.com",
      "client_id": "111115266897023168730",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-t4zg2%40neighbor-service-app.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com",
    };
    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging",
    ];
    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    auth.AccessCredentials credentials = await auth
        .obtainAccessCredentialsViaServiceAccount(
          auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
          scopes,
          client,
        );

    client.close();
    return credentials.accessToken.data;
  }

  static Future<void> requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint("User granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint("User granted provisional permission");
    } else {
      debugPrint("User declined or has not accepted permission");
    }
  }

  static Future<String> getToken() async {
    final String? token = await messaging.getToken();
    if (token != null) {
      return token;
    }
    return "";
  }

  static Future<String> getUserDeviceToken({required String uid}) async {
    try {
      final user = await store.collection("profiles").doc(uid).get();

      return user.data()!["deviceToken"];
    } catch (e) {
      return "";
    }
  }

  static Future<void> createStripeCustomer() async {
    try {
      Customer customerModel = await getCustomer(uid: user!.uid);
      if (customerModel.id == null) {
        final customer = <String, dynamic>{
          'email': SuccessGetProfileState.profile.email,
        };
        var response = await http.post(
          Uri.parse(stripeCustomerUrl),
          body: customer,
          headers: headers,
        );

        var json = jsonDecode(response.body);
        Customer customerUser = Customer(
          created: json["created"],
          stripeCustomerID: json["id"],
          balance: json["balance"],
          shipping: json["shipping"],
          address: json["address"],
          phone: json["phone"],
          taxExempt: json["tax_exempt"],
          currency: json["currency"],
          invoicePrefix: json["invoice_prefix"],
          user: user!.uid,
          date: DateTime.now(),
        );
        createCustomer(customer: customerUser);
        debugPrint(response.body);
      }
    } catch (e) {
      debugPrint("Create Stripe Customer Exception: ${e.toString()}");
    }
  }

  static Future<Customer> getCustomer({String? uid}) async {
    try {
      QuerySnapshot<Map<String, dynamic>> document =
          await store
              .collection("customer")
              .where("user", isEqualTo: uid)
              .get();
      if (document.docs.isNotEmpty) {
        return Customer.fromJSON(document.docs.first);
      }
      return Customer();
    } catch (e) {
      debugPrint(e.toString());
      return Customer();
    }
  }

  static Future<void> createCustomer({required Customer customer}) async {
    try {
      await store.collection("customer").add(customer.toJSON());
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // static Future<void> createPaymentMethod() async {
  //   try {
  //     // Use payment method to create a subscription (we'll simulate the backend call)
  //     await initStripePayment(amount: '21599');
  //     // await createSubscription();
  //
  //     await Stripe.instance.presentPaymentSheet();
  //   } catch (e) {
  //     debugPrint('Error creating payment method: $e');
  //   }
  // }

  // Make an HTTP call to create a subscription
  static Future<void> createSubscription(PaymentSheetPaymentOption? pay) async {
    Customer customer = await getCustomer(uid: user!.uid);
    final response = await http.post(
      Uri.parse('https://api.stripe.com/v1/subscriptions'),
      headers: headers,
      body: {
        'customer': customer.stripeCustomerID,
        // Use the customer ID from your Stripe Dashboard or API
        'items[0][price]': 'price_1R7pEBI0ekOomV6UoHViM6mm',
        // Replace with your subscription price ID from Stripe
        // 'expand': 'latest_invoice.payment_intent', // Expand to get the PaymentIntent details
        'default_payment_method': pay,
      },
    );

    if (response.statusCode == 200) {
      final subscription = jsonDecode(response.body);
      final clientSecret =
          subscription['latest_invoice']['payment_intent']['client_secret'];

      // Confirm the payment for the subscription
      await confirmPayment(clientSecret);
    } else {
      debugPrint('Failed to create Subscription: ${response.body}');
    }
  }

  // Confirm the payment using the client secret
  static Future<void> confirmPayment(String clientSecret) async {
    try {
      final paymentIntent = await Stripe.instance.confirmPayment(
        data: PaymentMethodParams.card(paymentMethodData: PaymentMethodData()),
        paymentIntentClientSecret: clientSecret,
      );

      if (paymentIntent.status == PaymentIntentsStatus.Succeeded) {
        // Subscription successful, handle success
        debugPrint('Subscription successful!');
      } else {
        // Payment failed, handle failure
        debugPrint('Subscription failed.');
      }
    } catch (e) {
      debugPrint('Error confirming payment: $e');
    }
  }

  static Future<bool> saveBool(String key, bool value) async {
    try {
      sharedPreferences = await prefs;
      await sharedPreferences!.setBool(key, value);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> getBool(String key) async {
    try {
      sharedPreferences = await prefs;
      final val = sharedPreferences!.getBool(key);
      if (val != null) {
        return val;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, dynamic>> createPaymentIntent({
    required String amount,
  }) async {
    try {
      Customer customerModel = await getCustomer(uid: user!.uid);
      final body = <String, dynamic>{
        'amount': amount,
        "currency": "USD",
        "customer": customerModel.stripeCustomerID,
        "receipt_email": user!.email,
      };

      final response = await http.post(
        Uri.parse(stripePaymentIntentUrl),
        headers: headers,
        body: body,
      );

      return json.decode(response.body);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e.toString());
    }
  }

  static Future<bool> initStripePayment({
    required String amount,
    required BuildContext context,
  }) async {
    try {
      final paymentIntent = await createPaymentIntent(amount: amount);
      Customer customerModel = await getCustomer(uid: user!.uid);
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          customerId: customerModel.stripeCustomerID,
          paymentIntentClientSecret: paymentIntent['client_secret'],
          merchantDisplayName: "Neighbor Services",
          allowsDelayedPaymentMethods: true,
          // customerEphemeralKeySecret: paymentIntent['client_secret'],
          applePay: const PaymentSheetApplePay(merchantCountryCode: 'US'),
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: "US",
            currencyCode: "USD",
            testEnv: true,
          ),
          style: ThemeModeState.themeMode,
          appearance: PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              background: Theme.of(context).scaffoldBackgroundColor,
              primaryText: Theme.of(context).iconTheme.color,
              secondaryText: Theme.of(context).iconTheme.color,
              componentText: Theme.of(context).iconTheme.color,
              placeholderText: Theme.of(context).iconTheme.color,
              componentBorder: Theme.of(context).iconTheme.color,
              componentBackground: Theme.of(context).scaffoldBackgroundColor,
              componentDivider: Theme.of(context).iconTheme.color,
            ),
          ),
        ),
      );

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  static Future<bool> makePayment({
    String? amount,
    required BuildContext context,
  }) async {
    try {
      var payment = await initStripePayment(amount: amount!, context: context);
      if (payment) {
        await Stripe.instance.presentPaymentSheet();

        return true;
      }
      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  static Future<bool> addUserSubscriptionDetails({
    required SubscriptionModel subscriptionModel,
    required String amount,
    required BuildContext context,
  }) async {
    try {
      final results = await makePayment(amount: amount, context: context);
      if (results) {
        await store
            .collection("subscription")
            .doc(user!.uid)
            .set(subscriptionModel.toJson());
        return true;
      }
      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  static Future<SubscriptionModel?> getUserSubscriptionDetails() async {
    try {
      final result =
          await store.collection("subscription").doc(user!.uid).get();

      if (result.exists) {
        return SubscriptionModel.fromJson(result);
      }
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  static Future<bool> deleteUserSubscriptionDetails() async {
    try {
      await store.collection("subscription").doc(user!.uid).delete();

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  static Future<bool> userHasTheValidSubscription() async {
    try {
      final SubscriptionModel? result = await getUserSubscriptionDetails();

      if (result != null) {
        if (result.nextPayment!.isAfter(DateTime.now())) {
          return true;
        }
        return false;
      }
      return false;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}

enum AlertType { success, error, warning }

void customAlert(BuildContext context, AlertType type, String message) {
  showDialog(
    context: context,
    builder: (context) {
      return Material(
        color: Colors.transparent,
        child: SizedBox(
          height: size(context).height,
          width: size(context).width,
          child: Center(
            child: Container(
              width: size(context).width * 0.80,
              height: 200,
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: size(context).width * 0.80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      color:
                          (type == AlertType.success)
                              ? Colors.green
                              : (type == AlertType.error)
                              ? Colors.red
                              : Colors.yellow,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomTextWidget(
                          text:
                              (type == AlertType.success)
                                  ? "SUCCESS"
                                  : (type == AlertType.warning)
                                  ? "WARNING"
                                  : "ERROR",
                          color: appWhiteColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                        SizedBox(height: 20),
                        Icon(
                          (type == AlertType.success)
                              ? Icons.check_circle
                              : (type == AlertType.warning)
                              ? Icons.warning
                              : Icons.error,
                          color: Colors.white,
                          size: 40,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 35),
                  CustomTextWidget(text: message),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
  Future.delayed(Duration(seconds: 3), () {
    Get.back();
  });
}
