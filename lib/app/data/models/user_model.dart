class UserModel {
  UserModel({
    required this.id,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    this.name,
    this.emailVerifiedAt,
    this.googleId,
    this.gender,
    this.phoneNumber,
    this.photo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String,
    name: json['name'] as String?,
    email: json['email'] as String,
    // Cek null sebelum parsing tanggal
    emailVerifiedAt: json['email_verified_at'] == null
        ? null
        : DateTime.parse(json['email_verified_at'] as String),
    googleId: json['google_id'] as String?,
    gender: json['gender'] as String?,
    phoneNumber: json['phone_number'] as String?,
    photo: json['photo'] as String?,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );
  final String id;
  final String? name;
  final String email;
  final DateTime? emailVerifiedAt;
  final String? googleId;
  final String? gender;
  final String? phoneNumber;
  final String? photo;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'email': email,
    'email_verified_at': emailVerifiedAt?.toIso8601String(),
    'google_id': googleId,
    'gender': gender,
    'phone_number': phoneNumber,
    'photo': photo,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  // copyWith sangat berguna untuk manajemen state (GetX, Riverpod, Bloc)
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    DateTime? emailVerifiedAt,
    String? googleId,
    String? gender,
    String? phoneNumber,
    String? photo,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UserModel(
    id: id ?? this.id,
    name: name ?? this.name,
    email: email ?? this.email,
    emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
    googleId: googleId ?? this.googleId,
    gender: gender ?? this.gender,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    photo: photo ?? this.photo,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
