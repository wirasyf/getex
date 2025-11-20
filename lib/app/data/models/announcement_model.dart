// Model untuk User
class UserModel {
  UserModel({required this.name, required this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel(name: json['name'] ?? '', email: json['email'] ?? '');
  final String name;
  final String email;
}

// Model untuk Admin (SUDAH AMAN)
class AdminModel {
  AdminModel({required this.id, required this.user});

  factory AdminModel.fromJson(Map<String, dynamic> json) => AdminModel(
    id: json['id'] ?? '',
    user: (json['user'] is Map<String, dynamic>)
        ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
        : UserModel.fromJson({}),
  );
  final String id;
  final UserModel user;
}

// Model untuk Category (SUDAH AMAN)
class CategoryModel {
  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    description: json['description'] ?? '',
  );
  final String id;
  final String name;
  final String description;
}

// Model Announcement (DIPERBAIKI: Menambahkan time dan location)
class AnnouncementModel {
  AnnouncementModel({
    required this.id,
    required this.title,
    required this.content,
    this.location,
    this.time,
    this.attachment,
    this.startDate,
    this.completionDate,
    this.admin,
    this.category,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) =>
      AnnouncementModel(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        content: json['content'] ?? '',
        
        // ✨ NEW: Menambahkan location dan time
        location: json['location']?.toString(), 
        time: json['time']?.toString(),
        
        attachment: json['attachment']?.toString(),
        startDate: json['start_date']?.toString(),
        completionDate: json['completion_date']?.toString(),

        // Memastikan 'admin' adalah Map sebelum memproses
        admin: (json['admin'] is Map<String, dynamic>)
            ? AdminModel.fromJson(json['admin'] as Map<String, dynamic>)
            : null,

        // Memastikan 'category' adalah Map sebelum memproses
        category: (json['category'] is Map<String, dynamic>)
            ? CategoryModel.fromJson(json['category'] as Map<String, dynamic>)
            : null,
      );

  final String id;
  final String title;
  final String content;
  final String? location;
  final String? time;
  final String? attachment;
  final String? startDate;
  final String? completionDate;
  final AdminModel? admin;
  final CategoryModel? category;

  Map<String, dynamic> toJson() => {
      'id': id,
      'title': title,
      'content': content,
      'location': location,
      'time': time,
      'attachment': attachment,
      'start_date': startDate,
      'completion_date': completionDate,
      'admin': admin?.id,
      'category': category?.id,
    };
}
