import 'package:flutter/material.dart';
import 'package:give_structure/src/models/client.dart';
import 'package:give_structure/src/models/driver.dart';
import 'package:give_structure/src/providers/auth_provider.dart';
import 'package:give_structure/src/providers/client_provider.dart';
import 'package:give_structure/src/providers/driver_provider.dart';
import 'package:give_structure/src/utils/shared_pref.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:give_structure/src/utils/my_progress_dialog.dart';
import 'package:give_structure/src/utils/snackbar.dart' as utils;

class LoginController {
  BuildContext context;
  GlobalKey<ScaffoldState> key = new GlobalKey<ScaffoldState>();

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  AuthProvider _authProvider;
  ProgressDialog _progressDialog;
  DriverProvider _driverProvider;
  ClientProvider _clientProvider;
  
  SharedPref _sharedPref;
  String _typeUser;

  Future init (BuildContext context) async {
    this.context = context;
    _authProvider = new AuthProvider();
    _driverProvider = new DriverProvider();
    _clientProvider = new ClientProvider();
    _progressDialog = MyProgressDialog.createProgressDialog(context, "Espere un momento..");
    _sharedPref = new SharedPref();
    _typeUser = await _sharedPref.read('typeUser');
    print("Tipo de usuario: $_typeUser");
  }

  void goToRegisterPage(){
    if (_typeUser == 'client'){
      Navigator.pushNamed(context, 'client/register');
    } else {
      Navigator.pushNamed(context, 'driver/register');
    }
  }

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    print('Email: $email');
    print('Password: $password');
    _progressDialog.show();
    try{
      bool isLogin = await _authProvider.login(email, password);
      _progressDialog.hide();
      if (isLogin){
        print('El usuario está logueado');
        if (_typeUser == 'client'){
          Client client = await _clientProvider.getById(_authProvider.getUser().uid);
          print('Client: $client');
          if (client != null){
            Navigator.pushNamedAndRemoveUntil(context, 'client/map', (Route<dynamic> route) => false);
            utils.Snackbar.showSnackbar(context, key, 'El usuario está logueado');
          } else {
            utils.Snackbar.showSnackbar(context, key, 'El usuario no es válido');
            await _authProvider.signOut();
          }
        } else if(_typeUser == 'driver'){
          Driver driver = await _driverProvider.getById(_authProvider.getUser().uid);
          print('Driver: $driver');
          utils.Snackbar.showSnackbar(context, key, 'El usuario está logueado');
          if (driver != null){
            Navigator.pushNamedAndRemoveUntil(context, 'driver/map', (Route<dynamic> route) => false);
          } else {
            utils.Snackbar.showSnackbar(context, key, 'El usuario no es válido');
            await _authProvider.signOut();
          }
        }
        //utils.Snackbar.showSnackbar(context, key, 'El usuario está logueado');
        //Navigator.pushNamedAndRemoveUntil(context, 'client/map', (Route<dynamic> route) => false);
/*        Navigator.pushNamed(
            context, 'client/map',
        );*/
      } else {
        print('El usuario no se pudo autenticar');
        utils.Snackbar.showSnackbar(context, key, 'El usuario no se pudo autenticar');
      }
    } catch(error){
      print('Error: $error');
      utils.Snackbar.showSnackbar(context, key, 'Error: $error');

      _progressDialog.hide();
    }
  }
}