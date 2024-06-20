import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

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

  void _cadastrar() {
    if (_senhaController.text == _confirmarSenhaController.text) {
      print('Cadastro realizado com sucesso!');
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: const Text('As senhas não coincidem.'),
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
        backgroundColor: const Color(0xFF29AFF0),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Cadastro",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: MediaQuery.of(context).size.width * 0.1,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 0,
                            offset: const Offset(-5, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _nomeController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "Nome",
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0, horizontal: 12.0),
                        ),
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 0,
                            offset: const Offset(-5, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0, horizontal: 12.0),
                        ),
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 0,
                            offset: const Offset(-5, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _telefoneController,
                        inputFormatters: [_telefoneFormatter],
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "Telefone",
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0, horizontal: 12.0),
                        ),
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 0,
                            offset: const Offset(-5, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _dataNascimentoController,
                        inputFormatters: [_dataNascimentoFormatter],
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "Data de nascimento",
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0, horizontal: 12.0),
                        ),
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 0,
                            offset: const Offset(-5, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _cpfController,
                        inputFormatters: [_cpfFormatter],
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "CPF",
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0, horizontal: 12.0),
                        ),
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 0,
                            offset: const Offset(-5, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _cepController,
                        inputFormatters: [_cepFormatter],
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "CEP",
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0, horizontal: 12.0),
                        ),
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 0,
                            offset: const Offset(-5, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _senhaController,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "Senha",
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0, horizontal: 12.0),
                        ),
                      ),
                    ),
                    SizedBox(
                        height: MediaQuery.of(context).size.height * 0.025),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 0,
                            offset: const Offset(-5, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _confirmarSenhaController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "Confirmar senha",
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0, horizontal: 12.0),
                        ),
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 20),
                      child: Container(
                        height: MediaQuery.of(context).size.width * 0.15,
                        width: MediaQuery.of(context).size.width * 0.5,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              offset: const Offset(-5, 5),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            _cadastrar();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shadowColor: Colors.black.withOpacity(0.5),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
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
                                    color: const Color(0xFF29AFF0),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
