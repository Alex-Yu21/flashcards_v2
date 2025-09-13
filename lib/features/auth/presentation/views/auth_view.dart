import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashcards_v2/features/learning/presentation/views/home_view.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

// TODO sizes in a different fail?

class Gaps {
  const Gaps._();
  static const v16 = SizedBox(height: 16);
  static const v24 = SizedBox(height: 24);
}

class Pads {
  const Pads._();
  static const screenH24 = EdgeInsets.symmetric(horizontal: 24);
  static const appBarH24 = EdgeInsets.symmetric(horizontal: 24);
  static const cardAll16 = EdgeInsets.all(16);
  static const dividerLabelH16 = EdgeInsets.symmetric(horizontal: 16);
}

class FontSizes {
  const FontSizes._();
  static const double s16 = 16.0;
  static const double s32 = 32.0;
}

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final _form = GlobalKey<FormState>();

  var _isLogin = true;
  var _enteredEmail = '';
  var _enteredPassword = '';

  Future<void> _submit() async {
    final isValid = _form.currentState!.validate();

    FocusScope.of(context).unfocus();
    if (!isValid) return;

    _form.currentState!.save();

    try {
      if (_isLogin) {
        await _firebase.signInWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
      } else {
        await _firebase.createUserWithEmailAndPassword(
          email: _enteredEmail,
          password: _enteredPassword,
        );
      }
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? 'Authentication failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: scheme.surface,
        actions: [
          Padding(
            padding: Pads.appBarH24,
            child: GestureDetector(
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (ctx) => const HomeView()));
              },
              child: Text(
                'Skip >>',
                style: TextStyle(
                  fontSize: FontSizes.s16,
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: scheme.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: Pads.screenH24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isLogin ? 'Log In' : 'Sign Up',
                    style: TextStyle(
                      fontSize: FontSizes.s32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _isLogin
                        ? 'Enter your details below'
                        : 'Enter your details below',
                    style: TextStyle(
                      fontSize: FontSizes.s16,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                  Gaps.v24,
                  Card(
                    color: scheme.surfaceContainerLowest,
                    child: Padding(
                      padding: Pads.cardAll16,
                      child: Form(
                        key: _form,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Your Email',
                              style: TextStyle(
                                fontSize: FontSizes.s16,
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                            TextFormField(
                              decoration: const InputDecoration(),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    !value.contains('@')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredEmail = value!;
                              },
                            ),
                            Gaps.v24,
                            Text(
                              'Password',
                              style: TextStyle(
                                fontSize: FontSizes.s16,
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                            TextFormField(
                              decoration: const InputDecoration(),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.trim().length < 6) {
                                  return 'Password must be at leat 6 characters long';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _enteredPassword = value!;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Gaps.v24,
                  if (!_isLogin)
                    Row(
                      children: [
                        Checkbox(
                          tristate: true,
                          value: null,
                          onChanged: (isLogin) {},
                        ),
                        Expanded(
                          child: Text(
                            'By creating an account you have to agree with our therms & condications.',
                            style: TextStyle(
                              fontSize: FontSizes.s16,
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                  Gaps.v16,
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.resolveWith((
                          states,
                        ) {
                          if (states.contains(WidgetState.disabled)) {
                            return scheme.primary.withValues(alpha: 0.38);
                          }
                          if (states.contains(WidgetState.pressed)) {
                            return scheme.primary.withValues(alpha: 0.90);
                          }
                          return scheme.primary;
                        }),
                      ),
                      onPressed: _submit,
                      child: Text(
                        _isLogin ? 'Log in' : 'Create account',
                        style: TextStyle(
                          color: scheme.onPrimary,
                          fontSize: FontSizes.s16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Gaps.v16,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _isLogin
                            ? "Don't have an account?"
                            : 'Already have an account？ ',
                        style: TextStyle(
                          fontSize: FontSizes.s16,
                          color: scheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _isLogin = !_isLogin;
                          });
                        },
                        child: Text(
                          _isLogin ? 'Sign Up' : 'Log in',
                          style: TextStyle(
                            color: scheme.primary,
                            fontSize: FontSizes.s16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Gaps.v24,
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 2,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                      Padding(
                        padding: Pads.dividerLabelH16,
                        child: Text(
                          _isLogin ? 'Or log in with' : 'Or sign up with',
                          style: TextStyle(
                            fontSize: FontSizes.s16,
                            color: scheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 2,
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  Gaps.v24,
                  Center(
                    child: SizedBox(
                      width: 34,
                      child: Image.asset('assets/google_icon.png'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
