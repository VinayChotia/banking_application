import 'dart:convert';
import 'package:banking_application/account_services.dart';
import 'package:banking_application/auth_services.dart';
import 'package:banking_application/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class KycTogglePage extends StatefulWidget {
  const KycTogglePage({super.key});

  @override
  _KycTogglePageState createState() => _KycTogglePageState();
}

class _KycTogglePageState extends State<KycTogglePage> {
  bool? _kycStatus;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchKycStatus();
    _loadAccountNumber();
  }

  void _loadAccountNumber() async {
    String? accountNumber = await AccountService().fetchAccountNumber();
    if (accountNumber != null) {
      print('Fetched account number: $accountNumber');
    } else {
      print('No account number found or failed to fetch.');
    }
  }

  Future<void> _fetchKycStatus() async {
    final token = await AuthService.getToken();
    final response = await http.get(
      Uri.parse('${base_url}/api/user/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> userDetailsList = jsonDecode(response.body);

      if (userDetailsList.isNotEmpty) {
        final userDetails = userDetailsList[0];
        setState(() {
          _kycStatus = userDetails['kyc_status'] == true;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No user details found')),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch KYC status: ${response.body}')),
      );
    }
  }

  Future<void> toggleKycStatus() async {
    final token = await AuthService.getToken();
    setState(() {
      _isLoading = true;
    });

    String? accountNumber = await AccountService().fetchAccountNumber();
    final response = await http.put(
      Uri.parse('${base_url}/api/kyc-update/$accountNumber/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, bool>{
        'kyc_status': !_kycStatus!,
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      setState(() {
        _kycStatus = !_kycStatus!;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('KYC status updated successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to update KYC status: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toggle KYC Status'),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Current KYC Status: ${_kycStatus == null ? 'Unknown' : (_kycStatus! ? 'Verified' : 'Not Verified')}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: toggleKycStatus,
                    child: const Text('Toggle KYC Status'),
                  ),
                ],
              ),
      ),
    );
  }
}
