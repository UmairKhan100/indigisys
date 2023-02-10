// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, annotate_overrides, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';

import '../blocs/login_provider.dart';

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  Widget build(BuildContext context) {
    final bloc = LoginProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('INDIGISYS'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildEmailField(bloc),
            Container(margin: const EdgeInsets.only(top: 12)),
            buildPasswordField(bloc),
            Container(margin: const EdgeInsets.only(top: 24)),
            buildSubmitButton(bloc),
          ],
        ),
      ),
    );
  }

  Widget buildEmailField(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.email,
      builder: ((context, AsyncSnapshot<String> snapshot) {
        return TextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          style: TextStyle(fontSize: 18),
          onChanged: bloc.changeEmail,
          decoration: InputDecoration(
            hintText: 'Email',
            errorText: snapshot.hasError ? snapshot.error.toString() : null,
            fillColor: Colors.grey[200],
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
        );
      }),
    );
  }

  Widget buildPasswordField(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.password,
      builder: ((context, AsyncSnapshot<String> snapshot) {
        return TextField(
          controller: passwordController,
          obscureText: true,
          style: TextStyle(fontSize: 18),
          onChanged: bloc.changePassword,
          decoration: InputDecoration(
            hintText: 'Password',
            errorText: snapshot.hasError ? snapshot.error.toString() : null,
            fillColor: Colors.grey[200],
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
        );
      }),
    );
  }

  Widget buildSubmitButton(LoginBloc bloc) {
    return Builder(builder: (context) {
      return ElevatedButton(
        onPressed: () async {
          final parsedJson = await bloc.validate;

          if (parsedJson['success'] == 'no') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(
                  parsedJson['error'],
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.green,
                content: Text(
                  'Login Successful!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
              ),
            );

            emailController.clear();
            passwordController.clear();
            bloc.changeEmail('');
            bloc.changePassword('');
            final int customerId = parsedJson["data"][0];
            final String customerName = parsedJson["data"][1];
            Navigator.pushNamed(
              context,
              '/dashboard/$customerId/$customerName',
            );
          }
        },
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'SIGN IN',
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    });
  }
}
