import 'package:flutter/material.dart';
import 'package:give_structure/src/providers/auth_provider.dart';
import 'package:give_structure/src/utils/shared_pref.dart';

class HomeController {
  BuildContext context;
  SharedPref _sharedPref;

  AuthProvider _authProvider;
  String _typeUser;
  String _isNotification;

  Future init(BuildContext context) async {
    this.context = context;
    _sharedPref = new SharedPref();
    _authProvider = new AuthProvider();
    _typeUser = await _sharedPref.read('typeUser');
    _isNotification = await _sharedPref.read('isNotification');
    //_authProvider.checkIfUserIsLogged(context, _typeUser);
    checkIfUserIsAuth();
  }
  
  void checkIfUserIsAuth(){
    bool isSigned = _authProvider.isSignedIn();
    if(_isNotification != 'true'){
      if (isSigned){
        if (_typeUser == 'client'){
          Navigator.pushNamedAndRemoveUntil(context, 'client/map', (route) => false);
          // Navigator.pushNamed(context, 'client/map');
        } else {
          Navigator.pushNamedAndRemoveUntil(context, 'driver/map', (route) => false);
          // Navigator.pushNamed(context, 'driver/map');
        }
      }
    }
  }

  void goToLoginPage(String typeUser){
    saveTypeUser(typeUser);
    Navigator.pushNamed(context, 'login');
  }

  void saveTypeUser(String typeUser) async {
    await _sharedPref.save('typeUser', typeUser);
  }


}