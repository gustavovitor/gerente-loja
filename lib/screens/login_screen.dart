import 'package:flutter/material.dart';
import 'package:gerenteloja/blocs/login_bloc.dart';
import 'package:gerenteloja/widgets/custom_text_form_field.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginBloc = LoginBloc();


  @override
  void initState() {
    super.initState();

    _loginBloc.outState.listen((state) {
      switch (state) {
        case LoginState.SUCCESS:
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen())
          );
          break;
        case LoginState.FAIL:
          showDialog(context: context, builder: (context) => AlertDialog(
            title: Text("Pera lá.."),
            content: Text("Você não possui privilégios para acessar o aplicativo."),
          ))   ;
          break;
        default:
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<LoginState>(
          stream: _loginBloc.outState,
          initialData: LoginState.LOADING,
          builder: (context, snapshot) {
            switch (snapshot.data) {
              case LoginState.LOADING:
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Theme.of(context).accentColor),
                  ),
                );
              default:
                return Stack(alignment: Alignment.center, children: <Widget>[
                  Container(),
                  SingleChildScrollView(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.store,
                            color: Theme.of(context).accentColor,
                            size: 120,
                          ),
                          Container(
                              padding: EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  CustomTextFormField(
                                    hintText: "Usuário",
                                    icon: Icons.person_outline,
                                    stream: _loginBloc.outEmail,
                                    onChanged: _loginBloc.changeEmail,
                                  ),
                                  SizedBox(
                                    height: 16,
                                  ),
                                  CustomTextFormField(
                                    hintText: "Senha",
                                    icon: Icons.lock_outline,
                                    obscure: true,
                                    stream: _loginBloc.outPassword,
                                    onChanged: _loginBloc.changePassword,
                                  ),
                                ],
                              )),
                          Container(
                            padding: EdgeInsets.all(16),
                            width: MediaQuery.of(context).size.width,
                            height: 80,
                            child: StreamBuilder<bool>(
                                stream: _loginBloc.outSubmitValid,
                                builder: (context, snapshot) {
                                  return FlatButton(
                                    color: Theme.of(context).accentColor,
                                    onPressed: snapshot.hasData ? _loginBloc.submit : null,
                                    child: Text("Entrar"),
                                  );
                                }),
                          )
                        ],
                      ),
                    ),
                  ),
                ]);
            }
          }),
    );
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }
}
