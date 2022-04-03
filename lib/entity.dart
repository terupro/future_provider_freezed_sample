import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'entity.freezed.dart';

// 画面に表示したいデータをまとめるクラス

@freezed
abstract class Entity with _$Entity {
  const factory Entity({
    required int id,
    required String title,
  }) = _Entity;
}
