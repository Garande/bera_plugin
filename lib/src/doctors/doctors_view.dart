import 'dart:ui';

import 'package:bera_plugin/src/chat/chat_screen.dart';
import 'package:bera_plugin/src/models/doctor.dart';
import 'package:bera_plugin/src/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DoctorsView extends StatelessWidget {
  const DoctorsView({
    Key? key,
    required this.doctors,
    this.userId,
    required this.apiKey,
  }) : super(key: key);
  final List<Doctor> doctors;

  final dynamic userId;
  final String apiKey;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: doctors.length,
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      padding: const EdgeInsets.all(0.0),
      itemBuilder: (context, index) {
        Doctor doctor = doctors[index];

        return _buildDoctorView(doctor, context);
      },
    );
  }

  InkWell _buildDoctorView(Doctor doctor, BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      // borderRadius: BorderRadius.circular(4.0),
      onTap: () {
        handleDialog(doctor, context);
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5.0, left: 5.0),
            child: Row(
              children: [
                Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Theme.of(context).primaryColor,
                  ),
                  // padding: const EdgeInsets.all(5.0),
                  clipBehavior: Clip.hardEdge,
                  child: Image.network(
                    doctor.user?.imageUrl ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text(
                          doctor.user?.firstName != null
                              ? (doctor.user?.firstName ?? "BERA")[0]
                              : 'B',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
                                color: Colors.white,
                                fontSize: 26.0,
                              ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dr. ${doctor.user?.firstName} ${doctor.user?.lastName}',
                        textAlign: TextAlign.left,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontSize: 16.0),
                      ),
                      // const SizedBox(height: 1.0),
                      Text(
                        doctor.department?.name ?? '',
                        textAlign: TextAlign.left,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontSize: 14.0),
                      ),
                      // const SizedBox(height: 1.0),
                      Text(
                        '${doctor.experience} Years',
                        textAlign: TextAlign.left,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontSize: 13.0),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.grey[700],
                  size: 20.0,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8.0),
          const Divider(height: 1.0),
        ],
      ),
    );
  }

  Positioned _buildCloseButton(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      child: Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          color: Colors.black38,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(4.0),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(4.0),
          ),
          child: InkWell(
            highlightColor: Colors.transparent,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(4.0),
            ),
            onTap: Navigator.of(context).pop,
            child: const Center(
              child: Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  void handleDialog(Doctor doctor, BuildContext context) {
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
              child: Container(
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
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 80.0,
                                  height: 80.0,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    // color: Colors.white,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  child: Image.network(
                                    doctor.user?.imageUrl ?? '',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: Text(
                                          doctor.user?.firstName != null
                                              ? (doctor.user?.firstName ??
                                                  "BERA")[0]
                                              : 'B',
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayLarge
                                              ?.copyWith(
                                                color: Colors.white,
                                                fontSize: 26.0,
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  'Dr. ${doctor.user?.firstName} ${doctor.user?.lastName}',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontSize: 16.0),
                                ),
                                const SizedBox(height: 3.0),
                                Text(
                                  '${doctor.department?.name}',
                                  textAlign: TextAlign.left,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(fontSize: 14.0),
                                ),
                                const SizedBox(height: 3.0),
                                Text(
                                  '${doctor.experience} Years experience',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(fontSize: 13.0),
                                ),
                                const SizedBox(height: 25.0),
                                Row(
                                  children: [
                                    Expanded(
                                      child: AppButton(
                                        text: 'Voice Call',
                                        onTap: () async {
                                          _makePhoneCall(
                                              doctor.user?.phoneNumber ?? '');
                                        },
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        isOutlined: true,
                                      ),
                                    ),
                                    const SizedBox(width: 20.0),
                                    Expanded(
                                      child: AppButton(
                                        text: 'Chat',
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => ChatScreen(
                                                peerId: doctor.userId!,
                                                doctor: doctor,
                                                userId: userId,
                                                apiKey: apiKey,
                                              ),
                                            ),
                                          );
                                        },
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        isOutlined: true,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          //
                          _buildCloseButton(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
