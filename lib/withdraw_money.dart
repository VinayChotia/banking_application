import 'package:animate_do/animate_do.dart';
import 'package:banking_application/auth_services.dart';
import 'package:banking_application/balance.dart';
import 'package:banking_application/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WithdrawMoney extends StatelessWidget {
  final String accountId;

  WithdrawMoney({required this.accountId});

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final token = AuthService.getToken();

  Future<void> deposit(BuildContext context) async {
    //login user method

    final String amount = _amountController.text.trim();
    final token = await AuthService.getToken();
    String? tok = await token;

    final response = await http.post(
      Uri.parse('${base_url}/api/withdraw/${accountId}/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer $tok"
      },
      body: jsonEncode(<String, String>{'amount': amount}),
    );

    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
              token: token!, accountId: ""), // accountId will be set later
        ),
      );
      print("success");
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Withdraw failed'),
            content: Text((response.body).toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
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
        child: Expanded(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode
                .onUserInteraction, //auto validate to ensure the fields are met on user interaction.
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          FadeInUp(
                              duration: const Duration(milliseconds: 1000),
                              child: const Text(
                                "Withdraw",
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
                                    label: "amount",
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
                                  deposit(context);
                                  print('success');
                                },
                                color: Colors.greenAccent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                                child: const Text(
                                  "Withdraw",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
                // FadeInUp(
                //     duration: const Duration(milliseconds: 1200),
                //     child: Container(
                //       height: MediaQuery.of(context).size.height / 3,
                //       decoration: const BoxDecoration(
                //           image: DecorationImage(
                //               image: AssetImage('assets/background.png'),
                //               fit: BoxFit.cover)),
                //     ))
              ],
            ),
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
