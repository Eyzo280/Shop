import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/auth.dart';

class Login {
  String email;
  String password;

  Login({
    @required this.email,
    @required this.password,
  });
}

class SignIn extends StatefulWidget {
  final deviceSize;
  final Function changePage;

  SignIn({this.deviceSize, this.changePage});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _passwordScope = FocusNode();

  final _form = GlobalKey<FormState>();

  var _data = Login(
    email: '',
    password: '',
  );

  bool _loading = false;

  void _saveForm() async {
    if (!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();
    _form.currentState.validate();
    print('Login');
    print(_data.email);
    print(_data.password);
    setState(() {
      _loading = true;
    });

    try {
      await Provider.of<Auth>(context, listen: false)
          .signInWithEmailAndPassword(
              email: _data.email, password: _data.password);
      // Zalogowano
      print('Zalogowano');
    } catch (err) {
      // Nie zalogowano
      // print('Nie zalogowano.');
      String message = '';
      if (err.toString().contains('ERROR_USER_NOT_FOUND')) {
        message = 'There is no such account.'; // Takie konto nie istnieje.
      } else {
        message =
            'Check the email and password.'; // Sprawdz poprawnosc email i hasla.
      }

      setState(() {
        Scaffold.of(context).hideCurrentSnackBar();
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Container(child: Text(message)),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20),),
            ),
          ),
        );
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Text(
            'Login',
            style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 35),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _form,
                // autovalidate: true,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: widget.deviceSize.height * 0.03,
                    ),
                    TextFormField(
                      validator: (val) {
                        if (!RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(val)) {
                          return 'Please enter a valid email';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_passwordScope);
                      },
                      onSaved: (val) {
                        _data = Login(
                          email: val,
                          password: _data.password,
                        );
                      },
                    ),
                    SizedBox(
                      height: widget.deviceSize.height * 0.03,
                    ),
                    TextFormField(
                      validator: (val) {
                        if (val.length < 6) {
                          return 'Password must have 6 characters.';
                        } else {
                          return null;
                        }
                      },
                      focusNode: _passwordScope,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                      obscureText: true,
                      onFieldSubmitted: (_) => _saveForm(),
                      onSaved: (val) {
                        _data = Login(
                          email: _data.email,
                          password: val,
                        );
                      },
                    ),
                    SizedBox(
                      height: widget.deviceSize.height * 0.01,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                        onPressed: _loading ? null : () {},
                        child: Text(
                          'Forgot Password? ',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: RaisedButton(
              onPressed: _loading
                  ? null
                  : () {
                      _saveForm();
                    },
              elevation: 10,
              child: _loading
                  ? Container(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).buttonColor),
                      ),
                    )
                  : Text(
                      'Login',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(color: Colors.white),
                    ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Don\' have an account?'),
              FlatButton(
                onPressed: _loading
                    ? null
                    : () {
                        widget.changePage();
                        print('Sign Up');
                      },
                padding: EdgeInsets.all(0),
                child: Text(
                  'Sign Up',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
