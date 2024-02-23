// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'dart:ui';

// import 'package:bera_app/models/app_user.dart';
// import 'package:bera_app/widgets/app_button.dart';
// import 'package:bera_app/widgets/location_dialog_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/app_user.dart';
import '../widgets/app_button.dart';
import 'config.dart';
import 'log.dart';

class Helpers {
  static String formatDurationInDays(int durationInDays) {
    if (durationInDays >= 365) {
      int years = durationInDays ~/ 365;
      int remainingDays = durationInDays % 365;
      if (remainingDays == 0) {
        return '$years ${years == 1 ? 'Year' : 'Years'}';
      } else if (remainingDays < 30) {
        return '$years ${years == 1 ? 'Year' : 'Years'} $remainingDays Days';
      } else {
        int months = remainingDays ~/ 30;
        int remainingDaysInMonth = remainingDays % 30;
        if (remainingDaysInMonth == 0) {
          return '$years ${years == 1 ? 'Year' : 'Years'} $months ${months == 1 ? 'Month' : 'Months'}';
        } else {
          return '$years ${years == 1 ? 'Year' : 'Years'} $months ${months == 1 ? 'Month' : 'Months'} $remainingDaysInMonth Days';
        }
      }
    } else if (durationInDays >= 30) {
      int months = durationInDays ~/ 30;
      int remainingDays = durationInDays % 30;
      if (remainingDays == 0) {
        return '$months ${months == 1 ? 'Month' : 'Months'}';
      } else {
        return '$months ${months == 1 ? 'Month' : 'Months'} $remainingDays Days';
      }
    } else {
      return '$durationInDays ${durationInDays == 1 ? 'Day' : 'Days'}';
    }
  }

  static String formatUTCWithTime(String? date) {
    if (date == null) return '---';

    final utcDate = DateTime.parse(date);

    final userTimezone = DateTime.now().timeZoneOffset;

    final userDateTime = utcDate.add(userTimezone);
    return Helpers.formatDateWithTime(userDateTime);
  }

  static bool isSubscriptionExpired(String? date) {
    //
    if (date == null) return true;

    final utcDate = DateTime.parse(date);

    final userTimezone = DateTime.now().timeZoneOffset;

    final userDateTime = utcDate.add(userTimezone);

    return userDateTime.millisecondsSinceEpoch <
        DateTime.now().millisecondsSinceEpoch;
    // return Helpers.formatDateWithTime(userDateTime);
  }

  // static Future<void> handleLocationPermission(
  //   BuildContext context, {
  //   required VoidCallback onComplete,
  //   required VoidCallback onReject,
  // }) async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   // Test if location services are enabled.
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     // Location services are not enabled don't continue
  //     // accessing the position and request users of the
  //     // App to enable the location services.
  //     // show Popup
  //     await showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (contextT) => LocationDialogView(
  //         onTap: () async {
  //           Navigator.of(contextT).pop();
  //           permission = await Geolocator.requestPermission();
  //           await Geolocator.openLocationSettings();
  //           onComplete();
  //         },
  //       ),
  //     );
  //     // return Future.error('Location services are disabled.');
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     // show request Notification popup
  //     await showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (contextT) => LocationDialogView(
  //         onTap: () async {
  //           Navigator.of(contextT).pop();
  //           permission = await Geolocator.requestPermission();
  //           if (permission == LocationPermission.denied) {
  //             showSnackBar(
  //               context,
  //               'You need to enable your to continue.',
  //               Colors.red,
  //             );
  //             onReject();
  //             // return Future.error('Location permissions are denied');
  //           } else {
  //             showSnackBar(
  //               context,
  //               'Location enabled',
  //               Colors.green,
  //             );
  //             onComplete();
  //           }
  //         },
  //       ),
  //     );
  //   } else if (permission == LocationPermission.deniedForever) {
  //     // Permissions are denied forever, handle appropriately.
  //     showSnackBar(
  //       context,
  //       'You need to enable your to continue.',
  //       Colors.red,
  //     );
  //     onReject();
  //     // return Future.error(
  //     //     'Location permissions are permanently denied, we cannot request permissions.');
  //   } else {
  //     onComplete();
  //   }
  // }

  static void showSnackBar(
    BuildContext context,
    String msg,
    Color? color, {
    Widget? trail,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(msg),
                ],
              ),
            ),
            if (trail != null) trail,
          ],
        ),
      ),
    );
  }

  static DateTime? getUTCDate(String? date) {
    if (date == null) return null;

    final utcDate = DateTime.parse(date);

    final userTimezone = DateTime.now().timeZoneOffset;

    final userDateTime = utcDate.add(userTimezone);

    return userDateTime;
    // return Helpers.formatDateWithTime(userDateTime);
    // return Helpers.formatDateWithTime(DateTime.parse(date ?? ''));
  }

  static String getFirstName(String? name, String? firstName) {
    if (isEmpty(name)) return firstName ?? '';
    List<String?> list = name!.split(' ');
    return list[0] ?? firstName ?? '';
  }

  static String getLastName(String? name, String? lastName) {
    if (isEmpty(name)) return lastName ?? '';
    List<String?> list = name!.split(' ');

    if (list.length > 1) {
      list.removeAt(0);
      return list.join(" ");
    }
    return lastName ?? '';
  }

  static String generateItemKey(List<dynamic> keyIdentifiers, int timestamp) {
    String key = keyIdentifiers.join('-');

    // for (var keyId in keyIdentifiers) {
    //   if (key == '') {
    //     key = keyId;
    //   } else {
    //     key = "$key-$keyId";
    //   }
    // }

    if (timestamp > 0) {
      key = "$key-$timestamp";
    }

    return sanitizeItemKey(key);
  }

  static String formatCurrency(double amount) {
    final number = NumberFormat("#,##0", "en_US");
    return number.format(amount);
  }

  // static AppUser? getChatPeer(int? myId, List<AppUser>? members) {
  //   return members?.firstWhere((el) {
  //     printLog('-------------------------');
  //     printLog(el.id);
  //     return el.id != myId;
  //   }, orElse: () {
  //     return members[0];
  //   });
  // }

  static AppUser? getChatPeer(int? myId, List<AppUser>? members) {
    return members?.firstWhere((el) {
      // printLog('-------------------------');
      // printLog(el.id);
      return el.id != myId;
    }, orElse: () {
      return members[0];
    });
  }

  static String formatDateWithTime(DateTime dateTime) {
    var dateFormat = DateFormat.yMd().add_jm();
    return dateFormat.format(dateTime);
  }

  static String formatTime(DateTime dateTime) {
    return DateFormat.Hm().format(dateTime);
  }

  static String formatToday() {
    DateTime now = DateTime.now();
    var dateFormat = DateFormat.MMMM();
    return 'Today, ${now.day} ${dateFormat.format(now)}';
  }

  static String formatGreeting() {
    DateTime now = DateTime.now();
    int time = now.hour;
    if (time < 12) {
      return 'Good morning';
    } else if (time >= 12 && time < 17) {
      return 'Good afternoon';
    } else {
      return 'Good evening';
    }
  }

  static String? formatPregnancyDate(int? timestamp) {
    if (timestamp == null || timestamp == 0) return null;
    int nowTime = DateTime.now().millisecondsSinceEpoch;
    if (nowTime > timestamp) return null;

    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    var diff = dateTime.difference(DateTime.now());

    return '${diff.inDays}';
  }

  static String formatNumber(int number) {
    final numberFormat = NumberFormat();
    return numberFormat.format(number);
  }

  static String formatNumberWithCommas(String digit) {
    String digiString = digit;
    digiString = digiString.replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},');
    return digiString;
  }

  /// verifys if string is empty or null
  static bool isEmpty(String? txt) {
    return (txt == null || txt == '' || txt.isEmpty);
  }

  /// Removes unwanted characters from the phone number string
  static String sanitizePhoneNumber(String phone) {
    phone = phone.replaceAll(' ', '');
    // phone = phone.replaceAll('+', '');
    return phone;
  }

  /// Phone Number validator
  static bool validatePhoneNumber(String? phone) {
    String pattern = r'^\+(?:[0-9]●?){6,14}[0-9]$';
    RegExp regExp = RegExp(pattern);
    if (isEmpty(phone)) throw 'Please enter a phone number';
    return regExp.hasMatch(phone!);
  }

  /// User Email validator
  static bool validateEmail(String? email) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = RegExp(pattern);
    if (isEmpty(email)) throw 'Please enter an email address';
    return regExp.hasMatch(email!);
  }

  /// Select image from the user file system
  static Future<XFile?> selectImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  static Future<XFile?> takeImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.camera);
    return image;
  }

  static Future<XFile?> selectVideo() async {
    final ImagePicker picker = ImagePicker();
    return picker.pickVideo(source: ImageSource.gallery);
  }

  static Future<XFile?> takeVideo() async {
    final ImagePicker picker = ImagePicker();
    return picker.pickVideo(source: ImageSource.camera);
  }

  static String formatDateMonth(DateTime dateTime) {
    var dateFormat = DateFormat.yMMMEd();
    return dateFormat.format(dateTime);
  }

  static bool isOwnMessage({int? userId, int? idFrom}) {
    if (idFrom == userId) {
      return true;
    }
    return false;
  }

  static String sanitizeItemKey(String key) {
    key = key.replaceAll(" ", "");
    key = key.replaceAll("/", "-");
    key = key.replaceAll("\\", "-");
    key = key.replaceAll("_", "-");
    key = key.replaceAll("--", "-");
    key = key.replaceAll("- -", "-");
    key = key.replaceAll(",,", ",");
    key = key.replaceAll(".", "-");
    key = key.replaceAll(".", "-");
    key = key.replaceAll("[", "-");
    key = key.replaceAll("]", "-");
    key = key.replaceAll("{", "-");
    key = key.replaceAll("}", "-");
    key = key.replaceAll("(", "-");
    key = key.replaceAll(")", "-");
    key = key.replaceAll("\$", "-");
    key = key.replaceAll("&", "-");
    key = key.replaceAll("'", "-");
    key = key.replaceAll("\"", "-");
    key = key.replaceAll("#", "-");
    key = key.replaceAll("-null", "");
    key = key.replaceAll("null-", "");
    key = key.replaceAll("null_", "");
    key = key.replaceAll("_null", "");
    key = key.replaceAll("0x00", "-");
    key = key.replaceAll("0x1F", "-");
    key = key.replaceAll("0x7F", "-");
    if (key.length >= 768) {
      key = key.substring(0, 500);
    } //768 is the max number of character a downloadPath can contain.
    return key.toLowerCase();
  }

  static String formatDuartion(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours <= 0) {
      return "$twoDigitMinutes:$twoDigitSeconds";
    } else {
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    }
  }

  static String getDayOfWeek(DateTime date) => DateFormat('EEE').format(date);

  static String getDayOfMonth(DateTime date) => DateFormat('dd').format(date);

  static String getDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);

  static String formatDateTimeMillis(int? timestamp) {
    if (timestamp == null || timestamp == 0) return '00-00-0000';

    return DateFormat('dd-MM-yyyy')
        .format(DateTime.fromMillisecondsSinceEpoch(timestamp));
  }

  static DateTime getDayBeforeAfter(DateTime date, {bool? isBefore}) {
    //
    DateTime newDate = DateTime(date.year, date.month, date.day);
    if (isBefore == true) {
      newDate = newDate.subtract(const Duration(days: 1));
    } else {
      newDate = newDate.add(const Duration(days: 1));
    }
    return newDate;
  }

  static void buildVersionDialog(
      BuildContext context, String? version, String? downloadLink) {
    showGeneralDialog(
      context: context,
      pageBuilder: (context, _, __) {
        return Container();
      },
      transitionDuration: const Duration(milliseconds: 250),
      transitionBuilder: (ctx, anim1, __, child) {
        final curvedValue = Curves.easeInOutBack.transform(anim1.value) - 1.0;
        return Transform(
          transform: Matrix4.translationValues(curvedValue * 200, 0.0, 0.0),
          child: Opacity(
            opacity: anim1.value,
            child: Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: AppUpdateView(
                version: version,
                downloadLink: downloadLink,
              ),
            ),
          ),
        );
      },
    );
  }

  static void toast(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: const Color(0xFF1E1E1E).withOpacity(0.95),
      textColor: Colors.white,
    );
  }

  static void internetLookUp() async {
    try {
      await InternetAddress.lookup('google.com').catchError((e) {
        Helpers.toast(
            'No internet connection. Please check your Internet Connection.');
      });
    } catch (err) {
      Helpers.toast(
          'No internet connection. Please check your Internet Connection.');
    }
  }

  static Future<bool> checkAndRequestPermission(Permission permission) {
    Completer<bool> completer = Completer<bool>();
    permission.request().then((status) {
      if (status != PermissionStatus.granted) {
        permission.request().then((_status) {
          bool granted = _status == PermissionStatus.granted;
          completer.complete(granted);
        });
      } else {
        completer.complete(true);
      }
    });
    return completer.future;
  }
}

class AppUpdateView extends StatelessWidget {
  const AppUpdateView({
    super.key,
    this.version,
    this.downloadLink,
  });
  final String? version;
  final String? downloadLink;

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      printLog('Failed to log====');
      // throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 340,
      width: MediaQuery.of(context).size.width - 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        // color: Colors.red,
      ),
      // padding: const EdgeInsets.all(15.0),
      // clipBehavior: Clip.hardEdge,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
          child: Container(
            width: double.infinity,
            // height: 100.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white.withOpacity(.75),
              // color: Colors.white.withOpacity(.8),
            ),

            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo/logo.png',
                      height: 40.0,
                    ),
                  ],
                ),
                Text(
                  'New Update Available',
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontSize: 18.0),
                ),
                const SizedBox(height: 10.0),
                Text(
                  'Important Notice: All updates are mandatory for our software. Please install them promptly to ensure optimal performance and security. Thank you.',
                  textAlign: TextAlign.left,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(fontSize: 12.0, color: Colors.blue),
                ),
                const SizedBox(height: 15.0),
                Row(
                  children: [
                    Expanded(
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Current Version: ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontSize: 15.0,
                                    color: Colors.black,
                                  ),
                            ),
                            TextSpan(
                              text: '\t\t v${Config.appVersion} ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontSize: 15.0,
                                    color: Colors.red[900],
                                    fontWeight: FontWeight.w700,
                                  ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 7.0),
                Row(
                  children: [
                    Expanded(
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'New Version: ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontSize: 15.0,
                                    color: Colors.black,
                                  ),
                            ),
                            TextSpan(
                              text: '\t\t v${version} ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    fontSize: 15.0,
                                    color: Colors.blue[500],
                                    fontWeight: FontWeight.w700,
                                  ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    TextButton(
                      onPressed: Navigator.of(context).pop,
                      child: const Text(
                        'Later',
                      ),
                    ),
                    const Spacer(),
                    AppButton(
                      text: 'Update',
                      width: 150,
                      borderRadius: 30.0,
                      onTap: () {
                        _launchInBrowser(Uri.parse(downloadLink ??
                            'https://play.google.com/store/apps/details?id=com.beracare.bera_app'));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
