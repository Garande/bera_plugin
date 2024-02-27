import 'package:bera_plugin/src/models/doctor.dart';
import 'package:bera_plugin/src/models/health_category.dart';
import 'package:bera_plugin/src/providers/app_provider.dart';
import 'package:flutter/material.dart';

import 'doctors_view.dart';

class CategoryDoctorsScreen extends StatefulWidget {
  const CategoryDoctorsScreen({
    Key? key,
    required this.category,
    this.userId,
    required this.apiKey,
  }) : super(key: key);
  final HealthCategory category;

  final dynamic userId;
  final String apiKey;

  @override
  State<CategoryDoctorsScreen> createState() => _CategoryDoctorsScreenState();
}

class _CategoryDoctorsScreenState extends State<CategoryDoctorsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 45.0),
            _buildHeader(context),
            const SizedBox(height: 10.0),
            Expanded(
              child: FutureBuilder<List<Doctor>>(
                future: AppProvider()
                    .fetchOnlineDoctors(categoryId: widget.category.id),
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
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 17.0,
                            ),
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
          ],
        ),
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
          '${widget.category.label?.toUpperCase()}',
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
