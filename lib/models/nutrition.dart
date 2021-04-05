class Nutrition {
  double energy;
  double fat;
  double carbohydrate;
  double protein;
  double salt;

  Nutrition({this.energy, this.fat, this.carbohydrate, this.protein, this.salt});

  Nutrition.fromJson(Map<String, dynamic> json) {
    energy = json['energy'] == null ? 0 : json['energy'] is int ? (json['energy'] as int).toDouble() : json['energy'];
    fat = json['fat'] == null ? 0 : json['fat'] is int ? (json['fat'] as int).toDouble() : json['fat'];
    carbohydrate = json['carbohydrate'] == null ? 0 : json['carbohydrate'] is int? (json['carbohydrate'] as int).toDouble() : json['carbohydrate'];
    protein = json['protein'] == null ? 0 : json['protein'] is int ? (json['protein'] as int).toDouble() : json['protein'];
    salt = json['salt'] == null ? 0 : json['salt'] is int ? (json['salt'] as int).toDouble() : json['salt'];
  }

  bool isEmpty() {
    return energy == 0 && fat == 0 && carbohydrate == 0 && protein == 0 && salt == 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'energy': energy,
      'fat': fat,
      'carbohydrate': carbohydrate,
      'protein': protein,
    };
  }
}