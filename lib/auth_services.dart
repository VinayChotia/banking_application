import 'package:banking_application/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getString('jwt_token'));
    return prefs.getString('jwt_token');
  }

  static Future<String?> getaccountId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('account_number');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
  }

  static Future<String?> getUserId() async {
    final token = await getToken();
    final url = '${base_url}/api/user/'; // Update with your API endpoint

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);

        if (responseData.isNotEmpty) {
          return responseData[0]['username']
              .toString(); // Assuming 'id' is the user ID field
        } else {
          print('No user data found in response');
          return null;
        }
      } else {
        print(
            'Failed to fetch user details, status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching user details: $e');
      return null;
    }
  }
}
