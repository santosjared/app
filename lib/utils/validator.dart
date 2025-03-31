typedef FunctionRules = String? Function(String value);

class Validator {
  static FunctionRules isString({required String message}) {
    return (String value) {
      if (double.tryParse(value) != null) {
        return message;
      }
      return null;
    };
  }

  static FunctionRules isRequired({required String message}) {
    return (String value) {
      if (value.isEmpty) {
        return message;
      }
      return null;
    };
  }

  static FunctionRules matches(RegExp regex, {required String message}) {
    return (String value) {
      if (!regex.hasMatch(value)) {
        return message;
      }
      return null;
    };
  }

  static FunctionRules isNumber({required String message}) {
    return (String value) {
      if (double.tryParse(value) == null) {
        return message;
      }
      return null;
    };
  }

  static FunctionRules length(int min, int max, {required String message}) {
    return (String value) {
      if (value.length < min || value.length > max) {
        return message;
      }
      return null;
    };
  }

  static String? validate(String value, List<FunctionRules> rules) {
    for (var rule in rules) {
      final error = rule(value);
      if (error != null) return error;
    }
    return null;
  }
}
