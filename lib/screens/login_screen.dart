import 'package:flutter/material.dart';
import 'package:loja_virtual/models/user_model.dart';
import 'package:loja_virtual/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Entrar"),
        centerTitle: true,
        actions: <Widget>[
          TextButton(
            child: Text(
              "CRIAR CONTA",
              style: TextStyle(fontSize: 15.0),
            ),
            style: ButtonStyle(textStyle: MaterialStateProperty.all(const TextStyle(color: Colors.white))),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => SignupScreen()));
            },
          )
        ],
      ),
      body: ScopedModelDescendant<UserModel>(
        builder: (context, child, model) {
          if (model.isLoading)
            return Center(
              child: CircularProgressIndicator(),
            );

          return Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: <Widget>[
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(hintText: "E-mail"),
                  keyboardType: TextInputType.emailAddress,
                  validator: (text) {
                    if (text.isEmpty || !text.contains("@")) {
                      return "Email inválido!";
                    }

                    return null;
                  },
                ),
                SizedBox(
                  height: 16.0,
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(hintText: "Senha"),
                  obscureText: true,
                  validator: (text) {
                    if (text.isEmpty || text.length < 6) {
                      return "Senha inválida!";
                    }
                    return null;
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      if (_emailController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Insira seu email para recuperação!"),
                          backgroundColor: Colors.redAccent,
                          duration: Duration(seconds: 2),
                        ));
                      } else {
                        model.recoverPass(_emailController.text);

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Confira seu email!"),
                          backgroundColor: Theme.of(context).primaryColor,
                          duration: Duration(seconds: 2),
                        ));
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.zero,
                    child: Text(
                      "Esqueci minha senha",
                      textAlign: TextAlign.right,
                    ),
                    )
                  ),
                ),
                SizedBox(
                  height: 16.0,
                ),
                SizedBox(
                  height: 44.0,
                  child: ElevatedButton(
                    child: Text(
                      "Entrar",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all((Theme.of(context).primaryColor)),
                        textStyle: MaterialStateProperty.all(const TextStyle(color: Colors.white))),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        model.signIn(
                            email: _emailController.text,
                            pass: _passwordController.text,
                            onSuccess: _onSuccess,
                            onFail: _onFail);
                      }
                    },
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  void _onSuccess() {
    Navigator.of(context).pop();
  }

  void _onFail() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("Falha ao entrar!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}
