import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignScreen extends StatefulWidget {
  const SignScreen({super.key});

  @override
  SignScreenState createState() => SignScreenState();
}

class SignScreenState extends State<SignScreen> {
  bool _passwordVisible = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _togglePasswordVisible() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  void _onSignInPressed() {}

  void _onSignUpPressed() {}

  @override
  void initState() {
    _passwordVisible = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Container(
        width: double.infinity,
        child: Center(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    style: Theme.of(context).textTheme.bodyMedium,
                    controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email_outlined),
                      labelText: 'email',
                      labelStyle: Theme.of(context).textTheme.bodyMedium,
                      hintText: 'enter your email, honey',
                    ),
                  ),
                  TextFormField(
                      style: Theme.of(context).textTheme.bodyMedium,
                      controller: passwordController,
                      obscureText: !_passwordVisible,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.password_outlined),
                        labelText: 'password',
                        labelStyle: Theme.of(context).textTheme.bodyMedium,
                        hintText: 'and your password, sweetie',
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).primaryColorLight,
                          ),
                          onPressed: _togglePasswordVisible,
                        ),
                      )),
                  const SizedBox(height: 16),
                  FilledButton(
                      onPressed: _onSignInPressed,
                      child: const Text('do something, i want in!')),
                  const SizedBox(height: 32),
                  Text(
                    'we do not share anyone\'s data. we promise. \nmaybe only the way you\'re so cute. and nothing else.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.apply(color: Theme.of(context).primaryColorLight),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  ElevatedButton(
                      onPressed: () {},
                      child: const Text(
                          'i don\'t have an account :c lemme create one'))
                ],
              )),
        ),
      ),
    );
  }
}
