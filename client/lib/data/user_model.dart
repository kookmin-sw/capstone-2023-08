import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';
@JsonSerializable()
class UserModel {
  String? user_id;
  String? password;
  String? user_name;
  String? user_img_url;

  UserModel({
    this.user_id,
    this.password,
    this.user_name,
    this.user_img_url,
  });

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
  factory UserModel.fromJson(Map<String, dynamic> json)
  => _$UserModelFromJson(json);
}
