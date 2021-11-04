import 'package:flutter/material.dart';
import 'package:login_test/providers/login_provider.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();

    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final LoginProvider loginProvider =
        Provider.of<LoginProvider>(context, listen: true);
    loginProvider.isLoading = false;

    _emailController.text = 'admin@app.test';
    _passwordController.text = 'password';

    final _formKey = GlobalKey<FormState>();

    void _send() async {

      if (!_formKey.currentState!.validate()) {
        return;
      }

      try {
        await loginProvider.login(
            _emailController.text, _passwordController.text);

        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
      } on Exception catch (exception) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(exception.toString())));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Вход'),
      ),
      body: Consumer<LoginProvider>(
          builder: (context, LoginProvider loginProvider, _) {
        if (loginProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextFormField(
                    validator: (String? value) {
                      if (value == null || value.length == 0) {
                        return 'Укажите ваш E-Mail';
                      }
                    },
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'E-Mail',
                        hintText: 'Введите ваш E-Mail'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  //padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextFormField(
                    validator: (String? value) {
                      if (value == null || value.length < 5) {
                        return 'Пароль должен состоять минимум из 5 символов';
                      }
                    },
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Пароль',
                        hintText: 'Введите пароль'),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _send(),
                    child: const Text('Войти'),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
