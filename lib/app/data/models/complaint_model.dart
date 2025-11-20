class ComplaintModel {

  ComplaintModel({
    required this.id,
    required this.familyId,
    required this.userId,
    required this.title,
    required this.description,
    required this.period,
    required this.image,
    required this.replyImage,
    required this.reply,
    required this.status,
    required this.repliedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.family,
    required this.user,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) => ComplaintModel(
      id: json['id'],
      familyId: json['family_id'],
      userId: json['user_id'],
      title: json['title'],
      description: json['description'],
      period: json['period'],
      image: json['image'],
      replyImage: json['reply_image'],
      reply: json['reply'],
      status: json['status'],
      repliedAt: json['replied_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
      family: Family.fromJson(json['family']),
      user: User.fromJson(json['user']),
    );
  final String id;
  final String familyId;
  final String userId;
  final String title;
  final String description;
  final String period;
  final String? image;
  final String? replyImage;
  final String? reply;
  final String status;
  final String? repliedAt;
  final String createdAt;
  final String updatedAt;
  final String? deletedAt;

  final Family family;
  final User user;
}

class Family {

  Family({
    required this.id,
    required this.adminId,
    required this.userId,
    required this.latitude,
    required this.longitude,
    required this.location,
    required this.province,
    required this.district,
    required this.subDistrict,
    required this.village,
    required this.rt,
    required this.rw,
    required this.blok,
    required this.address,
    required this.createdAt,
    required this.updatedAt,
    required this.addressDetail,
  });

  factory Family.fromJson(Map<String, dynamic> json) => Family(
      id: json['id'],
      adminId: json['admin_id'],
      userId: json['user_id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      location: json['location'],
      province: json['province'],
      district: json['district'],
      subDistrict: json['sub_district'],
      village: json['village'],
      rt: json['rt'],
      rw: json['rw'],
      blok: json['blok'],
      address: json['address'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      addressDetail: json['address_detail'],
    );
  final String id;
  final String adminId;
  final String userId;
  final String latitude;
  final String longitude;
  final String? location;
  final String province;
  final String district;
  final String subDistrict;
  final String village;
  final String rt;
  final String rw;
  final String? blok;
  final String address;
  final String createdAt;
  final String updatedAt;
  final String addressDetail;
}

class User {

  User({
    required this.id,
    required this.name,
    required this.status,
    required this.birthDate,
    required this.email,
    required this.emailVerificationCode,
    required this.emailVerifiedAt,
    required this.googleId,
    required this.gender,
    required this.phoneNumber,
    required this.photo,
    required this.createdAt,
    required this.updatedAt,
    required this.username,
    required this.resetCode,
    required this.resetCodeExpiresAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      birthDate: json['birth_date'],
      email: json['email'],
      emailVerificationCode: json['email_verification_code'],
      emailVerifiedAt: json['email_verified_at'],
      googleId: json['google_id'],
      gender: json['gender'],
      phoneNumber: json['phone_number'],
      photo: json['photo'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      username: json['username'],
      resetCode: json['reset_code'],
      resetCodeExpiresAt: json['reset_code_expires_at'],
    );
  final String id;
  final String name;
  final String status;
  final String birthDate;
  final String email;
  final String? emailVerificationCode;
  final String? emailVerifiedAt;
  final String? googleId;
  final String gender;
  final String phoneNumber;
  final String? photo;
  final String createdAt;
  final String updatedAt;
  final String username;
  final String? resetCode;
  final String? resetCodeExpiresAt;
}
