class StudentModel {
  String name;
  String age;
  String password;
  String currentClass;
  String rollNo;
  String address;
  String father;
  String mother;
  String image;
  StudentModel({
    required this.name,
    required this.age,
    required this.password,
    required this.currentClass,
    required this.rollNo,
    required this.address,
    required this.father,
    required this.mother,
    required this.image,
  });
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "age": age,
      "password": password,
      "currentClass": currentClass,
      "rollNo": rollNo,
      "address": address,
      "father": father,
      "mother": mother,
      "image": image,
    };
  }

  factory StudentModel.fromMap(Map<String, dynamic> json) {
    return StudentModel(
        name: json['name'],
        age: json['age'],
        password: json['password'],
        currentClass: json['currentClass'],
        rollNo: json['rollNo'],
        address: json['address'],
        father: json['father'],
        image: json['image'],
        mother: json['mother']);
  }
}
