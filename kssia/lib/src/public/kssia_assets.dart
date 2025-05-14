/// Helper class for accessing KSSIA package assets
class KssiaAssets {
  /// Get the full path for an asset in the KSSIA package
  static String getAssetPath(String assetPath) {
    return 'packages/kssia/$assetPath';
  }

  /// Common assets
  static String get loginPeople => getAssetPath('assets/loginPeople.png');
  static String get kssiaLogo => getAssetPath('assets/icons/kssiaLogo.png');
  static String get triangles => getAssetPath('assets/triangles.png');
  static String get trianglesSvg => getAssetPath('assets/traingles.svg');
  static String get questionMark => getAssetPath('assets/question _mark.svg');
  static String get searchProduct => getAssetPath('assets/searchproduct.png');
  static String get premium => getAssetPath('assets/premium.png');
  static String get paymentQr => getAssetPath('assets/payment_qr.png');
  static String get noChat => getAssetPath('assets/nochat.png');
  static String get eventLocation => getAssetPath('assets/eventlocation.png');
  static String get basic => getAssetPath('assets/basic.png');
  static String get appIcon => getAssetPath('assets/appicon.png');
  static String get aboutUs => getAssetPath('assets/aboutus1.png');
  static String get vector3 => getAssetPath('assets/Vector3.svg');
  static String get vector => getAssetPath('assets/Vector.svg');
  static String get vector2 => getAssetPath('assets/Vector2.svg');
  static String get nfc => getAssetPath('assets/NFC.png');
  static String get skyberTechLogo => getAssetPath('assets/skybertechlogo.png');
  static String get acuteLogo => getAssetPath('assets/acutelogo.png');
  static String get letsGetStarted => getAssetPath('assets/letsgetstarted.png');
  static String get homeGirl => getAssetPath('assets/homegirl.png');
  static String get upgrade => getAssetPath('assets/upgrade.png');

  /// Fonts
  static String get interRegular => getAssetPath('assets/fonts/Inter_Regular.ttf');
  static String get interBold => getAssetPath('assets/fonts/Inter_Bold.ttf');
} 