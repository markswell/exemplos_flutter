import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exception/auth_exception.dart';
import 'package:shop/model/auth.dart';

enum AuthMode { SingnUp, Login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  AuthMode _authMode = AuthMode.Login;

  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  AnimationController? _animationController;
  Animation<double>? _opacitAnimation;
  Animation<Offset>? _slideAnimation;

  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  bool _isLogin() => _authMode == AuthMode.Login;
  // bool _isSingnap() => _authMode == AuthMode.Singnup;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _opacitAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Curves.linear,
      ),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1.5),
      end: Offset(0.0, 0),
    ).animate(
      CurvedAnimation(
        parent: _animationController!,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _animationController?.dispose();
  }

  void _showErrorDialog(String msg) {
    const style = TextStyle(color: Colors.black);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Ocorreu um erro',
          style: style,
        ),
        content: Text(
          msg,
          style: style,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Ok'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    setState(() => _isLoading = true);
    var isValide = _formKey.currentState?.validate() ?? false;
    _formKey.currentState?.save();

    Auth auth = Provider.of<Auth>(context, listen: false);

    if (!isValide) {
      setState(() => _isLoading = false);
      return;
    }
    try {
      if (_isLogin()) {
        await auth.login(
          _authData['email']!,
          _authData['password']!,
        );
      } else {
        await auth.signup(
          _authData['email']!,
          _authData['password']!,
        );
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Erro ao logar');
    }
    setState(() => _isLoading = false);
  }

  void _setValue(String key, String value) {
    _authData[key] = value;
  }

  _switchAuthMode() {
    setState(() {
      if (_authMode == AuthMode.Login) {
        _authMode = AuthMode.SingnUp;
        _animationController?.forward();
      } else {
        _authMode = AuthMode.Login;
        _animationController?.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var widthDevice = MediaQuery.of(context).size.width;
    return Card(
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.linear,
        padding: EdgeInsets.all(16),
        height: _isLogin() ? 280 : 360,
        width: widthDevice * .75,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                onSaved: (email) {
                  _setValue('email', email.toString());
                  // _authData['email'] = email ?? '';
                },
                decoration: InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.black),
                validator: (email) {
                  final emailReceived = email ?? '';
                  if (emailReceived.trim().isEmpty ||
                      !emailReceived.contains('@')) {
                    return 'Email inválido';
                  }
                  return null;
                },
              ),
              TextFormField(
                  controller: _passwordController,
                  onSaved: (password) => _authData['password'] = password ?? '',
                  decoration: InputDecoration(labelText: 'Senha'),
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  style: TextStyle(color: Colors.black),
                  validator: (password) {
                    final passwordReceived = password ?? '';
                    if (passwordReceived.trim().isEmpty ||
                        passwordReceived.length < 3) {
                      return 'Senha dever ter no minimo 3 caracteres';
                    }
                    return null;
                  }),
              AnimatedContainer(
                constraints: BoxConstraints(
                  minHeight: _isLogin() ? 0 : 60,
                  maxHeight: _isLogin() ? 0 : 120,
                ),
                duration: Duration(milliseconds: 300),
                curve: Curves.linear,
                child: FadeTransition(
                  opacity: _opacitAnimation!,
                  child: SlideTransition(
                    position: _slideAnimation!,
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Confirmar senha'),
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      validator: _isLogin()
                          ? null
                          : (password) {
                              final passwordFinal = password ?? '';
                              if (_passwordController.text != passwordFinal) {
                                return 'Senhas não conferem';
                              }
                              return null;
                            },
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Spacer(),
                  _isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: _submit,
                          child: Text(
                            _isLogin() ? 'logar' : 'Registrar',
                            style: TextStyle(color: Colors.white),
                          )),
                ],
              ),
              Spacer(),
              TextButton(
                onPressed: _switchAuthMode,
                child: _isLogin()
                    ? Text('Crie sua conta')
                    : Text('Já possui conta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
