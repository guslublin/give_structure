import 'package:flutter/material.dart';
import 'package:give_structure/src/utils/colors.dart' as utils;

class ButtonApp extends StatelessWidget {
  Color color;
  String text;
  Color textColor;
  IconData icon;
  Function onPressed;

  ButtonApp({
    this.color = Colors.red,
    @required this.text,
    this.textColor = Colors.amber,
    this.icon = Icons.add,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: (){
          onPressed();
        },
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 50,
                alignment: Alignment.center,
                child: Text(
                  text,
                  style: TextStyle(
                      fontSize: 16,
                      color: textColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: 50,
                child: CircleAvatar(
                  child: Icon(icon, color: utils.Colors.giveStructureColor ,),
                  backgroundColor: Colors.white,
                  radius: 15,
                ),
              ),
            )
          ],
        ),
        style: ElevatedButton.styleFrom(
          primary: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15)
          )
        ),
    );
  }
}
