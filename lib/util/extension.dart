extension Name on String{
  bool get isValidName{
    final nameRegExp =  RegExp(r"^[a-zA-Z ]*$");
    return nameRegExp.hasMatch(this);
  }
}