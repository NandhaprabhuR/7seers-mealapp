class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';
  static const String searchEndpoint = '$baseUrl/search.php';
  static const String lookupEndpoint = '$baseUrl/lookup.php';
  static const String defaultSearch = '$baseUrl/search.php?s=';
}
