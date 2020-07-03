import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop App',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: TextTheme(
            bodyText1: TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.bold,
            ),
          )),
      home: MyHomePage(title: 'Shop App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool pageLogin = true;

  Widget login(deviceSize) {
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
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: deviceSize.height * 0.03,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Login',
                      ),
                    ),
                    SizedBox(
                      height: deviceSize.height * 0.03,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                    SizedBox(
                      height: deviceSize.height * 0.01,
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
                print('Login');
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
                  setState(() {
                    pageLogin = false;
                  });
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

  Widget register(deviceSize) {
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
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: deviceSize.height * 0.03,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Login',
                      ),
                    ),
                    SizedBox(
                      height: deviceSize.height * 0.01,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                    SizedBox(
                      height: deviceSize.height * 0.01,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Display Name',
                      ),
                    ),
                    SizedBox(
                      height: deviceSize.height * 0.01,
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
                print('Register');
              },
              elevation: 10,
              color: Colors.purple,
              child: Text(
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
                onPressed: () {
                  setState(() {
                    pageLogin = true;
                  });
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

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(deviceSize.height * deviceSize.width / 7000),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.blue, Colors.purple],
          ),
        ),
        child: Column(
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
                    ? login(deviceSize)
                    : register(deviceSize),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
