import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:maos_a_obra/components/cor_constante.dart';
import 'package:http/http.dart' as http;
import 'package:maos_a_obra/components/link.dart';
import 'package:maos_a_obra/screens/cadastro.dart';
import 'package:maos_a_obra/screens/orcamento.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool isVisible = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  Future<void> loginUser(String username, String password) async {
    // Change the URL according to your setup
    final String url = '${Link.link}/user/login';

    try {
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        // Parse the response body as JSON
        var responseData = json.decode(response.body);
        var accessToken = responseData['access_token'];
        print('Login successful: $accessToken');
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Orcamento()),
        );

        // You can now use the accessToken for further requests
      } else {
        print('Login failed: ${response.statusCode}, ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.175,
                decoration: const BoxDecoration(
                  color: CorConstante.laranja,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(70),
                    bottomRight: Radius.circular(70),
                  ),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                        0, MediaQuery.of(context).size.height * 0.03, 0, 0),
                    child: Text(
                      'Bem vindo\nde volta!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: MediaQuery.of(context).size.width * 0.075,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Material(
                          elevation: 5.0,
                          borderRadius: BorderRadius.circular(30.0),
                          child: TextFormField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'E-mail',
                              labelStyle: TextStyle(color: Colors.grey),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(30.0),
                        child: TextFormField(
                          controller: _senhaController,
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            labelStyle: const TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  isVisible = !isVisible;
                                });
                              },
                            ),
                          ),
                          obscureText: !isVisible,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Text(
                          textAlign: TextAlign.right,
                          "Esqueci minha senha",
                          style: TextStyle(
                              color: CorConstante.laranja,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.03,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await loginUser(
                              _emailController.text, _senhaController.text);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CorConstante.laranja,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Entrar',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025,
                      ),
                      GestureDetector(
                        onTap: () {
                          // Handle Google login
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.75,
                          height: MediaQuery.of(context).size.height * 0.075,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 3.0,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 20.0),
                                child: Text(
                                  'Entrar com conta Google',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: Material(
                                  elevation: 5.0,
                                  shape: const CircleBorder(),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: Image.asset(
                                      'assets/images/google.png',
                                      width: 24,
                                      height: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025,
                      ),
                      GestureDetector(
                        onTap: () {
                          // Handle Microsoft login
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.75,
                          height: MediaQuery.of(context).size.height * 0.075,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15.0),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 3.0,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 20.0),
                                child: Text(
                                  'Entrar com conta Microsoft',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: Material(
                                  elevation: 5.0,
                                  shape: const CircleBorder(),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: Image.asset(
                                      'assets/images/microsoft.png',
                                      width: 24,
                                      height: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CadastroPage()),
                          );
                        },
                        child: Text(
                          "Não possui uma conta? Cadastre-se",
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationColor: CorConstante.laranja,
                              decorationStyle: TextDecorationStyle.solid,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.04,
                              color: CorConstante.laranja,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
