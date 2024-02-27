import 'package:bera_plugin/src/common/hex_color.dart';
import 'package:bera_plugin/src/models/doctor.dart';
import 'package:bera_plugin/src/models/health_category.dart';
import 'package:bera_plugin/src/providers/app_provider.dart';
import 'package:bera_plugin/src/widgets/app_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'category_doctors_screen.dart';
import 'doctors_view.dart';

class DoctorsScreen extends StatefulWidget {
  const DoctorsScreen({
    Key? key,
    this.userId,
    required this.apiKey,
  }) : super(key: key);

  final dynamic userId;
  final String apiKey;

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 45.0),
          AppHeader(
            title: 'ASK THE DOCTORS',
            onBack: Navigator.of(context).pop,
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'Categories',
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 17.0,
                  ),
            ),
          ),
          const SizedBox(height: 5.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: _buildCategoriesView(),
          ),
          const SizedBox(height: 3.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'Available Doctors',
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 17.0,
                  ),
            ),
          ),
          const SizedBox(height: 5.0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: FutureBuilder<List<Doctor>>(
                future: AppProvider().fetchOnlineDoctors(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData &&
                      snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  List<Doctor> doctors = snapshot.data ?? [];

                  if (doctors.isEmpty) {
                    return Center(
                      child: Text(
                        'No doctor found',
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.bodyLarge?.copyWith(),
                      ),
                    );
                  }

                  return DoctorsView(
                    doctors: doctors,
                    apiKey: widget.apiKey,
                    userId: widget.userId,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox _buildCategoriesView() {
    return SizedBox(
      height: 80.0,
      child: FutureBuilder<List<HealthCategory>>(
        future: AppProvider().fetchCategories(),
        builder: (context, snapshot) {
          if (!snapshot.hasData &&
              snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          List<HealthCategory> categories = snapshot.data ?? [];

          return ListView.builder(
            itemCount: categories.length,
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              HealthCategory category = categories[index];
              return Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Column(
                  children: [
                    Container(
                      width: 50.0,
                      height: 45.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: HexColor(category.colorCode ?? '#000')
                            .withOpacity(.3),
                      ),
                      child: Material(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CategoryDoctorsScreen(
                                  category: category,
                                  apiKey: widget.apiKey,
                                  userId: widget.userId,
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(5.0),
                          highlightColor: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: SvgPicture.network(
                              category.imageUrl ?? '',
                              color: HexColor(category.colorCode ?? '#000'),
                            ),
                          ),
                        ),
                      ),

                      //  const Center(
                      //   child: Icon(
                      //     Icons.ac_unit_rounded,
                      //     color: HexColor(category.colorCode ?? '#000'),
                      //   ),
                      // ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      category.label ?? 'null',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Row _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          highlightColor: Colors.transparent,
          borderRadius: BorderRadius.circular(5.0),
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Theme.of(context).primaryColorDark,
            ),
          ),
        ),
        Text(
          'ASK THE DOCTORS',
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
}
