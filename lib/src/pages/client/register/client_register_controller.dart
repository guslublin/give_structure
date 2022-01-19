import 'package:flutter/material.dart';
import 'package:give_structure/src/models/client.dart';
import 'package:give_structure/src/providers/auth_provider.dart';
import 'package:give_structure/src/providers/client_provider.dart';
import 'package:give_structure/src/utils/my_progress_dialog.dart';
import 'package:give_structure/src/utils/snackbar.dart' as utils;
import 'package:progress_dialog/progress_dialog.dart';

class ClientRegisterController {
  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  TextEditingController emailController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

  AuthProvider _authProvider;
  ClientProvider _clientProvider;
  ProgressDialog _progressDialog;

  Future init (BuildContext context){
    this.context = context;
    _authProvider = new AuthProvider();
    _clientProvider = new ClientProvider();
    _progressDialog = MyProgressDialog.createProgressDialog(context, 'Espere un momento..');
  }

  void register() async {
    String email = emailController.text.trim();
    String username = usernameController.text;
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    print('Email: $email');
    print('Password: $password');
    print('username: $username');
    print('confirmPassword: $confirmPassword');

    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty){
      print('Debe completar todos los datos');
      utils.Snackbar.showSnackbar(context, key, 'Debe completar todos los datos');
      return;
    }

    if (password != confirmPassword){
      print('Las contraseñas no coinciden');
      utils.Snackbar.showSnackbar(context, key, 'Las contraseñas no coinciden');
      return;
    }

    if (password.length < 6){
      print('El password debe tener al menos 6 caracteres');
      utils.Snackbar.showSnackbar(context, key, 'El password debe tener al menos 6 caracteres');
      return;
    }

    _progressDialog.show();

    try{
      bool isRegister = await _authProvider.register(email, password);
      if (isRegister){
        Client client = new Client(
          id: _authProvider.getUser().uid,
          email: _authProvider.getUser().email,
          username: username,
          password: password
        );
        await _clientProvider.create(client);
        Navigator.pushNamedAndRemoveUntil(context, 'client/map', (Route<dynamic> route) => false);
        utils.Snackbar.showSnackbar(context, key, 'El usuario se registró correctamente');
        _progressDialog.hide();
        print('El usuario se registró correctamente');
      } else {
        utils.Snackbar.showSnackbar(context, key, 'El usuario no se pudo registrar');
        _progressDialog.hide();
        print('El usuario no se pudo registrar');
      }
    } catch(error){
      _progressDialog.hide();
      print('Error: $error');
    }
  }
}