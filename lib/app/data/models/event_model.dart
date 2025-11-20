// Model User (untuk admin)
class UserModel {
  UserModel({required this.name, required this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        name: json['name'] ?? '',
        email: json['email'] ?? '',
      );

  final String name;
  final String email;
}

// Model Admin
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

// Model Event
class EventModel {
  EventModel({
    required this.id,
    required this.eventName,
    required this.description,
    this.time,
    this.startDate,
    this.endDate,
    this.location,
    this.image,
    this.admin,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => EventModel(
        id: json['id'] ?? '',
        eventName: json['event_name'] ?? '',
        description: json['description'] ?? '',
        time: json['time']?.toString(),
        startDate: json['start_date']?.toString(),
        endDate: json['end_date']?.toString(),
        location: json['location']?.toString(),
        image: json['image']?.toString(),
        admin: (json['admin'] is Map<String, dynamic>)
            ? AdminModel.fromJson(json['admin'] as Map<String, dynamic>)
            : null,
      );

  final String id;
  final String eventName;
  final String description;
  final String? time;
  final String? startDate;
  final String? endDate;
  final String? location;
  final String? image;
  final AdminModel? admin;

  Map<String, dynamic> toJson() => {
        'id': id,
        'event_name': eventName,
        'description': description,
        'time': time,
        'start_date': startDate,
        'end_date': endDate,
        'location': location,
        'image': image,
        'admin': admin?.id,
      };
}
