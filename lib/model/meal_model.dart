class Meal {
  final int id;
  final String foodName;
  final String food2Name;
  final String food3Name;
  final String mealType;
  final int calorie;

  Meal(
      {this.id,
      this.foodName,
      this.food2Name,
      this.food3Name,
      this.mealType,
      this.calorie});

  factory Meal.fromJson(Map json) {
    String type;
    return Meal(
        id: int.parse(json['id']),
        foodName: json['name'],
        food2Name: json['name2'],
        food3Name: json['name3'],
        mealType: json['type'] == '1'
            ? 'Breakfast'
            : json['type'] == '2'
                ? 'Lunch'
                : json['type'] == '3' ? 'Snack' : 'Dinner',
        calorie: int.parse(json['cal']));
  }
}
