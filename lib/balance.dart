// import 'dart:io';
// import 'package:banking_application/account.dart';
// import 'package:banking_application/account_services.dart';
// import 'package:banking_application/auth_services.dart';
// import 'package:banking_application/constants.dart';
// import 'package:banking_application/deposit.dart';
// import 'package:banking_application/kyc_toggle.dart';
// import 'package:banking_application/login_page.dart';
// import 'package:banking_application/transfer.dart';
// import 'package:banking_application/withdraw_money.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:open_file/open_file.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:convert';

// class HomeScreen extends StatefulWidget {
//   final String token;
//   final String accountId;

//   HomeScreen({required this.token, required this.accountId});

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   late Future<List<dynamic>> transactions;
//   Future<Map<String, dynamic>>? balance;
//   String? accountNumber;
//   bool _isLoadingAccountNumber = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadAccountNumber();
//   }

//   Future<void> _loadAccountNumber() async {
//     accountNumber = await AccountService().fetchAccountNumber();
//     setState(() {
//       _isLoadingAccountNumber = false;
//     });
//     if (accountNumber != null) {
//       _refreshData();
//     } else {
//       print('No account number found or failed to fetch.');
//     }
//   }

//   Future<void> _refreshData() async {
//     if (accountNumber != null) {
//       setState(() {
//         transactions = fetchTransactions();
//         balance = fetchBalance();
//       });
//     }
//   }

//   Future<List<dynamic>> fetchTransactions() async {
//     final token = await AuthService.getToken();
//     final response = await http.get(
//       Uri.parse('$base_url/api/transactions/$accountNumber/'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//         'Authorization': 'Bearer $token',
//       },
//     );

//     if (response.statusCode == 200) {
//       try {
//         final List<dynamic> data = jsonDecode(response.body);
//         return data;
//       } catch (e) {
//         throw Exception('Failed to parse JSON: $e');
//       }
//     } else {
//       throw Exception(response.statusCode);
//     }
//   }

//   Future<Map<String, dynamic>> fetchBalance() async {
//     final token = await AuthService.getToken();
//     final response = await http.get(
//       Uri.parse('$base_url/api/balance/$accountNumber/'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//         'Authorization': 'Bearer $token',
//       },
//     );

//     if (response.statusCode == 200) {
//       try {
//         final Map<String, dynamic> data = jsonDecode(response.body);
//         return data;
//       } catch (e) {
//         throw Exception('Failed to parse JSON: $e');
//       }
//     } else {
//       throw Exception('Failed to load balance');
//     }
//   }

//   Future<void> generateAndDownloadPdf(BuildContext context) async {
//     final token = await AuthService.getToken();
//     final response = await http.get(
//       Uri.parse('$base_url/api/generate/'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//         'Authorization': 'Bearer $token',
//       },
//     );

//     if (response.statusCode == 200) {
//       final directory = await getApplicationDocumentsDirectory();
//       final filePath = '${directory.path}/generated.pdf';
//       final file = File(filePath);
//       await file.writeAsBytes(response.bodyBytes);

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('PDF downloaded to $filePath')),
//       );

//       OpenFile.open(filePath);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to generate PDF: ${response.body}')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Banking Application'),
//         backgroundColor: Colors.greenAccent,
//         automaticallyImplyLeading: false,
//       ),
//       body: Center(
//         child: _isLoadingAccountNumber
//             ? const CircularProgressIndicator()
//             : RefreshIndicator(
//                 onRefresh: _refreshData,
//                 child: FutureBuilder<Map<String, dynamic>>(
//                   future: balance,
//                   builder: (context, balanceSnapshot) {
//                     if (balanceSnapshot.connectionState ==
//                         ConnectionState.waiting) {
//                       return const CircularProgressIndicator();
//                     } else if (balanceSnapshot.hasError) {
//                       return Text('Error: ${balanceSnapshot.error}');
//                     } else if (balanceSnapshot.hasData) {
//                       final balanceData = balanceSnapshot.data!;
//                       return FutureBuilder<List<dynamic>>(
//                         future: transactions,
//                         builder: (context, transactionsSnapshot) {
//                           if (transactionsSnapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return const CircularProgressIndicator();
//                           } else if (transactionsSnapshot.hasError) {
//                             return Text('Error: ${transactionsSnapshot.error}');
//                           } else if (transactionsSnapshot.hasData) {
//                             final transactionsData = transactionsSnapshot.data!;
//                             return Padding(
//                               padding: const EdgeInsets.all(16.0),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   Card(
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(16.0),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           const Text(
//                                             'Account Balance',
//                                             style: TextStyle(
//                                                 fontSize: 20,
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                           const SizedBox(height: 10),
//                                           Text(
//                                             '\$ ${balanceData['balance']}',
//                                             style:
//                                                 const TextStyle(fontSize: 24),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 20),
//                                   Row(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceBetween,
//                                     children: [
//                                       const Text(
//                                         'Recent Transactions',
//                                         style: TextStyle(
//                                             fontSize: 18,
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       IconButton(
//                                           onPressed: () {
//                                             generateAndDownloadPdf(context);
//                                           },
//                                           icon: const Icon(Icons.download)),
//                                     ],
//                                   ),
//                                   Expanded(
//                                     child: ListView.builder(
//                                       itemCount: transactionsData.length < 5
//                                           ? transactionsData.length
//                                           : 5,
//                                       itemBuilder: (context, index) {
//                                         final transaction =
//                                             transactionsData[index];
//                                         return ListTile(
//                                           title: Text(
//                                               'Transaction Type: ${transaction['transaction_type']}'),
//                                           subtitle: Text(
//                                               'Date: ${transaction['timestamp']}'),
//                                           trailing: Text(
//                                               '\$ ${transaction['amount']}'),
//                                         );
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           } else {
//                             return const Text('No data available');
//                           }
//                         },
//                       );
//                     } else {
//                       return const Text('No data available');
//                     }
//                   },
//                 ),
//               ),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         color: Colors.greenAccent,
//         shape: const CircularNotchedRectangle(),
//         notchMargin: 8.0,
//         child: Row(
//           mainAxisSize: MainAxisSize.max,
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: <Widget>[
//             IconButton(
//               icon: const Icon(Icons.money_rounded),
//               onPressed: () {
//                 if (accountNumber != null) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => DepositMoney(
//                         accountId: accountNumber!,
//                       ),
//                     ),
//                   );
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Account number not loaded yet.'),
//                     ),
//                   );
//                 }
//               },
//             ),
//             const SizedBox(width: 25.0),
//             IconButton(
//               onPressed: () {
//                 if (accountNumber != null) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => WithdrawMoney(
//                         accountId: accountNumber!,
//                       ),
//                     ),
//                   );
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Account number not loaded yet.'),
//                     ),
//                   );
//                 }
//               },
//               icon: const Icon(Icons.attach_money),
//             ),
//             const SizedBox(width: 25.0),
//             IconButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => TransferMoney(),
//                   ),
//                 );
//               },
//               icon: const Icon(Icons.person),
//             ),
//             const SizedBox(
//               width: 25,
//             ),
//             IconButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => const KycTogglePage(),
//                   ),
//                 );
//               },
//               icon: const Icon(Icons.verified_user),
//             ),
//             const SizedBox(width: 25),
//             IconButton(
//               onPressed: () {
//                 showSignOutDialog(context);
//               },
//               icon: const Icon(Icons.logout),
//             ),
//             const SizedBox(width: 25),

//             if (accountNumber == null)

//               IconButton(
//                 icon: const Icon(Icons.add),
//                 onPressed: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => CreateAccount(),
//                     ),
//                   );
//                 },
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// void showSignOutDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text('Confirm Sign Out'),
//         content: const Text('Are you sure you want to sign out?'),
//         actions: <Widget>[
//           TextButton(
//             child: const Text('Cancel'),
//             onPressed: () {
//               Navigator.of(context).pop(); // Close the dialog
//             },
//           ),
//           TextButton(
//             child: const Text('Sign Out'),
//             onPressed: () {
//               AuthService.logout();
//               Navigator.of(context).pushAndRemoveUntil(
//                 MaterialPageRoute(
//                   builder: (context) => LoginPage(),
//                 ),
//                 (Route<dynamic> route) => false,
//               );
//             },
//           ),
//         ],
//       );
//     },
//   );
// }

import 'dart:io';
import 'package:banking_application/account.dart';
import 'package:banking_application/account_services.dart';
import 'package:banking_application/auth_services.dart';
import 'package:banking_application/constants.dart';
import 'package:banking_application/deposit.dart';
import 'package:banking_application/kyc_toggle.dart';
import 'package:banking_application/login_page.dart';
import 'package:banking_application/transfer.dart';
import 'package:banking_application/withdraw_money.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  final String token;
  final String accountId;

  HomeScreen({required this.token, required this.accountId});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<dynamic>> transactions;
  Future<Map<String, dynamic>>? balance;
  String? accountNumber;
  bool _isLoadingAccountNumber = true;

  @override
  void initState() {
    super.initState();
    _loadAccountNumber();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (accountNumber != null) {
      _refreshData(); // Refresh the data whenever the HomeScreen is revisited
    }
  }

  Future<void> _loadAccountNumber() async {
    accountNumber = await AccountService().fetchAccountNumber();
    setState(() {
      _isLoadingAccountNumber = false;
    });
    if (accountNumber != null) {
      _refreshData();
    } else {
      print('No account number found or failed to fetch.');
    }
  }

  Future<void> _refreshData() async {
    if (accountNumber != null) {
      setState(() {
        transactions = fetchTransactions();
        balance = fetchBalance();
      });
    }
  }

  Future<List<dynamic>> fetchTransactions() async {
    final token = await AuthService.getToken();
    final response = await http.get(
      Uri.parse('$base_url/api/transactions/$accountNumber/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      try {
        final List<dynamic> data = jsonDecode(response.body);
        return data;
      } catch (e) {
        throw Exception('Failed to parse JSON: $e');
      }
    } else {
      throw Exception(response.statusCode);
    }
  }

  Future<Map<String, dynamic>> fetchBalance() async {
    final token = await AuthService.getToken();
    final response = await http.get(
      Uri.parse('$base_url/api/balance/$accountNumber/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return data;
      } catch (e) {
        throw Exception('Failed to parse JSON: $e');
      }
    } else {
      throw Exception('Failed to load balance');
    }
  }

  Future<void> generateAndDownloadPdf(BuildContext context) async {
    final token = await AuthService.getToken();
    final response = await http.get(
      Uri.parse('$base_url/api/generate/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
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
    return WillPopScope(
      onWillPop: () async {
        await _refreshData(); // Refresh data when the back button is pressed
        return true; // Allow the back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Banking Application'),
          backgroundColor: Colors.greenAccent,
          automaticallyImplyLeading: true,
        ),
        body: Center(
          child: _isLoadingAccountNumber
              ? const CircularProgressIndicator()
              : RefreshIndicator(
                  onRefresh: _refreshData,
                  child: FutureBuilder<Map<String, dynamic>>(
                    future: balance,
                    builder: (context, balanceSnapshot) {
                      if (balanceSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (balanceSnapshot.hasError) {
                        return Text('Error: ${balanceSnapshot.error}');
                      } else if (balanceSnapshot.hasData) {
                        final balanceData = balanceSnapshot.data!;
                        
                        return FutureBuilder<List<dynamic>>(
                          future: transactions,
                          builder: (context, transactionsSnapshot) {
                            if (transactionsSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else if (transactionsSnapshot.hasError) {
                              return Text(
                                  'Error: ${transactionsSnapshot.error}');
                            } else if (transactionsSnapshot.hasData) {
                              final transactionsData =
                                  transactionsSnapshot.data!;
                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Card(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Account Balance',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              '\$ ${balanceData['balance']}',
                                              style:
                                                  const TextStyle(fontSize: 24),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Recent Transactions of ${balanceData['account_number']}',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              generateAndDownloadPdf(context);
                                            },
                                            icon: const Icon(Icons.download)),
                                      ],
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: transactionsData.length < 5
                                            ? transactionsData.length
                                            : 5,
                                        itemBuilder: (context, index) {
                                          final transaction =
                                              transactionsData[index];
                                          return ListTile(
                                            title: Text(
                                                'Transaction Type: ${transaction['transaction_type']}'),
                                            subtitle: Text(
                                                'Date: ${transaction['timestamp']}'),
                                            trailing: Text(
                                                '\$ ${transaction['amount']}'),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return const Text('No data available');
                            }
                          },
                        );
                      } else {
                        return const Text('No data available');
                      }
                    },
                  ),
                ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.greenAccent,
          shape: const CircularNotchedRectangle(),
          notchMargin: 8.0,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.money_rounded),
                onPressed: () {
                  if (accountNumber != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DepositMoney(
                          accountId: accountNumber!,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Account number not loaded yet.'),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(width: 25.0),
              IconButton(
                onPressed: () {
                  if (accountNumber != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WithdrawMoney(
                          accountId: accountNumber!,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Account number not loaded yet.'),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.attach_money),
              ),
              const SizedBox(width: 25.0),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TransferMoney(),
                    ),
                  );
                },
                icon: const Icon(Icons.person),
              ),
              const SizedBox(width: 25),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KycTogglePage(),
                    ),
                  );
                },
                icon: const Icon(Icons.verified_user),
              ),
              const SizedBox(
                width: 25,
              ),
              IconButton(
                onPressed: () {
                  _showLogoutDialog();
                },
                icon: const Icon(Icons.logout),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _isLoadingAccountNumber
            ? null
            : accountNumber == null
                ? FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateAccount(),
                        ),
                      );
                    },
                    child: const Icon(Icons.add),
                    backgroundColor: Colors.greenAccent,
                  )
                : null,
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Logout"),
              onPressed: () {
                AuthService.logout().then((value) {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => LoginPage(),
                    ),
                    (route) => false,
                  );
                });
              },
            ),
          ],
        );
      },
    );
  }
}
