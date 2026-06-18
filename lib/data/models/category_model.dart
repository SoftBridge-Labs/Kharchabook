class CategoryModel {
  final int? id;
  final String name;
  final String icon;
  final String color;

  CategoryModel({this.id, required this.name,
    required this.icon, required this.color});

  Map<String, dynamic> toMap() =>
      {'id': id, 'name': name, 'icon': icon, 'color': color};

  factory CategoryModel.fromMap(Map<String, dynamic> map) =>
      CategoryModel(id: map['id'], name: map['name'],
          icon: map['icon'], color: map['color']);
}