class TransactionModel {
  final int? id;
  final String title;
  final double amount;
  final String type;
  final String category;
  final String categoryIcon;
  final String? note;
  final DateTime date;

  TransactionModel({
    this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.category,
    required this.categoryIcon,
    this.note,
    required this.date,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'amount': amount,
    'type': type,
    'category': category,
    'categoryIcon': categoryIcon,
    'note': note ?? '',
    'date': date.toIso8601String(),
  };

  factory TransactionModel.fromMap(Map<String, dynamic> map) =>
      TransactionModel(
        id: map['id'],
        title: map['title'],
        amount: map['amount'],
        type: map['type'],
        category: map['category'],
        categoryIcon: map['categoryIcon'],
        note: map['note'],
        date: DateTime.parse(map['date']),
      );
}