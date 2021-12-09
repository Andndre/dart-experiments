enum Personality {
  INTROVERT,
  AMBIVERT,
  EXTROVERT,
  BOTH_INTROVERT_AND_AMBIVERT,
  BOTH_AMBIVERT_AND_EXTROVERT,
}

enum Gender {
  MALE,
  FEMALE,
  SECRET,
}

class Person {
  String name;
  DateTime birthday;
  Personality personality;
  Gender gender;

  Person({
    required this.name,
    required this.birthday,
    this.gender = Gender.SECRET,
    required this.personality,
  });

  Person.fromJSON(Map data)
      : name = data['name'],
        birthday = data['birthday'],
        personality = data['personality'],
        gender = data['gender'] ?? Gender.SECRET;

  void sayhi() {
    print('Hi, my name\'s $name, i\'am $age');
  }

  int get age {
    DateTime now = DateTime.now();
    return now.year -
        birthday.year -
        (now.month < birthday.month
            ? 1
            : now.month == birthday.month && now.day < birthday.day
                ? 1
                : 0);
  }
}
