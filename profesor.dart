import 'person.dart';

enum Class { MIPA, IPS, IPB }

class Profesor extends Person {
  String name;
  DateTime birthday;
  Personality personality;
  Gender gender;
  int bill;
  Class class_;

  Profesor({
    required this.name,
    required this.birthday,
    required this.gender,
    required this.personality,
    required this.bill,
    required this.class_,
  }) : super(
          name: name,
          birthday: birthday,
          personality: personality,
          gender: gender,
        );
}
