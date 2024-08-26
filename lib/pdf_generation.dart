import 'dart:io';
import 'package:banking_application/auth_services.dart';
import 'package:banking_application/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class GeneratePdfPage extends StatelessWidget {
  GeneratePdfPage({Key? key}) : super(key: key);

  Future<void> generateAndDownloadPdf(BuildContext context) async {
    final token = await AuthService.getToken();
    final response = await http.get(
      Uri.parse('${base_url}/api/generate/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization':
            'Bearer $token', // Add your JWT token here
      },
    );



    if (response.statusCode == 200) {
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/generated.pdf';
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF downloaded to $filePath')),
      );

      OpenFile.open(filePath);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate PDF: ${response.body}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate and Download PDF'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            generateAndDownloadPdf(context);
          },
          child: Text('Generate PDF'),
        ),
      ),
    );
  }
}
