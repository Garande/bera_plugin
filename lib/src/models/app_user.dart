import 'dart:convert';

class AppUser {
  // final String? name,
  //     userId,
  //     firstName,
  //     lastName,
  //     email,
  //     phoneNumber,
  //     countryCode,
  //     imageUrl,
  //     pushToken,
  //     loginId,
  //     gender,
  //     referralCode,
  //     countryDialCode,
  //     accountType;

  final String? firstName,
      lastName,
      imageUrl,
      gender,
      email,
      phoneNumber,
      countryCode,
      pushToken,
      referralCode,
      accountType;
  final int? id, role;
  final bool? isVerified;

  // final int? expectedDateOfBirth;
  // final bool? isPregnant;

  AppUser({
    this.firstName,
    this.lastName,
    this.email,
    this.phoneNumber,
    this.countryCode,
    this.imageUrl,
    this.pushToken,
    this.gender,
    this.referralCode,
    this.accountType,
    this.isVerified,
    this.id,
    this.role,
  });

  factory AppUser.fromMap(var data) {
    return AppUser(
      id: data['id'],
      firstName: data['first_name'],
      lastName: data['last_name'],
      imageUrl: data['image_url'],

      // != null
      //     ? "${ApiHelper.dashboard}/${data['image_url']}"
      //     : null,
      email: data['email'],
      phoneNumber: data['phone_number'],
      countryCode: data['country_code'],
      referralCode: data['referral_code'],
      accountType: data['account_type'],
      isVerified: data['is_verified'],
      gender: data['gender'],
      pushToken: data['push_token'],
      role: data['role'],
    );
  }

  Map toMap() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'image_url': imageUrl,
      'email': email,
      'phone_number': phoneNumber,
      'country_code': countryCode,
      'referral_code': referralCode,
      'is_verified': isVerified,
      'gender': gender,
      'role': role,
      'push_token': pushToken,
    };
  }

  String toJson() => json.encode(toMap());

  factory AppUser.fromJson(String source) =>
      AppUser.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => toJson();
}
