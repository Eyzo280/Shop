import 'package:flutter/material.dart';

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

  void _saveForm() {
    if (!_form.currentState.validate()) {
      return;
    }
    _form.currentState.save();
    _form.currentState.validate();
    print('Login');
    print(_data.email);
    print(_data.password);
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
                        onPressed: () {},
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
              onPressed: () {
                _saveForm();
              },
              elevation: 10,
              color: Colors.purple,
              child: Text(
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
                onPressed: () {
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
