import 'package:flutter/foundation.dart';

class ApiConfig {
  static const String _apiBaseUrlOverride = String.fromEnvironment(
    'API_BASE_URL',
  );

  static String get baseUrl {
    if (_apiBaseUrlOverride.isNotEmpty) {
      return _removeTrailingSlash(_apiBaseUrlOverride);
    }

    if (kIsWeb) {
      return 'http://localhost:3000';
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:3000';
    }

    return 'http://localhost:3000';
  }

  static String _removeTrailingSlash(String url) {
    return url.endsWith('/') ? url.substring(0, url.length - 1) : url;
  }
}
