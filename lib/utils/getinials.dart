class Inials {
  static String getInials(String FirstName, String lastName) {
    String first = FirstName.isNotEmpty ? FirstName[0].toUpperCase() : '';
    String last = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return first + last;
  }
}
