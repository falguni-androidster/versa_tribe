class LoginResponse {
  LoginResponse({
    String? accessToken,
    String? tokenType,
    num? expiresIn,
    String? refreshToken,
    String? userName,
    String? roles,
    String? profileExist,
    String? issued,
    String? expires,}) {
    _accessToken = accessToken;
    _tokenType = tokenType;
    _expiresIn = expiresIn;
    _refreshToken = refreshToken;
    _userName = userName;
    _roles = roles;
    _profileExist = profileExist;
    _issued = issued;
    _expires = expires;
  }

  LoginResponse.fromJson(dynamic json) {
    _accessToken = json['access_token'];
    _tokenType = json['token_type'];
    _expiresIn = json['expires_in'];
    _refreshToken = json['refresh_token'];
    _userName = json['userName'];
    _roles = json['roles'];
    _profileExist = json['profile_exist'];
    _issued = json['.issued'];
    _expires = json['.expires'];
  }

  String? _accessToken;
  String? _tokenType;
  num? _expiresIn;
  String? _refreshToken;
  String? _userName;
  String? _roles;
  String? _profileExist;
  String? _issued;
  String? _expires;

  LoginResponse copyWith({ String? accessToken,
    String? tokenType,
    num? expiresIn,
    String? refreshToken,
    String? userName,
    String? roles,
    String? profileExist,
    String? issued,
    String? expires,
  }) =>
      LoginResponse(
        accessToken: accessToken ?? _accessToken,
        tokenType: tokenType ?? _tokenType,
        expiresIn: expiresIn ?? _expiresIn,
        refreshToken: refreshToken ?? _refreshToken,
        userName: userName ?? _userName,
        roles: roles ?? _roles,
        profileExist: profileExist ?? _profileExist,
        issued: issued ?? _issued,
        expires: expires ?? _expires,
      );

  String? get accessToken => _accessToken;

  String? get tokenType => _tokenType;

  num? get expiresIn => _expiresIn;

  String? get refreshToken => _refreshToken;

  String? get userName => _userName;

  String? get roles => _roles;

  String? get profileExist => _profileExist;

  String? get issued => _issued;

  String? get expires => _expires;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['access_token'] = _accessToken;
    map['token_type'] = _tokenType;
    map['expires_in'] = _expiresIn;
    map['refresh_token'] = _refreshToken;
    map['userName'] = _userName;
    map['roles'] = _roles;
    map['profile_exist'] = _profileExist;
    map['.issued'] = _issued;
    map['.expires'] = _expires;
    return map;
  }

}