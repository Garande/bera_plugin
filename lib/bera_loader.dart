import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'src/chat/all_chats_screen.dart';
import 'src/common/app_palette.dart';
import 'src/tips/health_tips_screen.dart';
import 'src/widgets/image_builder.dart';
import 'src/widgets/quick_access_card.dart';

class BeraLoader extends StatefulWidget {
  const BeraLoader({
    super.key,
    required this.apiKey,
    this.userId,
  });
  final String apiKey;
  final String? userId;

  @override
  State<BeraLoader> createState() => _BeraLoaderState();
}

class _BeraLoaderState extends State<BeraLoader> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            const SizedBox(height: 45.0),
            _buildHeader(context),
            const SizedBox(height: 5.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                'Welcome to BeraCare,\nHow would you like to be helped?',
                textAlign: TextAlign.start,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 22.0,
                    ),
              ),
            ),
            const SizedBox(height: 15.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: _buildQuickTools(),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ImageBuilder.asset(
                  'assets/images/logo/bera.png',
                  height: 30.0,
                  // color: Colors.grey[400],
                ),
                const SizedBox(width: 0.0),
                Text(
                  'Bera Care .',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
                ),
                Text(
                  'All Rights, Reserved',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
                )
              ],
            ),
            const SizedBox(height: 8.0),
          ],
        ),
      ),
    );
  }

  Row _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.grey.shade200,
          ),
          child: InkWell(
            highlightColor: Colors.transparent,
            borderRadius: BorderRadius.circular(5.0),
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.arrow_back,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
          ),
        ),
        Text(
          '',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: Theme.of(context).primaryColorDark,
                fontSize: 18.0,
              ),
        ),
        const SizedBox(
          height: 30,
          width: 30,
        )
      ],
    );
  }

  void handleDoctorCheck() {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      builder: (context) {
        return Container();
      },
    );
  }

  SizedBox _buildQuickTools() {
    return SizedBox(
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          // mainAxisExtent: 125,
          mainAxisSpacing: 8,
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 10),
        children: [
          QuickAccessCard(
            onTap: () {
              // BlocProvider.of<PaymentsBloc>(context).add(IsSubscribed());
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (_) => const DoctorsScreen(),
              //   ),
              // );
            },
            title: "Chat with Doctor",
            gradientStartColor: const Color(0xff13DEA0),
            gradientEndColor: const Color(0xff06B782),
            icon: SvgPicture.asset(
              'assets/images/icons/doctor.svg',
              height: 36.0,
              width: 36.0,
              color: Colors.white,
            ),
          ),
          // QuickAccessCard(
          //   onTap: () {
          //     // Navigator.push(
          //     //   context,
          //     //   MaterialPageRoute(
          //     //     builder: (_) => const AmbulanceRequestScreen(),
          //     //   ),
          //     // );
          //   },
          //   title: "Ambulances",
          //   color: AppPalette.black,
          //   icon: SvgPicture.asset(
          //     'assets/images/icons/ambulance.svg',
          //     height: 36.0,
          //     width: 36.0,
          //     color: Colors.white,
          //   ),
          // ),
          // QuickAccessCard(
          //   onTap: () {
          //     Helpers.showSnackBar(context, 'Comming soon', Colors.blue);
          //   },
          //   title: "Weight Tracker",
          //   gradientStartColor: const Color(0xffFFD541),
          //   gradientEndColor: const Color(0xffF0B31A),
          //   icon: SvgPicture.asset(
          //     'assets/images/icons/chart.svg',
          //     height: 34.0,
          //     width: 34.0,
          //     color: Colors.white,
          //   ),
          // ),
          QuickAccessCard(
            onTap: () {
              // Navigator.push(
              //     context,
              //     MaterialPageRoute(
              //         builder: (_) => const AppointmentsScreen()));
            },
            title: "My Prescriptions",
            color: AppPalette.instaBlue,
            icon: SvgPicture.asset(
              'assets/images/icons/medical.svg',
              height: 34.0,
              width: 34.0,
              color: Colors.white,
            ),
          ),
          QuickAccessCard(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HealthTipsScreen(
                    apiKey: widget.apiKey,
                  ),
                ),
              );
            },
            title: "Health Tips",
            color: AppPalette.darkBrown,
            icon: SvgPicture.asset(
              'assets/images/icons/healthcare-2.svg',
              height: 34.0,
              width: 34.0,
              color: Colors.white,
            ),
          ),
          QuickAccessCard(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AllChatsScreen(
                    apiKey: widget.apiKey,
                    userId: widget.userId,
                  ),
                ),
              );
            },
            title: "Chat History",
            color: AppPalette.black,

            // gradientStartColor: const Color(0xffFC67A7),
            // gradientEndColor: const Color(0xffF6815B),
            icon: SvgPicture.asset(
              'assets/images/icons/tab-2.svg',
              height: 34.0,
              width: 34.0,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
