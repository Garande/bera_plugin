class HealthCategory {
  final String? label, imageUrl, colorCode;
  final int? id;

  HealthCategory({
    this.id,
    this.label,
    this.imageUrl,
    this.colorCode,
  });

  factory HealthCategory.fromJson(var data) {
    return HealthCategory(
      id: data['id'],
      label: data['name'],
      imageUrl: data['image_url'],
      colorCode: data['color_code'],
    );
  }

  Map toMap() {
    return {
      'id': id,
      'name': label,
      'color_code': colorCode,
      'image_url': imageUrl,
    };
  }

  @override
  String toString() {
    return label.toString();
  }

  ///this method will prevent the override of toString
  String departmentAsString() {
    return '#$id $label';
  }

  ///this method will prevent the override of toString
  bool categoryFilterByName(String filter) {
    return label.toString().contains(filter);
  }

  ///custom comparing function to check if two users are equal
  bool isEqual(HealthCategory model) {
    return id == model.id;
  }
}
