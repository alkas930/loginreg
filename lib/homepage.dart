import 'package:flutter/material.dart';
import 'package:login_reg/database_provider.dart';
import 'package:login_reg/user_model.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  UserModel user = UserModel();

  DatabaseProvider db = DatabaseProvider();

  Future<void> getuser() async {
    final retrievedUser = await db.retrieveUserFromTable();

    setState(() {
      user = retrievedUser;
    });
  }

  @override
  void initState() {
    super.initState();
    getuser();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text(
              "${user.email}",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text("${user.name}", style: TextStyle(fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.only(top: 20, right: 35),
              child: Container(
                  height: 45,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: "Search Here",
                      suffixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  )),
            ),
          ]),
        ),
      ),
    );
  }
}
