class Inials {
  static String getInials(String firstName, String lastName) {
    String first = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    String last = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return first + last;
  }
}
