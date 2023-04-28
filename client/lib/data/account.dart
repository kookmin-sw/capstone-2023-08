class Account {
  String? id;
  String? password;
  String? nickname;
  String? img;

  Account({this.id, this.password, this.nickname, this.img});

  Map<String, dynamic> toJson() => {
  'user_id': id,
  'user_name': nickname,
  'password': password,
  'user_img_url': img,
  };
}