import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_homework_24_2/ui/bloc/login/login_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

class LoginPageBloc extends StatefulWidget {
  const LoginPageBloc({super.key});

  @override
  State<LoginPageBloc> createState() => _LoginPageBlocState();
}

class _LoginPageBlocState extends State<LoginPageBloc> {
  final dio = GetIt.I<Dio>();
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String? _emailError = null;
  String? _passwordError = null;
  bool? _rememberMe = false;
  bool _isLoading = false;
  LoginBloc? loginBloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loginBloc = BlocProvider.of<LoginBloc>(context);
      loginBloc?.add(LoginAutoLoginEvent());
    });
  }

  void submit() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      setState(() {});
      return;
    }
    _formKey.currentState!.save();

    print('Email: $_email');
    print('Password: $_password');
    print('Remember Me: $_rememberMe');
    loginBloc?.add(LoginSubmitEvent(_email, _password, _rememberMe!));
  }

  @override
  Widget build(BuildContext context) {
    loginBloc = BlocProvider.of<LoginBloc>(context);

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          print("Login successful! ${state.token}");
          Navigator.pushReplacementNamed(context, '/list',
              arguments: state.token);
        }
        if (state is LoginFailure) {
          print("Login failed: ${state.error}");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.error),
            duration: const Duration(seconds: 2),
          ));
        }
        if (state is LoginLoading) {
          setState(() {
            _isLoading = true;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.disabled,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Login',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    enabled: !_isLoading,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      errorText: _emailError,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        _emailError = "Kérjük, adja meg az email címét";
                        return _emailError;
                      }
                      if (!value.contains('@')) {
                        _emailError = "Helytelen email formátum";
                        return _emailError;
                      }
                      _emailError = null;
                      return null;
                    },
                    onSaved: (value) => _email = value!,
                    onChanged: (value) {
                      if (_emailError != null) {
                        setState(() {
                          _emailError = null;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    enabled: !_isLoading,
                    decoration: InputDecoration(
                      labelText: 'Jelszó',
                      errorText: _passwordError,
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        _passwordError = "Kérjük, adja meg a jelszót";
                        return _passwordError;
                      }
                      if (value.length < 6) {
                        _passwordError =
                            "A jelszónak legalább 6 karakter hosszúnak kell lennie";
                        return _passwordError;
                      }
                      _passwordError = null;
                      return null;
                    },
                    onSaved: (value) => _password = value!,
                    onChanged: (value) {
                      if (_passwordError != null) {
                        setState(() {
                          _passwordError = null;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _rememberMe,
                            onChanged: (value) {
                              if (_isLoading) return;
                              setState(() {
                                _rememberMe = value;
                              });
                            },
                          ),
                          const Text("Jegyezzen meg"),
                        ],
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: _isLoading ? null : submit,
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
