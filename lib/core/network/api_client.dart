import 'package:sevenseers/core/error/failures.dart';

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client _client;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  Future<Map<String, dynamic>> get(String url) async {
    try {
      final response = await _client
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        throw const ServerFailure('Server returned an error');
      }
    } on SocketException {
      throw const NetworkFailure('No internet connection');
    } on FormatException {
      throw const ParseFailure('Invalid response format');
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure('Unexpected error: ${e.toString()}');
    }
  }
}
