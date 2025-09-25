import 'auth_status.dart';

class Session {
  final AuthStatus status;
  final String? uid;
  final bool isAnonymous;
  final String? displayName;
  final String? photoUrl;
  final String? email;

  const Session({
    required this.status,
    this.uid,
    this.isAnonymous = false,
    this.displayName,
    this.photoUrl,
    this.email, // TODO(ui settings): отобразить в настройках
  });

  bool get isLoggedIn => status == AuthStatus.authenticated;
  bool get isGuest => status == AuthStatus.unauthenticated && isAnonymous;
}
