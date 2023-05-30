class Account {
  String? id;
  String? password;
  String? nickname;

  Account({this.id, this.password, this.nickname});

  Map<String, dynamic> toJson() => {
  'user_id': id,
  'user_name': nickname,
  'password': password,
  'user_img_url': null,
  };
}