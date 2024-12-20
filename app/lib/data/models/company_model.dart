import 'base_model.dart';

class CompanyModel extends BaseEntity {
  CompanyModel({
    required super.id,
    required super.name,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
