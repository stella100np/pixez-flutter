import 'package:sqflite/sqflite.dart';

class Account {
  AccountResponse response;

  Account({this.response});

  Account.fromJson(Map<String, dynamic> json) {
    response = json['response'] != null
        ? new AccountResponse.fromJson(json['response'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.response != null) {
      data['response'] = this.response.toJson();
    }
    return data;
  }
}

final String tableAccount = 'account';
final String columnId = '_id';
final String columnAccessToken = 'accessToken';
final String columnExpiresIn = 'expiresIn';
final String columnTokenType = 'expirestokenType';
final String columnDeviceToken = 'deviceToken';

class AccountProvider {
  Database db;

  Future open() async {
    String path = await getDatabasesPath();
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
create table $tableAccount ( 
  $columnId integer primary key autoincrement, 
  $columnAccessToken text not null,
  $columnTokenType text not null,
  $columnExpiresIn integer not null,
  $columnDeviceToken text not null,
  )
''');
    });
  }

  Future<AccountPersist> insert(AccountPersist todo) async {
    todo.id = await db.insert(tableAccount, todo.toJson());
    return todo;
  }

  Future<AccountPersist> getAccount(int id) async {
    List<Map> maps = await db.query(tableAccount,
        columns: [
          columnId,
          columnAccessToken,
          columnExpiresIn,
          columnTokenType,
          columnDeviceToken
        ],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return AccountPersist.fromJson(maps.first);
    }
    return null;
  }

  Future<List<AccountPersist>> getAllAccount() async {
    List result = new List();
    List<Map> maps = await db.query(tableAccount, columns: [
      columnId,
      columnAccessToken,
      columnExpiresIn,
      columnTokenType,
      columnDeviceToken
    ]);

    if (maps.length > 0) {
      maps.forEach((f) {
        result.add(AccountPersist.fromJson(maps.first));
      });
    }
    return result;
  }

  Future<int> delete(int id) async {
    return await db
        .delete(tableAccount, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(AccountPersist todo) async {
    return await db.update(tableAccount, todo.toJson(),
        where: '$columnId = ?', whereArgs: [todo.id]);
  }

  Future close() async => db.close();
}

class AccountPersist {
  int id;
  String accessToken;
  int expiresIn;
  String tokenType;
  String scope;
  String refreshToken;
  String deviceToken;

  AccountPersist(
      {this.accessToken,
      this.expiresIn,
      this.tokenType,
      this.scope,
      this.refreshToken,
      this.deviceToken});

  AccountPersist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    accessToken = json['access_token'];
    expiresIn = json['expires_in'];
    tokenType = json['token_type'];
    scope = json['scope'];
    refreshToken = json['refresh_token'];
    deviceToken = json['device_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['access_token'] = this.accessToken;
    data['expires_in'] = this.expiresIn;
    data['token_type'] = this.tokenType;
    data['scope'] = this.scope;
    data['refresh_token'] = this.refreshToken;
    data['device_token'] = this.deviceToken;
    return data;
  }
}

class AccountResponse {
  String accessToken;
  int expiresIn;
  String tokenType;
  String scope;
  String refreshToken;
  User user;
  String deviceToken;

  AccountResponse(
      {this.accessToken,
      this.expiresIn,
      this.tokenType,
      this.scope,
      this.refreshToken,
      this.user,
      this.deviceToken});

  AccountResponse.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    expiresIn = json['expires_in'];
    tokenType = json['token_type'];
    scope = json['scope'];
    refreshToken = json['refresh_token'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    deviceToken = json['device_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['expires_in'] = this.expiresIn;
    data['token_type'] = this.tokenType;
    data['scope'] = this.scope;
    data['refresh_token'] = this.refreshToken;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['device_token'] = this.deviceToken;
    return data;
  }
}

class User {
  ProfileImageUrls profileImageUrls;
  String id;
  String name;
  String account;
  String mailAddress;
  bool isPremium;
  int xRestrict;
  bool isMailAuthorized;

  User(
      {this.profileImageUrls,
      this.id,
      this.name,
      this.account,
      this.mailAddress,
      this.isPremium,
      this.xRestrict,
      this.isMailAuthorized});

  User.fromJson(Map<String, dynamic> json) {
    profileImageUrls = json['profile_image_urls'] != null
        ? new ProfileImageUrls.fromJson(json['profile_image_urls'])
        : null;
    id = json['id'];
    name = json['name'];
    account = json['account'];
    mailAddress = json['mail_address'];
    isPremium = json['is_premium'];
    xRestrict = json['x_restrict'];
    isMailAuthorized = json['is_mail_authorized'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.profileImageUrls != null) {
      data['profile_image_urls'] = this.profileImageUrls.toJson();
    }
    data['id'] = this.id;
    data['name'] = this.name;
    data['account'] = this.account;
    data['mail_address'] = this.mailAddress;
    data['is_premium'] = this.isPremium;
    data['x_restrict'] = this.xRestrict;
    data['is_mail_authorized'] = this.isMailAuthorized;
    return data;
  }
}

class ProfileImageUrls {
  String px16x16;
  String px50x50;
  String px170x170;

  ProfileImageUrls({this.px16x16, this.px50x50, this.px170x170});

  ProfileImageUrls.fromJson(Map<String, dynamic> json) {
    px16x16 = json['px_16x16'];
    px50x50 = json['px_50x50'];
    px170x170 = json['px_170x170'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['px_16x16'] = this.px16x16;
    data['px_50x50'] = this.px50x50;
    data['px_170x170'] = this.px170x170;
    return data;
  }
}
