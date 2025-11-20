import 'maps.dart'; 

class ProfileModel {
  ProfileModel({
    required this.id,
    required this.email,
    required this.roles,
    this.name, 
    this.username, 
    this.gender,
    this.phoneNumber,
    this.photo,
    this.dob,
    this.address,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> rolesJson = json['roles'] ?? [];
    final rolesList = rolesJson.map((role) => role.toString()).toList();
    final familyData = json['family'] as Map<String, dynamic>?;

    final AddressModel? address = familyData != null
        ? AddressModel.fromJson(familyData)
        : null;

    return ProfileModel(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? 'email.error@example.com',
      roles: rolesList,
      name: json['name'] as String?,
      username: json['username'] as String?,
      gender: json['gender'] as String?,
      phoneNumber: json['phone_number'] as String?,
      photo: json['photo'] as String?,
      dob: json['birth_date'] as String?, 
      address: address, 
    );
  }

  final String id;
  final String? name;
  final String? username;
  final String email;
  final String? gender;
  final String? phoneNumber;
  final String? photo;
  final List<String> roles;
  final String? dob;
  final AddressModel? address; // <-- Data alamat Anda akan disimpan di sini
}
