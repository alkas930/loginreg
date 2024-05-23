import 'dart:convert';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:login_reg/homepage.dart';
import 'package:login_reg/login.dart';
import 'package:login_reg/provider.dart';
import 'package:provider/provider.dart';

class registration extends StatefulWidget {
  const registration({super.key});

  @override
  State<registration> createState() => _registrationState();
}

class _registrationState extends State<registration> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  // TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final Formkey = GlobalKey<FormState>();
  register(String name, String email, String password,
      LoginProvider loginprovider) async {
    try {
      loginprovider.setloader();
      if (nameController.text == null &&
          emailController.text == null &&
          passwordController.text == null) {
        print("all fields are required");
      } else {
        final body = {"name": name, "email": email, "password": password};
        print(body);
        final response = await http.post(
            Uri.parse("http://192.168.1.135:5000/api/auth/register"),
            body: body);

        loginprovider.hideloader();
        print("Response Status Code: ${response.body}");
        if (response.statusCode == 201) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const homepage()));
          print("Response Body: ${response.body}");
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
          'Registration Page',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Consumer<LoginProvider>(builder: (__, loginprovider, _) {
        return Padding(
          padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 20, vertical: 10),
          child: Form(
            key: Formkey,
            child: Column(
              children: [
                Image.asset(
                  "assets/216.jpg",
                  scale: 10,
                  filterQuality: FilterQuality.high,
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Create New Account",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Name is required';
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
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
                // const SizedBox(height: 20),
                ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.greenAccent)),
                    onPressed: () {
                      if (Formkey.currentState!.validate()) {
                        // if(loginprovider.isloading == true ){

                        // }

                        register(nameController.text, emailController.text,
                            passwordController.text, loginprovider);
                      }
                    },
                    child: loginprovider.isloading
                        ? CircularProgressIndicator()
                        : const Text('Register')),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an Account"),
                    const SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const login()));
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
