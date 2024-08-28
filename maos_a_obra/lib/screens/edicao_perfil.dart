import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:maos_a_obra/components/cor_constante.dart';
import 'package:maos_a_obra/components/link.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as p;
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:mime/mime.dart';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

class EdicaoPerfilPage extends StatefulWidget {
  const EdicaoPerfilPage({super.key});

  @override
  _EdicaoPerfilPageState createState() => _EdicaoPerfilPageState();
}

class _EdicaoPerfilPageState extends State<EdicaoPerfilPage> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _dataNascimentoController =
      TextEditingController();
  String _foto = "";

  final String apiUrl = '${Link.link}/user_access/user_personal_data';

  File? _selectedPhoto;
  bool _isLoading = true;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      var response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);

        setState(() {
          _nomeController.text = responseData['full_name'] ?? '';
          _emailController.text = responseData['email'] ?? '';
          _telefoneController.text = responseData['telefone'] ?? '';
          _cpfController.text = responseData['cpf'] ?? '';
          _enderecoController.text = responseData['address'] ?? '';
          _dataNascimentoController.text =
              responseData['data_nascimento'] ?? '';
          _foto = responseData['photo'] ?? '';
          _isEditing = true;
          _isLoading = false;
          print(_foto);
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog(
            'Falha ao carregar dados. Código de status: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Ocorreu um erro ao carregar os dados: $e');
    }
  }

  Future<void> salvarDadosUsuario() async {
    final String url = '${Link.link}/user_access/user_personal_data';

    if (_nomeController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _telefoneController.text.isEmpty ||
        _cpfController.text.isEmpty ||
        _enderecoController.text.isEmpty ||
        _dataNascimentoController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Erro'),
          content:
              const Text('Por favor, preencha todos os campos obrigatórios.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok'),
            ),
          ],
        ),
      );
      return;
    }

    try {
      var request = http.MultipartRequest(
        _isEditing ? 'PUT' : 'POST', // Usa PUT se estiver editando
        Uri.parse(url),
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';

      request.fields['full_name'] = _nomeController.text;
      request.fields['address'] = _enderecoController.text;
      request.fields['cpf'] = _cpfController.text;
      request.fields['email'] = _emailController.text;
      request.fields['telefone'] = _telefoneController.text;
      request.fields['data_nascimento'] = _dataNascimentoController.text;

      if (_selectedPhoto != null) {
        var mimeType = lookupMimeType(_selectedPhoto!.path);
        var mediaType = mimeType != null ? MediaType.parse(mimeType) : null;

        request.files.add(
          http.MultipartFile(
            'photo',
            _selectedPhoto!.openRead(),
            await _selectedPhoto!.length(),
            filename: p.basename(_selectedPhoto!.path),
            contentType: mediaType,
          ),
        );
      }

      var response = await request.send();

      if (response.statusCode == 200 || response.statusCode == 201) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Sucesso'),
            content: const Text('Cadastro realizado com sucesso!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Ok'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Erro'),
            content: const Text('Falha no cadastro. Tente novamente.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Ok'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Erro'),
          content: const Text('Ocorreu um erro inesperado.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _pickPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedPhoto = File(pickedFile.path);
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Aviso'),
          content: const Text('Nenhuma imagem foi selecionada.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Ok'),
            ),
          ],
        ),
      );
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erro'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
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
                          _isEditing ? 'Editar Conta' : 'Criar uma Conta',
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
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.025),
                          _buildTextField(
                            controller: _nomeController,
                            label: 'Nome',
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.025),
                          _buildTextField(
                            controller: _enderecoController,
                            label: 'Endereço',
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.025),
                          _buildTextField(
                            controller: _emailController,
                            label: 'Email',
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.025),
                          _buildTextField(
                            controller: _telefoneController,
                            label: 'Telefone',
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.025),
                          _buildTextField(
                            controller: _dataNascimentoController,
                            label: 'Data de nascimento',
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.025),
                          _buildTextField(
                            controller: _cpfController,
                            label: 'CPF',
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.025),
                          ElevatedButton(
                            onPressed: _pickPhoto,
                            child: const Text('Selecionar Foto'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: _selectedPhoto != null
                                ? Image.file(
                                    _selectedPhoto!,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  )
                                : _foto != ""
                                    ? Image.network(
                                        Link.link + _foto!.substring(21),
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      )
                                    : Center(),
                          ),
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.05),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 20),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: ElevatedButton(
                                onPressed: salvarDadosUsuario,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: CorConstante.azulClaro,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Center(
                                      child: Text(
                                        'Ok',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    List<TextInputFormatter>? inputFormatters,
    bool obscureText = false,
  }) {
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
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
          ),
        ),
      ),
    );
  }
}
