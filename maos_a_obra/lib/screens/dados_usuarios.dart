import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:maos_a_obra/components/link.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DadosUsuarios extends StatefulWidget {
  const DadosUsuarios({Key? key}) : super(key: key);

  @override
  _DadosUsuariosState createState() => _DadosUsuariosState();
}

class _DadosUsuariosState extends State<DadosUsuarios> {
  Map<String, dynamic>? _userData; // Adjusted to hold a map instead of a list
  bool _isLoading = true;
  String apiUrl = '${Link.link}/user_access/user_personal_data';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      // Get the token from shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      // Make the GET request
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          _userData =
              json.decode(response.body); // Assuming the response is a map
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        _showErrorDialog(
            'Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('An error occurred: $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Data'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _userData == null
              ? const Center(child: Text('No data available.'))
              : _buildUserDataCard(),
    );
  }

  Widget _buildUserDataCard() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${_userData!['full_name'] ?? 'No Name'}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Email: ${_userData!['email'] ?? 'No Email'}'),
            const SizedBox(height: 8),
            Text('Telefone: ${_userData!['telefone'] ?? 'No Telefone'}'),
            const SizedBox(height: 8),
            Text('CPF: ${_userData!['cpf'] ?? 'No CPF'}'),
            const SizedBox(height: 8),
            Text('Endereço: ${_userData!['address'] ?? 'No Address'}'),
            const SizedBox(height: 8),
            Text(
                'Data de Nascimento: ${_userData!['data_nascimento'] ?? 'No Data Nascimento'}'),
            const SizedBox(height: 16),
            _buildUserImage(),
          ],
        ),
      ),
    );
  }

  Widget _buildUserImage() {
    String imageUrl = '${Link.link}/${_userData!['photo']}';

    return Image.network(
      "http://10.0.2.2:8000/uploads/profile_pics//Captura de tela 2024-08-07 171946.png",
      width: 100,
      height: 100,
      fit: BoxFit.cover,
    );
  }
}
