class User {
  String? _email;
  String? _uid;
  String? _displayName;
  String? _photoUrl;

  User({String? email, String? uid, String? displayName, String? photoUrl})
      : _email = email,
        _uid = uid,
        _displayName = displayName,
        _photoUrl = photoUrl;

  void setUser(Map<String, dynamic> map) {
    _email = map['email'] as String?;
    _uid = map['uid'] as String?;
    _displayName = map['displayName'] as String?;
    _photoUrl = map['photoUrl'] as String?;
  }

  String? get uid => _uid;
  String? get email => _email;
  String? get displayName => _displayName;
  String? get photoUrl => _photoUrl;

  Map<String, String?> getUser() {
    return {
      'email': _email,
      'displayName': _displayName,
      'uid': _uid,
      'photoUrl': _photoUrl,
    };
  }
}
