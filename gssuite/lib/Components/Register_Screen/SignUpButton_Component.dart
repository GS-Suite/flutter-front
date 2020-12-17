import 'package:flutter/material.dart';

class SignInButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          Container(
            height: 40,
            child: Material(
              borderRadius: BorderRadius.circular(10),
              color: Colors.teal[400],
              elevation: 7.0,
              child: GestureDetector(
                onTap: () {},
                child: Center(
                  child: Text(
                    'REGISTER',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat'),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            height: 40.0,
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.black,
                      style: BorderStyle.solid,
                      width: 1.0),
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10.0)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: ImageIcon(AssetImage('assets/google.png')),
                  ),
                  SizedBox(width: 10.0),
                  Center(
                    child: Text('Register with Google',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat')),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Have an account ?',
                style: TextStyle(fontFamily: 'Montserrat'),
              ),
              SizedBox(width: 5.0),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed('/login');
                },
                child: Text(
                  'Log In',
                  style: TextStyle(
                      color: Colors.teal[400],
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
