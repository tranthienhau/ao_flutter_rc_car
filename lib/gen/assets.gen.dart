/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal

import 'package:flutter/widgets.dart';

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/background.png
  AssetGenImage get background =>
      const AssetGenImage('assets/icons/background.png');

  /// File path: assets/icons/ic_arrow.svg
  String get icArrow => 'assets/icons/ic_arrow.svg';

  /// File path: assets/icons/ic_car_head.svg
  String get icCarHead => 'assets/icons/ic_car_head.svg';

  /// File path: assets/icons/ic_car_tail.svg
  String get icCarTail => 'assets/icons/ic_car_tail.svg';

  /// File path: assets/icons/ic_close.svg
  String get icClose => 'assets/icons/ic_close.svg';

  /// File path: assets/icons/ic_division.svg
  String get icDivision => 'assets/icons/ic_division.svg';

  /// File path: assets/icons/ic_gps.svg
  String get icGps => 'assets/icons/ic_gps.svg';

  /// File path: assets/icons/ic_high_volume.svg
  String get icHighVolume => 'assets/icons/ic_high_volume.svg';

  /// File path: assets/icons/ic_loading.svg
  String get icLoading => 'assets/icons/ic_loading.svg';

  /// File path: assets/icons/ic_minus.svg
  String get icMinus => 'assets/icons/ic_minus.svg';

  /// File path: assets/icons/ic_plus.svg
  String get icPlus => 'assets/icons/ic_plus.svg';

  /// File path: assets/icons/ic_reload.svg
  String get icReload => 'assets/icons/ic_reload.svg';

  /// File path: assets/icons/ic_save.svg
  String get icSave => 'assets/icons/ic_save.svg';

  /// File path: assets/icons/ic_setting.svg
  String get icSetting => 'assets/icons/ic_setting.svg';

  /// File path: assets/icons/ic_sort_arrow.svg
  String get icSortArrow => 'assets/icons/ic_sort_arrow.svg';

  /// File path: assets/icons/ic_warning.svg
  String get icWarning => 'assets/icons/ic_warning.svg';

  /// List of all assets
  List<dynamic> get values => [
        background,
        icArrow,
        icCarHead,
        icCarTail,
        icClose,
        icDivision,
        icGps,
        icHighVolume,
        icLoading,
        icMinus,
        icPlus,
        icReload,
        icSave,
        icSetting,
        icSortArrow,
        icWarning
      ];
}

class Assets {
  Assets._();

  static const $AssetsIconsGen icons = $AssetsIconsGen();
}

class AssetGenImage {
  const AssetGenImage(this._assetName);

  final String _assetName;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider() => AssetImage(_assetName);

  String get path => _assetName;

  String get keyName => _assetName;
}
