class Validator {

  var regEmail = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  var regPassword = RegExp(
      r"((?=.*\d)(?=.*[A-Z])(?=.*\W).{8,8})");

}
