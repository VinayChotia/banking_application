import 'package:animate_do/animate_do.dart';
import 'package:banking_application/Profile_page.dart';
import 'package:banking_application/auth_services.dart';
import 'package:banking_application/balance.dart';
import 'package:banking_application/constants.dart';
import 'package:banking_application/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TransferMoney extends StatelessWidget {
  TransferMoney({super.key});
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tagetaccountController = TextEditingController();

  final TextEditingController _amountController = TextEditingController();
  final token = AuthService.getToken();
  final accountId = AuthService.getaccountId();
  final TextEditingController _sourceaccountController =
      TextEditingController();

  Future<void> transfer(BuildContext context) async {
    //login user method
    String? tok = await token;
    print(tok);
    // Handle the case where the token is null

    // Exit the function early if the token is null

    final String sourceaccount = _sourceaccountController.text.trim();
    final String targetaccount = _tagetaccountController.text.trim();
    final String amount = _amountController.text.trim();
    String? account_number = await accountId;
    final response = await http.post(
      Uri.parse('${base_url}/api/transfer/${sourceaccount}/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer $tok"
      },
      body: jsonEncode(<String, String>{
        'source_account': sourceaccount,
        'target_account': targetaccount,
        'amount': amount,
      }),
    );

    if (response.statusCode == 200) {
      print("success");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
              token: tok!, accountId: ""), // accountId will be set later
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('$tok'),
            content: Text((response.statusCode).toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
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
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode
              .onUserInteraction, //auto validate to ensure the fields are met on user interaction.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      FadeInUp(
                          duration: const Duration(milliseconds: 1000),
                          child: const Text(
                            "Transfer",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: <Widget>[
                        FadeInUp(
                            duration: const Duration(milliseconds: 1200),
                            child: makeInput(
                                label: "source_account",
                                controller: _sourceaccountController)),
                        FadeInUp(
                            duration: const Duration(milliseconds: 1300),
                            child: makeInput(
                                label: "target_account",
                                obscureText: false,
                                controller: _tagetaccountController)),
                        FadeInUp(
                            duration: const Duration(milliseconds: 1300),
                            child: makeInput(
                                label: "amount",
                                obscureText: false,
                                controller: _amountController)),
                      ],
                    ),
                  ),
                  FadeInUp(
                      duration: const Duration(milliseconds: 1400),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Container(
                          padding: const EdgeInsets.only(top: 3, left: 3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: const Border(
                                bottom: BorderSide(color: Colors.black),
                                top: BorderSide(color: Colors.black),
                                left: BorderSide(color: Colors.black),
                                right: BorderSide(color: Colors.black),
                              )),
                          child: MaterialButton(
                            minWidth: double.infinity,
                            height: 60,
                            onPressed: () {
                              transfer(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Transfer Initiated')),
                              );
                            },
                            color: Colors.greenAccent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            child: const Text(
                              "Transfer",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget makeInput(
    {label, obscureText = false, required TextEditingController controller}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        label,
        style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
      ),
      const SizedBox(
        height: 5,
      ),
      TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400)),
          border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade400)),
        ),
      ),
      const SizedBox(
        height: 30,
      ),
    ],
  );
}
