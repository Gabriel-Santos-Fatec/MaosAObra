import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maos_a_obra/components/cor_constante.dart';
import 'package:maos_a_obra/components/link.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CadastroPage extends StatefulWidget {
  final int tipo;
  const CadastroPage({required this.tipo, super.key});

  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _dataNascimentoController =
      TextEditingController();
  final MaskTextInputFormatter _telefoneFormatter =
      MaskTextInputFormatter(mask: '(##) #####-####');
  final MaskTextInputFormatter _dataNascimentoFormatter =
      MaskTextInputFormatter(mask: '##/##/####');
  final MaskTextInputFormatter _cpfFormatter =
      MaskTextInputFormatter(mask: '###.###.###-##');
  final MaskTextInputFormatter _cepFormatter =
      MaskTextInputFormatter(mask: '#####-###');
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController =
      TextEditingController();
  final String apiUrl = '${Link.link}/user/registro';

  Future<void> checkServerStatus() async {
    // Change the URL according to your setup
    const String url = '${Link.link}';

    try {
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print('Server response: ${response.body}');
      } else {
        print('Failed to get response: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _cadastrar() async {
    if (_senhaController.text == _confirmarSenhaController.text) {
      try {
        var url = Uri.parse('${Link.link}/user/register');
        var response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'id': 0,
            'username': _emailController.text,
            'password': _senhaController.text,
            'role': widget.tipo == 1
                ? "client"
                : widget.tipo == 2
                    ? "service_provider"
                    : "",
            'is_super_admin': false,
            'is_active': true
          }),
        );

        if (response.statusCode == 201) {
          print('Cadastro realizado com sucesso!');
          Navigator.pop(context);
          Navigator.pop(context);
        } else {
          print('Erro no cadastro: ${response.body}');
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Text('Erro no cadastro: ${response.body}'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Text('Erro: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content:
              Text('As senhas não coincidem. ${_emailController.text.length}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.15,
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
                    'Criar uma conta',
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
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.12),
                    _buildTextField(
                        controller: _emailController, label: 'Email'),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025),
                    _buildTextField(
                        controller: _senhaController,
                        label: 'Senha',
                        obscureText: true),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025),
                    _buildTextField(
                        controller: _confirmarSenhaController,
                        label: 'Confirmar senha',
                        obscureText: true),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: ElevatedButton(
                          onPressed: () {
                            _cadastrar();
                            // print(_emailController.text);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CorConstante.laranja,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Center(
                                child: Text(
                                  'Cadastrar',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller,
      required String label,
      List<TextInputFormatter>? inputFormatters,
      bool obscureText = false}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.075,
      child: Material(
        elevation: 5.0,
        borderRadius: BorderRadius.circular(30.0),
        child: TextField(
          controller: controller,
          inputFormatters: inputFormatters,
          obscureText: obscureText,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.grey),
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          ),
        ),
      ),
    );
  }
}
