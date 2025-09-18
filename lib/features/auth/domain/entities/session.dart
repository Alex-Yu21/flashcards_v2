import 'auth_status.dart';

class Session {
  final AuthStatus status;
  final String? uid;
  final bool isAnonymous;
  const Session({required this.status, this.uid, this.isAnonymous = false});

  bool get isLoggedIn => status == AuthStatus.authenticated;
  bool get isGuest => isLoggedIn && isAnonymous;
}
