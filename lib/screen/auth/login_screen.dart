import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:vape_store/network/user_network.dart';
import 'package:vape_store/screen/home_screen.dart';
import 'package:vape_store/screen/auth/register_screen.dart';
import 'package:vape_store/validator/auth_validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final valid = AuthValidator();
  final UserNetwork _userNetwork = UserNetwork();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    // print(_formKey.currentState?.validate());
    // print(_emailController.text.isEmpty);
    // print(_passwordController.text.isEmpty);
    // if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
    //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill in all fields')));
    // } else
    if (_formKey.currentState?.validate() == true) {
      final response = await _userNetwork.login(
        _emailController.text,
        _passwordController.text,
      );
      if (context.mounted) {
        // print(response.message);
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Login successful')));
        if (response.success) {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return const HomeScreen();
            },
          ));
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response.message),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        centerTitle: true,
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,

          // autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Welcome Back!',
                style: Theme.of(context).textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32.0),
              TextFormField(
                validator: ValidationBuilder().email().maxLength(50).build(),
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                validator: valid.password,
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () => _login(context),
                child: const Text('Login'),
              ),
              const SizedBox(height: 16.0),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                },
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
