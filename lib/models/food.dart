import 'nutrition.dart';

class Food {
  String id;
  String name;
  Nutrition nutrition;

  Food({this.id, this.name, this.nutrition});

  Food.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    nutrition = Nutrition.fromJson(json['nutrition']);
  }
}