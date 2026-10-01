import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

class IconDataConverter
    implements JsonConverter<IconData?, Map<String, dynamic>?> {
  const IconDataConverter();

  @override
  IconData? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return IconData(
      json['code_point'] as int,
      fontFamily: json['font_family'] as String?,
      fontPackage: json['font_package'] as String?,
    );
  }

  @override
  Map<String, dynamic>? toJson(IconData? icon) {
    if (icon == null) return null;
    return {
      'code_point': icon.codePoint,
      'font_family': icon.fontFamily,
      'font_package': icon.fontPackage,
    };
  }
}
