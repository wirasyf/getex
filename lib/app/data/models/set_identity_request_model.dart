class SetIdentityRequestModel {
  final String name;
  final String status;
  final String gender;
  final String birthDate; // String YYYY-MM-DD
  final String phoneNumber;
  final String rtCode;

  SetIdentityRequestModel({
    required this.name,
    required this.status,
    required this.gender,
    required this.birthDate,
    required this.phoneNumber,
    required this.rtCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'status': status,
      'gender': gender,
      'birth_date': birthDate,
      'phone_number': phoneNumber,
      'rt_code': rtCode,
    };
  }
}