class NotificationModel {
  NotificationModel({
    required this.id,
    required this.title,
    required this.time,
    this.isRead = false,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        time: json['time'] ?? '',
        isRead: json['isRead'] ?? false,
      );
  final String id;
  final String title;
  final String time;
  final bool isRead;

  NotificationModel copyWith({
    String? id,
    String? title,
    String? time,
    bool? isRead,
  }) => NotificationModel(
    id: id ?? this.id,
    title: title ?? this.title,
    time: time ?? this.time,
    isRead: isRead ?? this.isRead,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'time': time,
    'isRead': isRead,
  };
}
