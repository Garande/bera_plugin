import 'package:bera_plugin/bera_plugin.dart';
import 'package:bera_plugin/src/common/api_helper.dart';
import 'package:bera_plugin/src/models/doctor.dart';
import 'package:bera_plugin/src/models/health_category.dart';

class AppProvider {
  // List of available doctors
  Future<List<Doctor>> fetchOnlineDoctors({
    int? categoryId,
    int? departmentId,
    String? status,
  }) {
    var url = '${ApiHelper.baseURL}/doctors?status=$status';
    if (categoryId != null) {
      url = '$url&category=$categoryId';
    }

    if (departmentId != null) {
      url = '$url&department=$departmentId';
    }

    return ApiHelper.fetchData(
      url: url,
      apiKey: BeraPlugin.instance.authKey!,
    ).then(
      (value) =>
          List.from(value['data']).map((e) => Doctor.fromMap(e)).toList(),
    );
  }

  Future<List<HealthCategory>> fetchCategories() {
    return ApiHelper.fetchData(
      url: '${ApiHelper.baseURL}/categories',
      apiKey: BeraPlugin.instance.authKey!,
    ).then((value) => List.from(value['data'])
        .map((e) => HealthCategory.fromJson(e))
        .toList());
  }
}
