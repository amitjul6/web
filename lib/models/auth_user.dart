/// The signed-in identity (from Google, or a local guest).
class AuthUser {
  final String? name;
  final String? email;
  final String? photoUrl;
  final bool isGuest;

  const AuthUser({
    this.name,
    this.email,
    this.photoUrl,
    this.isGuest = false,
  });

  static const guest = AuthUser(name: 'Guest', isGuest: true);
}
