class PersonFields {
  static final String name = "name";
  static final String surname = "surname";
  static final String age = "age";
}

class Person {
  String? name;
  String? surname;
  int? age;

  Person({
    this.name,
    this.surname,
    this.age,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
        name: json['name'] as String,
        surname: json['surname'] as String,
        age: json['age'] as int);
  }

  Map<String, Object?> toJson() {
    return {
      PersonFields.name: name,
      PersonFields.surname: surname,
      PersonFields.age: age,
    };
  }
}
