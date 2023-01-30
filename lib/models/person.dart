class Person {
  String? name;
  String? surname;
  int? age;

  Person({
    this.name,
    this.surname,
    this.age,
  });

  static Person fromJson(Map<String, dynamic> json) {
    return Person(
        name: json['name'] as String,
        surname: json['surname'] as String,
        age: json['age'] as int);
  }
}
