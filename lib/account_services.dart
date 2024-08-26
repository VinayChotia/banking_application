import 'dart:convert';
import 'package:banking_application/auth_services.dart';
import 'package:banking_application/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AccountService {
  Future<String?> fetchAccountNumber() async {
    final token = await AuthService.getToken();
    final response = await http.get(
      Uri.parse('${base_url}/api/account/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> accountsList = jsonDecode(response.body);
      if (accountsList.isNotEmpty) {
        final accountDetails = accountsList[0];
        return accountDetails['account_number'];
      } else {
        print('No accounts found for the user.');
        return null;
      }
    } else {
      print('Failed to fetch account details: ${response.body}');
      return null;
    }
  }
}
