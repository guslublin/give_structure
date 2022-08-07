import 'package:flutter/material.dart';
import 'package:give_structure/src/models/driver.dart';
import 'package:give_structure/src/providers/auth_provider.dart';
import 'package:give_structure/src/providers/driver_provider.dart';
import 'package:give_structure/src/utils/my_progress_dialog.dart';
import 'package:give_structure/src/utils/snackbar.dart' as utils;
import 'package:progress_dialog/progress_dialog.dart';

class DriverRegisterController {
  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  TextEditingController emailController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

  TextEditingController pin1Controller = new TextEditingController();
  TextEditingController pin2Controller = new TextEditingController();
  TextEditingController pin3Controller = new TextEditingController();
  TextEditingController pin4Controller = new TextEditingController();
  TextEditingController pin5Controller = new TextEditingController();
  TextEditingController pin6Controller = new TextEditingController();

  AuthProvider _authProvider;
  DriverProvider _driverProvider;
  ProgressDialog _progressDialog;

  Future init (BuildContext context){
    this.context = context;
    _authProvider = new AuthProvider();
    _driverProvider = new DriverProvider();
    _progressDialog = MyProgressDialog.createProgressDialog(context, 'Espere un momento..');
  }

  void register() async {
    String email = emailController.text.trim();
    String username = usernameController.text;
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    String pin1 = pin1Controller.text.trim();
    String pin2 = pin2Controller.text.trim();
    String pin3 = pin3Controller.text.trim();
    String pin4 = pin4Controller.text.trim();
    String pin5 = pin5Controller.text.trim();
    String pin6 = pin6Controller.text.trim();

    String plate = '$pin1$pin2$pin3-$pin4$pin5$pin6';

    print('Email: $email');
    print('Password: $password');
    print('username: $username');
    print('confirmPassword: $confirmPassword');
    print('plate: $plate');

    if (username.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty || plate.isEmpty){
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
        Driver driver = new Driver(
          id: _authProvider.getUser().uid,
          email: _authProvider.getUser().email,
          username: username,
          password: password,
          plate: plate
        );
        await _driverProvider.create(driver);
        _progressDialog.hide();
        Navigator.pushNamedAndRemoveUntil(context, 'driver/map', (Route<dynamic> route) => false);
        utils.Snackbar.showSnackbar(context, key, 'El usuario se registró correctamente');
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