import 'dart:convert';

import 'package:bera_plugin/bera_plugin.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

// import 'log.dart';

class ApiHelper {
  static String baseURL = 'https://dashboard.beracare.com/api';
  static String dashboard = 'https://dashboard.beracare.com';

  static Map<String, String> getHeaders() {
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      // x-api-key
      'x-api-key': '${BeraPlugin.instance.apiKey}',
      if (BeraPlugin.instance.secretKey != null) ...{
        'secret': '${BeraPlugin.instance.secretKey}',
      }
    };
  }

  static Future<Map<String, dynamic>> fetchData({
    required String url,
    Map<String, String>? headers,
    required String apiKey,
  }) async {
    // printLog(PrefsUtil.getString(PrefsKey.token));

    final response = await http.get(
      Uri.parse(url),
      headers: headers ?? getHeaders(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final Map<String, dynamic> parsed = jsonDecode(response.body);
      return parsed;
    } else if (response.statusCode == 400) {
      final Map<String, dynamic> parsed = jsonDecode(response.body);
      String? message = parsed['message'];
      throw message ?? 'Invalid request';
    } else if (response.statusCode == 401) {
      final Map<String, dynamic> parsed = jsonDecode(response.body);
      String? message = parsed['message'];
      throw message ?? 'Unauthorized';
    } else {
      throw 'Error processing request ...';
    }
  }

  static Future uploadFormData({
    required FormData formData,
    required String url,
    required String apiKey,
  }) async {
    try {
      var dio = Dio();

      final response = await dio.post(
        url,
        data: formData,
        options: Options(headers: {"x-api-key": apiKey}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(jsonEncode(response.data));
      } else if (response.statusCode == 400) {
        final Map<String, dynamic> parsed = jsonDecode(response.data);
        String? message = parsed['message'];
        throw message ?? 'Invalid request';
      } else if (response.statusCode == 401 || response.statusCode == 405) {
        try {
          final Map<String, dynamic> parsed = jsonDecode(response.data);
          // String? message = parsed['message'];
          throw parsed['message'] ?? parsed['error'] ?? 'Unauthorized';
        } catch (e) {
          rethrow;
          // jsonDecode(response.body);
        }
      } else if (response.statusCode == 503) {
        throw 'Service Temporarily Unavailable';
      } else {
        // printLog(response.data);
        throw 'Error processing request ...';
      }

      //
    } catch (e) {
      // printLog(e);
      if (e.runtimeType == String) {
        throw e.toString();
      } else if (e.runtimeType == DioError) {
        var error = e as DioError;

        if (error.response?.statusCode == 404) {
          throw 'Error: Request not found!';
        } else {
          throw error.response?.data['message'] ?? error.message;
        }
      } else {
        throw 'Error: Unable to process Request!';
      }
    }
  }

  static Future postData({
    dynamic query,
    Map<String, String>? headers,
    required String url,
    required String apiKey,
  }) async {
    // printLog(url);
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(query),
      headers: headers ?? getHeaders(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 400 || response.statusCode == 422) {
      final Map<String, dynamic> parsed = jsonDecode(response.body);

      if (parsed['status'] == 'validation_error') {
        var errors = parsed['errors'] as Map;
        var error = (errors.values.first as List).first;
        throw error;
      } else {
        String? message = parsed['message'];
        throw message ?? 'Invalid request';
      }
      //
    } else if (response.statusCode == 401 || response.statusCode == 403) {
      try {
        final Map<String, dynamic> parsed = jsonDecode(response.body);
        // String? message = parsed['message'];
        throw parsed['message'] ?? parsed['error'] ?? 'Unauthorized';
      } catch (e) {
        rethrow;
        // jsonDecode(response.body);
      }
    } else if (response.statusCode == 503) {
      throw 'Service Temporarily Unavailable';
    } else {
      // printLog(response.body);
      throw 'Error processing request ...';
    }
  }

  static Future patchData({
    dynamic query,
    Map<String, String>? headers,
    required String url,
    required String apiKey,
  }) async {
    final response = await http.put(
      Uri.parse(url),
      body: jsonEncode(query),
      headers: headers ?? getHeaders(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      final Map<String, dynamic> parsed = jsonDecode(response.body);
      String? message = parsed['message'];
      throw message ?? 'Invalid request';
    } else if (response.statusCode == 401) {
      try {
        final Map<String, dynamic> parsed = jsonDecode(response.body);
        String? message = parsed['detail'] ?? parsed['message'];
        throw message ?? 'Unauthorized';
      } catch (e) {
        throw response.body;
      }
    } else if (response.statusCode == 503) {
      throw 'Service Temporarily Unavailable';
    } else {
      // print(response.body);
      throw 'Error processing request ...';
    }
  }

  static Future deleteData({
    required String url,
    Map<String, String>? headers,
    required String apiKey,
  }) async {
    final response = await http.delete(
      Uri.parse(url),
      headers: headers ?? getHeaders(),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 400) {
      final Map<String, dynamic> parsed = jsonDecode(response.body);
      String? message = parsed['message'];
      throw message ?? 'Invalid request';
    } else if (response.statusCode == 401) {
      try {
        final Map<String, dynamic> parsed = jsonDecode(response.body);
        String? message = parsed['detail'] ?? parsed['message'];
        throw message ?? 'Unauthorized';
      } catch (e) {
        throw response.body;
      }
    } else if (response.statusCode == 503) {
      throw 'Service Temporarily Unavailable';
    } else {
      // printLog(response.body);
      throw 'Please check your internet connection';
    }
  }
}
