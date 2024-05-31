class TeacherModel {
  String name;
  String age;
  String password;
  String experience;
  String address;
  String currentClass;
  String image;
  List<String> teachingClasses;

  TeacherModel(
      {required this.name,
      required this.age,
      required this.password,
      required this.experience,
      required this.address,
      required this.currentClass,
      required this.image,
      required this.teachingClasses});

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "age": age,
      "password": password,
      "experience": experience,
      "currentClass": currentClass,

      "teachingClasses": teachingClasses,
      "address": address,
      "image": image,
    };
  }

  factory TeacherModel.fromMap(Map<String, dynamic> json) {
    List<String> teachingClasses =
        (json['teachingClasses'] as List).map((e) => e.toString()).toList();

    return TeacherModel(
        name: json['name'],
        age: json['age'],
        password: json['password'],
        experience: json['experience'],
        address: json['address'],
        currentClass: json['currentClass'],
        image: json['image'],
        teachingClasses: teachingClasses);
  }
}
