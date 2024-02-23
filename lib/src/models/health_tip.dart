class HealthTip {
  final dynamic id, categoryId;
  final String? label, shortDescription, description;

  HealthTip({
    this.id,
    this.label,
    this.shortDescription,
    this.description,
    this.categoryId,
  });

  factory HealthTip.fromJson(var data) {
    // if (data == null) return null;
    return HealthTip(
      id: data['id'],
      label: data['label'],
      shortDescription: data['overview'],
      description: data['description'],
      categoryId: data['category_id'],
    );
  }
}
