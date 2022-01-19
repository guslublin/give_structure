// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:give_structure/src/pages/login/login_controller.dart';
import 'package:give_structure/src/utils/colors.dart' as utils;
import 'package:give_structure/src/widgets/button_app.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  LoginController _con = new LoginController();

  @override
  void initState(){
    super.initState();
    print('Init State');
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      print('Método Schedule');
      _con.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Method Build');
    return Scaffold(
      key: _con.key,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _bannerApp(),
            _textDescription(),
            _textLogin(),
            SizedBox(height: MediaQuery.of(context).size.height *0.17,),
            _textFieldEmail(),
            _textFieldPassword(),
            _buttonLogin(),
            _textDontHaveAccount()
          ],
        ),
      ),
    );
  }

  Widget _textDontHaveAccount(){
    return GestureDetector(
      onTap: _con.goToRegisterPage,
      child: Container(
        margin: EdgeInsets.only(bottom: 60),
        child: Text(
          'No tienes cuenta?',
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey
          ),
        ),
      ),
    );
  }

  Widget _buttonLogin(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      child: ButtonApp(
          onPressed: _con.login,
          color: utils.Colors.giveStructureColor,
          text: 'Iniciar sesión',
          textColor: Colors.white,
          icon: Icons.arrow_forward_ios,
      ),
    );
  }

  Widget _textFieldEmail(){
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 30
      ),
      child: TextField(
        controller: _con.emailController,
        decoration: InputDecoration(
          labelText: 'Correo electrónico',
          hintText: 'correo@mail.com',
          suffixIcon: Icon(
              Icons.email_outlined,
              color: utils.Colors.giveStructureColor,
          ),
        ),
      ),
    );
  }

  Widget _textFieldPassword(){
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 20
      ),
      child: TextField(
        obscureText: true,
        controller: _con.passwordController,
        decoration: InputDecoration(
          labelText: 'Contraseña',
          suffixIcon: Icon(
              Icons.lock_open_outlined,
              color: utils.Colors.giveStructureColor,
          ),
        ),
      ),
    );
  }

  Widget _textDescription(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 10
      ),
      child: Text(
        'Continúa con tu',
        style: TextStyle(
          color: Colors.black54,
          fontSize: 24,
          fontFamily: 'NimbusSans'
        ),
      ),
    );
  }

  Widget _textLogin(){
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(
        horizontal: 30
      ),
      child: Text(
        'Login',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 28
        ),
      ),
    );
  }

  Widget _bannerApp(){
    return ClipPath(
      clipper: WaveClipperTwo(),
      child: Container(
        color: utils.Colors.giveStructureColor,
        height: MediaQuery.of(context).size.height * 0.22,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'assets/img/logo_app.png',
              width: 150,
              height: 100,
            ),
            Text('Fácil y Rápido',
              style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white
              ),)
          ],
        ),
      ),
    );
  }
}
