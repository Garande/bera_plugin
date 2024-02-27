library bera_plugin;

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'bera_loader.dart';

/// A BERA Plugin package.
class BeraPlugin {
  static BeraPlugin? _instance;
  BeraPlugin._();
  static BeraPlugin get instance => _instance ??= BeraPlugin._();

  // final apiClient = ApiClient(AppConstants.baseUrl);

  String? apiKey, secretKey, userId;

  bool? busy;

  String? get authKey => apiKey;

  ///initialize the plugin with your public key
  Future<void> initialize(String key, {String? secret, String? userId}) async {
    apiKey = key;
    secretKey = secret;
    userId = userId;

    await Firebase.initializeApp(
      name: 'bera', // Give your second app a custom name
      options: const FirebaseOptions(
        apiKey: 'AIzaSyCFp_7TSLXlDuqQFapfnjm6ug_9aVhc3gg',
        appId: '1:423955285530:android:c7a3bb05167bd9f739b3a3',
        messagingSenderId: '423955285530',
        projectId: 'bera-care',
        databaseURL: 'https://bera-care-default-rtdb.firebaseio.com',
        storageBucket: 'bera-care.appspot.com',
      ),
    );
  }

  bool get isInitialized => apiKey != null;

  void initDoctor(BuildContext context) {
    if (!isInitialized) {
      showModalBottomSheet(
        context: context,
        isDismissible: true,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(120),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: const Center(
                    child: Icon(
                      Icons.warning_amber_rounded,
                      size: 90,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Oops!, Unable to proceed, Please make sure you have initialized BERA Care',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontSize: 15.0),
                ),
              ],
            ),
          );
        },
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BeraLoader(
            apiKey: apiKey!,
            userId: userId,
          ),
        ),
      );
    }
  }
}
