import 'base_entity.dart';

class Company extends BaseEntity {
  Company({required super.id, required super.name});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(id: json['id'], name: json['name']);
  }
}
