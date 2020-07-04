import 'package:flutter/material.dart';
import 'package:shopapp/widgets/login_page/signIn.dart';
import 'package:shopapp/widgets/login_page/signUp.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/loginPage';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool pageLogin = true;

  void changePage() {
    setState(() {
      pageLogin = !pageLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            height: deviceSize.height,
            width: deviceSize.width,
            padding:
                EdgeInsets.all(deviceSize.height * deviceSize.width / 7000),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.blue, Colors.purple],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  fit: FlexFit.tight,
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    transform: Matrix4.rotationZ(-30 / 360),
                  ),
                ),
                Flexible(
                  flex: 2,
                  fit: FlexFit.loose,
                  child: Card(
                    elevation: 15,
                    child: pageLogin == true
                        ? SignIn(
                            deviceSize: deviceSize,
                            changePage: changePage,
                          )
                        : SignUp(
                            deviceSize: deviceSize,
                            changePage: changePage,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
