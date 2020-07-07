part of amap_view;

class BitmapDescriptor {
  const BitmapDescriptor._(this._data);

  static const double hueRed = 0.0;
  static const double hueOrange = 30.0;
  static const double hueYellow = 60.0;
  static const double hueGreen = 120.0;
  static const double hueCyan = 180.0;
  static const double hueAzure = 210.0;
  static const double hueBlue = 240.0;
  static const double hueViolet = 270.0;
  static const double hueMagenta = 300.0;
  static const double hueRose = 330.0;

  static const BitmapDescriptor defaultMarker = BitmapDescriptor._(<dynamic>['defaultMarker']);

  static BitmapDescriptor defaultMarkerWithHue(double hue) {
    assert(0.0 <= hue && hue < 360.0);
    return BitmapDescriptor._(<dynamic>['defaultMarker', hue]);
  }

  static Future<BitmapDescriptor> fromAssetImage(ImageConfiguration configuration, String assetName,
      {AssetBundle bundle, String package}) async {
    final AssetImage assetImage = AssetImage(assetName, package: package, bundle: bundle);
    final AssetBundleImageKey assetBundleImageKey = await assetImage.obtainKey(configuration);
    return BitmapDescriptor._(<dynamic>[
      'fromAssetImage',
      assetBundleImageKey.name,
      assetBundleImageKey.scale,
    ]);
  }

  static Future<BitmapDescriptor> fromAssetImageWithText(ImageConfiguration configuration, String assetName, Label label,
      {AssetBundle bundle, String package}) async {
    final AssetImage assetImage = AssetImage(assetName, package: package, bundle: bundle);
    final AssetBundleImageKey assetBundleImageKey = await assetImage.obtainKey(configuration);
    return BitmapDescriptor._(<dynamic>['fromAssetImageWithText', assetBundleImageKey.name, assetBundleImageKey.scale, label.toMap()]);
  }

  static Future<BitmapDescriptor> fromAvatarWithAssetImage(ImageConfiguration configuration, String assetName, Avatar avatar,
      {AssetBundle bundle, String package}) async {
    final AssetImage assetImage = AssetImage(assetName, package: package, bundle: bundle);
    final AssetBundleImageKey assetBundleImageKey = await assetImage.obtainKey(configuration);
    return BitmapDescriptor._(<dynamic>[
      'fromAvatarWithAssetImage',
      assetBundleImageKey.name,
      assetBundleImageKey.scale,
      avatar.toMap(),
    ]);
  }

  static BitmapDescriptor fromBytes(Uint8List byteData) {
    return BitmapDescriptor._(<dynamic>['fromBytes', byteData]);
  }

  final dynamic _data;

  dynamic toMap() => _data;
}
