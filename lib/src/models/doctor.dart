import 'dart:convert';

import 'app_user.dart';
import 'department.dart';
import 'health_category.dart';

class Doctor {
  final int? id, userId, categoryId, departmentId;
  final String? experience;

  final bool? isValid;

  final Department? department;
  final HealthCategory? category;

  final AppUser? user;

  Doctor({
    this.id,
    this.categoryId,
    this.department,
    this.experience,
    this.userId,
    this.isValid,
    this.departmentId,
    this.category,
    this.user,
  });

  factory Doctor.fromMap(var data) {
    // printLog('DOCTORS ----------------');
    // printLog(data);
    return Doctor(
      id: data['id'],
      categoryId: data['category_id'],
      departmentId: data['department_id'],
      experience: '${data['experience']}',
      userId: data['user_id'],
      category: data['category'] != null
          ? HealthCategory.fromJson(data['category'])
          : null,
      department: data['department'] != null
          ? Department.fromMap(data['department'])
          : null,
      user: data['user'] != null ? AppUser.fromMap(data['user']) : null,
    );
  }

  Map toMap() {
    return {
      'category_id': categoryId,
      'department_id': departmentId,
      'department': department?.toMap(),
      'category': category?.toMap(),
      'experience': experience,
      'user_id': userId,
      'user': user?.toMap(),
    };
  }

  factory Doctor.fromJson(String source) => Doctor.fromMap(json.decode(source));

  toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'Doctor(${toJson()})';
  }
}
