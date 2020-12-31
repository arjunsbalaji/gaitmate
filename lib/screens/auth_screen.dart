import 'package:flutter/material.dart';
import '../providers/auth.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      child: Text(
                        'Gait Mate',
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  ),
                ],),
            )

          )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  var _isLoading = false;
  var _loginState = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _switchAuthState() {
    setState((){
      _loginState = ! _loginState;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Form(
      key: _formKey,
        child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 8.0,
        child: Container(
          width: deviceSize.width * 0.75,
          padding: EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Enter email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Enter password',
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Password too short';
                    }
                    return null;
                  },
                ),
                if (_loginState == false)
                  TextFormField(
                    enabled: _loginState == false,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: _loginState == false
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords don\'t match';
                            }
                            return null;
                          }
                        : null,
                  ),
                SizedBox(
                  height: 20,
                ),
                _isLoading
                    ? CircularProgressIndicator()
                    : RaisedButton(
                        child: Text(
                            _loginState ? 'LOGIN' : 'SIGNUP'),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            FocusScope.of(context).unfocus();
                            if (_loginState) {
                              context.read<AuthenticationService>().signIn(
                                email: _emailController.text,
                                password: _passwordController.text,
                                context: context,
                              );
                            }
                            else {
                              context.read<AuthenticationService>().signUp(
                                email: _emailController.text,
                                password: _passwordController.text,
                                context: context,
                              );
                            }
                          }
                        },
                      ),
                FlatButton(
                  onPressed: _switchAuthState,
                  child: Text(
                      '${_loginState ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

