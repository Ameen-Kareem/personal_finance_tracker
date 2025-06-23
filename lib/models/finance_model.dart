import 'package:objectbox/objectbox.dart';

@Entity()
class Finance {
  @Id()
  int id = 0;

  double amount;
  String category;
  DateTime date;
  String type;
  String? description;

  Finance({
    required this.amount,
    required this.category,
    required this.date,
    required this.type,
    this.description,
  });
}
