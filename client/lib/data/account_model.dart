import 'package:json_annotation/json_annotation.dart';

part 'account_model.g.dart';

@JsonSerializable()
class AccountModel {
  String? user_id;
  String? password;
  String? user_name;
  String? user_img_url;

  AccountModel({
    this.user_id,
    this.password,
    this.user_name,
    this.user_img_url,
  });

  Map<String, dynamic> toJson() => _$AccountModelToJson(this);
}
