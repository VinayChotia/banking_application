import 'package:banking_application/auth_services.dart';
import 'package:banking_application/login_page.dart';
import 'package:banking_application/balance.dart';
import 'package:banking_application/pdf_generation.dart';
import 'package:banking_application/transfer.dart';
import 'package:flutter/material.dart';

// import 'incidentmodel.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final token = AuthService.getToken();
  // ignore: unused_field
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        title: const Text('Profile'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.greenAccent,
              ),
              child: const CircleAvatar(
                child: Icon(
                  Icons.person,
                  size: 64,
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ListTile(
                // tileColor: Colors.lightGreen.withOpacity(0.3),
                leading: const Icon(Icons.home),
                title: const Text('Home'),
                onTap: () {},
              ),
            ),
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(10),
            //   child: ListTile(
            //     tileColor: Colors.lightGreen.withOpacity(0.3),
            //     leading: const Icon(Icons.warning),
            //     title: const Text('My Active Incidents'),
            //     onTap: () {
            //       // Navigate to My Active Incidents
            //     },
            //   ),
            // ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Logout'),
              onTap: () {
                // Perform Logout
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        ),
      ),
      //bottom navigation bar logic
      // bottomNavigationBar: BottomAppBar(
      //   color: Colors.greenAccent,
      //   shape: const CircularNotchedRectangle(),
      //   notchMargin: 8.0,
      //   child: Row(
      //     mainAxisSize: MainAxisSize.max,
      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
      //     children: <Widget>[
      //       IconButton(
      //         icon: const Icon(Icons.transfer_within_a_station),
      //         onPressed: () {
      //           Navigator.push(context,
      //               MaterialPageRoute(builder: (context) => TransferMoney()));
      //         },
      //       ),
      //       const SizedBox(width: 48.0),
      //       IconButton(
      //         icon: const Icon(Icons.exit_to_app),
      //         onPressed: () {
      //           showSignOutDialog(context);
      //         },
      //       ),
      //       const SizedBox(
      //         width: 48,
      //       ),
      //       IconButton(
      //           onPressed: () {
      //             Navigator.push(
      //                 context,
      //                 MaterialPageRoute(
      //                     builder: (context) => GeneratePdfPage()));
      //           },
      //           icon: Icon(Icons.download))
      //     ],
      //   ),
      // ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        focusColor: Colors.grey.shade200,
        hoverColor: Colors.lightGreen,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => HomeScreen(
                        token:
                            token.toString(),
                        accountId: "123456789098",
                      )));
        },
        tooltip: 'Add',
        elevation: 2.0,
        child: const Icon(Icons.show_chart),
      ),
    );
  }

  void showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Sign Out'),
              onPressed: () {
                // Perform sign out logic
                Navigator.of(context).pop(); // Close the dialog
                // Navigate to the sign in page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
//incident card logic shown in the profile page 