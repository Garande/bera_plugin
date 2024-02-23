import 'dart:convert';

class Department {
  final int? id;
  final String? name, description, imageUrl;

  Department({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  factory Department.fromMap(Map data) {
    return Department(
      id: data['id'],
      name: data['name'],
      description: data['description'],
      imageUrl: data['image_url'],
    );
  }

  Map toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
    };
  }

  String toJson() => json.encode(toMap());

  factory Department.fromJson(String source) =>
      Department.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return name.toString();
  }

  ///this method will prevent the override of toString
  String departmentAsString() {
    return '#$id $name';
  }

  ///this method will prevent the override of toString
  bool departmentFilterByName(String filter) {
    return name.toString().contains(filter);
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(Department model) {
    return id == model.id;
  }
}
