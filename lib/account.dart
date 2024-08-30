import 'package:banking_application/auth_services.dart';
import 'package:banking_application/balance.dart';
import 'package:banking_application/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CreateAccount extends StatefulWidget {
  @override
  _CreateAccountState createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _accountNumber = TextEditingController();
  final TextEditingController _accountType = TextEditingController();
  final TextEditingController _balance = TextEditingController();
  final TextEditingController _bankName = TextEditingController();

  bool? _kycStatus;
  bool _activeStatus = false;
  bool _accountKyc = false;

  @override
  void initState() {
    super.initState();
    _fetchUserKYCStatus();
  }
  Future<void> _fetchUserKYCStatus() async {
    
    final url = '${base_url}/api/user/'; 
    final token = await AuthService.getToken();
    print(token);
    try {
      final response = await http.get(
        Uri.parse('${base_url}/api/user/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token', 
        },
      );
      
      
      print(response.statusCode);

      if (response.statusCode == 200) {
        print(token);

        print('******************');
        print(response.body);
        
        
        print((response.body));
        final List<dynamic> responseData = jsonDecode(response.body);
        if (responseData.isNotEmpty) {
          final kycStatus = responseData[0]['kyc_status'];
          setState(() {
            _kycStatus = kycStatus;
          });
          print('Printing Kyc ${_kycStatus})');
        } else {
          print('No user data found in response');
        }
      }
      else {
        print(
            'Failed to fetch user details, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }
  Future<void> CreateAccount(BuildContext context) async {
    final dio = Dio();
    final url = '${base_url}/api/account/';
    final userId = await AuthService.getUserId();
    final token = await AuthService.getToken();

    try {
      final response = await dio.post(
        url,
        data: {
          'account_number': _accountNumber.text,
          'account_holder_name': userId,
          'account_active_status': _activeStatus,
          'account_type': _accountType.text,
          'account_kyc': _kycStatus,
          'balance': _balance.text,
          'bank_name': _bankName.text
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 201) {
        print('Account is created');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
                token: token!, accountId: ""), 
          ),
        );
      } else {
        print('Failed to create user');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.greenAccent,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.black,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const Column(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Create Account",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      _buildInputField(
                        label: "Account Number",
                        controller: _accountNumber,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the account number';
                          }
                          return null;
                        },
                      ),
                      _buildInputField(
                        label: "Account Type",
                        controller: _accountType,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the account type';
                          }
                          return null;
                        },
                      ),
                      _buildInputField(
                        label: "Balance",
                        controller: _balance,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the balance';
                          }
                          return null;
                        },
                      ),
                      _buildInputField(
                        label: "Bank Name",
                        controller: _bankName,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the bank name';
                          }
                          return null;
                        },
                      ),
                      _buildCheckbox(
                        label: "Active Status",
                        value: _activeStatus,
                        onChanged: (value) {
                          setState(() {
                            _activeStatus = value ?? false;
                          });
                        },
                      ),
                      _buildCheckbox(
                        label: "Account KYC",
                        value: _accountKyc,
                        onChanged: (value) {
                          setState(() {
                            _accountKyc = value ?? false;
                          });
                        },
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 3, left: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: const Border(
                        bottom: BorderSide(color: Colors.black),
                        top: BorderSide(color: Colors.black),
                        left: BorderSide(color: Colors.black),
                        right: BorderSide(color: Colors.black),
                      ),
                    ),
                    child: MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          CreateAccount(context);
                        }
                      },
                      color: Colors.greenAccent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Text(
                        "Create Account",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildCheckbox({
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}
