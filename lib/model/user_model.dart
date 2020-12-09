enum Gender { male, female }
enum Lifestyle { sedentary, lowActive, active, veryActive }

class UserPreferences {
  Gender gender;
  int age;
  int weight;
  double height;
  Lifestyle lifestyle;

  UserPreferences(this.gender, this.age, this.weight, this.height, this.lifestyle);

}
