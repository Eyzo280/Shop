import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/auth.dart';

class Register {
  String email;
  String password;
  String displayName;

  Register({
    @required this.email,
    @required this.password,
    @required this.displayName,
  });
}

class SignUp extends StatefulWidget {
  final deviceSize;
  final Function changePage;

  SignUp({this.deviceSize, this.changePage});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _passwordScope = FocusNode();
  final _displayName = FocusNode();

  final _form = GlobalKey<FormState>();

  var _data = Register(
    email: '',
    password: '',
    displayName: '',
  );

  bool loading = false;

  void _saveForm() async {
    if (!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();
    _form.currentState.validate();
    print('Register');
    print(_data.email);
    print(_data.password);
    print(_data.displayName);
    setState(() {
      loading = true;
    });

    try {
      var register = await Provider.of<Auth>(context, listen: false)
          .signUpWithEmailAndPassword(
        email: _data.email,
        password: _data.password,
        displayName: _data.displayName,
      );
      // Utworzyło nowe konto
      print('Zarejestrowano');
    } catch (err) {
      // Nie utworzyło nowego konta

      String message = '';
      if (err.toString().contains('ERROR_INVALID_EMAIL')) {
        message = 'Check email.'; // Podano zly email.
      } else if (err.toString().contains('ERROR_EMAIL_ALREADY_IN_USE')) {
        message = 'This email is used.'; // Ten email jest zajety.
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
              borderRadius: BorderRadius.all(
                Radius.circular(20),
              ),
            ),
          ),
        );
        loading = false;
      });

      print('Wystapil problem przy rejestracji.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Text(
            'Register',
            style: Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 35),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _form,
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
                          return 'Please enter a valid email.';
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_passwordScope),
                      onSaved: (val) {
                        _data = Register(
                          email: val,
                          password: _data.password,
                          displayName: _data.displayName,
                        );
                      },
                    ),
                    SizedBox(
                      height: widget.deviceSize.height * 0.01,
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
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_displayName),
                      onSaved: (val) {
                        _data = Register(
                          email: _data.email,
                          password: val,
                          displayName: _data.displayName,
                        );
                      },
                    ),
                    SizedBox(
                      height: widget.deviceSize.height * 0.01,
                    ),
                    TextFormField(
                      /*
                      validator: (val) {
                        if (RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]")
                            .hasMatch(val)) {
                          return 'Please delete !@#\$%^& from name.';
                        } else {
                          return null;
                        }
                      },
                      */
                      focusNode: _displayName,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Display Name',
                      ),
                      onFieldSubmitted: (_) => _saveForm(),
                      onSaved: (val) {
                        _data = Register(
                          email: _data.email,
                          password: _data.password,
                          displayName: val,
                        );
                      },
                    ),
                    SizedBox(
                      height: widget.deviceSize.height * 0.01,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: RaisedButton(
              onPressed: loading
                  ? null
                  : () {
                      _saveForm();
                    },
              elevation: 10,
              child: loading
                  ? Container(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).buttonColor),
                      ),
                    )
                  : Text(
                      'Register',
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
              Text('Do you have account?'),
              FlatButton(
                onPressed: loading
                    ? null
                    : () {
                        widget.changePage();
                        print('Sign in');
                      },
                padding: EdgeInsets.all(0),
                child: Text(
                  'Sign in',
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
