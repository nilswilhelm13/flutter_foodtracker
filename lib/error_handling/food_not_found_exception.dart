class FoodNotFoundException implements Exception {
  String ean;
  FoodNotFoundException(this.ean);
}