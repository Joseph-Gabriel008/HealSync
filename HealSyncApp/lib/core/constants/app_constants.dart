class AppConstants {
  static const appName = 'HealSync';

  static const zegoAppId = int.fromEnvironment(
    'ZEGO_APP_ID',
    defaultValue: 837098801,
  );

  static const zegoAppSign = String.fromEnvironment(
    'ZEGO_APP_SIGN',
    defaultValue:
        '6f3f4d48258ec36558411e322be49d16d6c160845b679e12e6518ec2d9283a69',
  );

  static const zegoToken = String.fromEnvironment(
    'ZEGO_TOKEN',
    defaultValue: '',
  );
}
