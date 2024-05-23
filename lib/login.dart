import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:login_reg/database_provider.dart';
import 'package:login_reg/homepage.dart';
import 'package:login_reg/user_model.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  bool isloading = false;
  final Formkey = GlobalKey<FormState>();

  DatabaseProvider db = DatabaseProvider();

  loginn(String email, String password) async {
    try {
      setState(() {
        isloading = true;
      });
      if (emailController.text == null && passwordController.text == null) {
        print("all fields are required");
      } else {
        final body = {"email": email, "password": password};
        print(body);
        final response = await http.post(
            Uri.parse("http://192.168.1.135:5000/api/auth/login_demo"),
            body: body);

        setState(() {
          isloading = false;
        });

        final Map<String, dynamic> data =
            jsonDecode(response.body); //// decode data

        final userData = data['user'];

        print("----------------------$userData");

        // to store data in user model
        UserModel user = UserModel(
            id: userData['id'],
            name: userData['name'],
            email: userData['email']);

        await db.insertUser(user);

        print(user.name);

        print(user.email);

        print("Response Status Code: ${response.body}");
        if (response.statusCode == 200) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => homepage()));
        } else {
          print("Failed with status code: ${response.statusCode}");
        }
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 40, 172, 7),
        title: const Text(
          'login Page',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: Formkey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.asset(
                  "assets/216.jpg",
                  scale: 11,
                  filterQuality: FilterQuality.high,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Login",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Enter a valid email address';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters long';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.greenAccent)),
                    onPressed: () {
                      if (Formkey.currentState!.validate())
                        loginn(emailController.text, passwordController.text);
                    },
                    child: isloading
                        ? const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(
                              color: Colors.blue,
                            ),
                          )
                        : const Text('login')),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
