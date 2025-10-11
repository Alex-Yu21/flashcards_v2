import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashcards_v2/app/di/secrets.dart';
import 'package:flashcards_v2/app/navigation/destinations.dart';
import 'package:flashcards_v2/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

// TODO sizes in a different fail?

class Gaps {
  const Gaps._();
  static const v16 = SizedBox(height: 16);
  static const v24 = SizedBox(height: 24);
}

class Pads {
  const Pads._();
  static const screenH24 = EdgeInsets.symmetric(horizontal: 24);
  static const cardAll16 = EdgeInsets.all(16);
  static const dividerLabelH16 = EdgeInsets.symmetric(horizontal: 16);
}

class IconSizes {
  const IconSizes._();
  static const double s34 = 34.0;
}

class FontSizes {
  const FontSizes._();
  static const double fs16 = 16.0;
  static const double fs32 = 32.0;
}

class AuthView extends ConsumerStatefulWidget {
  const AuthView({super.key});

  @override
  ConsumerState<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends ConsumerState<AuthView> {
  final _form = GlobalKey<FormState>();

  var _isLogin = false;
  var _enteredEmail = '';
  var _enteredPassword = '';

  Future<void> _submit() async {
    final isValid = _form.currentState!.validate();

    FocusScope.of(context).unfocus();
    if (!isValid) return;

    _form.currentState!.save();

    final repo = ref.read(authRepositoryProvider);

    try {
      if (_isLogin) {
        await repo.signInWithCredential(
          EmailAuthProvider.credential(
            email: _enteredEmail,
            password: _enteredPassword,
          ),
        );
      } else {
        await repo.signUpWithEmail(_enteredEmail, _enteredPassword);
      }

      try {
        final uid = FirebaseAuth.instance.currentUser!.uid;

        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'email': _enteredEmail,
        });
      } on FirebaseException catch (e, st) {
        debugPrint('Firestore error: ${e.code} ${e.message}\n$st');
        if (!mounted) return;
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(SnackBar(content: Text('Firestore: ${e.code}')));
      }
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message ?? 'Authentication failed')),
      );
    }
  }

  Future<void> _googleSignIn() async {
    await GoogleSignIn.instance.initialize(
      serverClientId: kServerClientId,
      // clientId: '<iOS client id>'    TODO: iOS
    );
    await GoogleSignIn.instance.authenticate();
    //TODO пользователь отменил вход

    final signInEvent =
        await GoogleSignIn.instance.authenticationEvents.firstWhere(
              (e) => e is GoogleSignInAuthenticationEventSignIn,
            )
            as GoogleSignInAuthenticationEventSignIn;

    final user = signInEvent.user;
    final googleAuth = user.authentication;

    await ref
        .read(authRepositoryProvider)
        .signInWithCredential(
          GoogleAuthProvider.credential(idToken: googleAuth.idToken),
        );

    // TODO ошибки файрсторе

    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'username': user.displayName,
      'email': user.email,
      'image_url': user.photoUrl,
    });
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: scheme.surface,
        actions: [
          Padding(
            padding: Pads.screenH24,
            child: TextButton(
              onPressed: () async {
                context.go(Routes.homeView);
                await ref
                    .read(authControllerProvider.notifier)
                    .signInAnonymously();
              },
              child: Text(
                'Skip >>',
                style: TextStyle(
                  fontSize: FontSizes.fs16,
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
                      fontSize: FontSizes.fs32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _isLogin
                        ? 'Enter your details below'
                        : 'Enter your details below',
                    style: TextStyle(
                      fontSize: FontSizes.fs16,
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
                                fontSize: FontSizes.fs16,
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
                                fontSize: FontSizes.fs16,
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
                              fontSize: FontSizes.fs16,
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
                          fontSize: FontSizes.fs16,
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
                          fontSize: FontSizes.fs16,
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
                            fontSize: FontSizes.fs16,
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
                            fontSize: FontSizes.fs16,
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
                      width: IconSizes.s34,
                      height: IconSizes.s34,
                      child: Material(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: _googleSignIn,
                          child: Ink.image(
                            image: const AssetImage('assets/google_icon.png'),
                            fit: BoxFit.contain,
                            width: IconSizes.s34,
                            height: IconSizes.s34,
                          ),
                        ),
                      ),
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
