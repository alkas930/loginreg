import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:login_reg/homepage.dart';

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
            Uri.parse("http://192.168.5.184:5000/api/auth/login"),
            body: body);

        setState(() {
          isloading = false;
        });
        print("Response Status Code: ${response.body}");
        if (response.statusCode == 201) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => homepage()));
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
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 40, 172, 7),
        title: const Text(
          'login Page',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 40),
        child: Form(
          key: Formkey,
          child: Column(
            children: [
              Image.asset(
                "assets/216.jpg",
                scale: 7,
                filterQuality: FilterQuality.high,
              ),
              Row(
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
              SizedBox(
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
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.greenAccent)),
                  onPressed: () {
                    if (Formkey.currentState!.validate())
                      loginn(emailController.text, passwordController.text);
                  },
                  child: isloading
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                          ),
                        )
                      : Text('login')),
            ],
          ),
        ),
      ),
    );
  }
}
