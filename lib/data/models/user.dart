import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final int? oldUserId;
  final String email;
  final String nome;
  final bool userActivo;
  final int? maquinaConfecaoId;
  final String? token; // ← IMPORTANTE: adicionar token

  User({
    required this.id,
    this.oldUserId,
    required this.email,
    required this.nome,
    required this.userActivo,
    this.maquinaConfecaoId,
    this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
