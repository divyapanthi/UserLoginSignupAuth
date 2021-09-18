class GlobalAuthValidator {

  static String? validateEmail(String email) {
    if(email.isEmpty){
      return "Please enter an email";
    }
    else if (email.contains("@") && email.contains(".")) {
      return null;
    } else {
      return "Invalid Email";
    }
  }

  static String? validatePassword(String password) {
    if (password.length > 4) {
      password = password;
      return null;
    } else {
      return "Password length should be min of 5 characters";
    }
  }

}