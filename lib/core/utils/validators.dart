class Validators {
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return "Email is required";
    }
    final emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      return "Enter a valid email";
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return "Password is required";
    }
    if (password.length < 6) {
      return "Password must be more than 6 character long";
    }
    return null;
  }

  static String? validateName(String? name) {
    if (name == null || name.trim().isEmpty) {
      return 'Name is required';
    }
    if (!RegExp(r"^[a-zA-Z]+$").hasMatch(name)) {
      return 'Only alphabets are allowed';
    }
    if (name.length < 2) {
      return 'Must be at least 2 characters long';
    }
    return null;
  }

  static String? validatePhone(String? phone) {
    if (phone == null || phone.trim().isEmpty) {
      return 'Phone number is required';
    }
    if (!RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
      return 'Enter a valid 10-digit phone number';
    }
    return null;
  }
}
