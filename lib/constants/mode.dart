enum Mode { lightMode, darkMode }

enum Token { access, refresh }

extension TokenExtension on Token {
  String get token {
    switch (this) {
      case Token.access:
        return 'access_token';
      case Token.refresh:
        return 'refresh_token';
    }
  }
}
