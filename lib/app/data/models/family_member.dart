import 'package:flutter/material.dart';

class FamilyMember {
  const FamilyMember({
    required this.id,
    required this.name,
    required this.initials,
    required this.color,
    this.relation,
    this.phoneNumber,
  });

  /// Create FamilyMember from JSON
  factory FamilyMember.fromJson(Map<String, dynamic> json) => FamilyMember(
    id: json['id'] as String,
    name: json['name'] as String,
    initials: json['initials'] as String,
    color: Color(json['color'] as int),
    relation: json['relation'] as String?,
    phoneNumber: json['phone_number'] as String?,
  );
  final String id;
  final String name;
  final String initials;
  final Color color;
  final String? relation;
  final String? phoneNumber;

  /// Convert FamilyMember to JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'initials': initials,
    // ignore: deprecated_member_use
    'color': color.value,
    'relation': relation,
    'phone_number': phoneNumber,
  };

  /// Create a copy of FamilyMember with updated fields
  FamilyMember copyWith({
    String? id,
    String? name,
    String? initials,
    Color? color,
    String? relation,
    String? phoneNumber,
  }) => FamilyMember(
    id: id ?? this.id,
    name: name ?? this.name,
    initials: initials ?? this.initials,
    color: color ?? this.color,
    relation: relation ?? this.relation,
    phoneNumber: phoneNumber ?? this.phoneNumber,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FamilyMember &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() =>
      'FamilyMember(id: $id, name: $name, initials: $initials)';
}
