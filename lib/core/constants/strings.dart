class AppStrings {
  AppStrings._();

  static const String appName = 'CardDue';
  static const String appDescription = 'Premium Credit Card Bill Reminder';

  // Sembast Store Names
  static const String cardStoreName = 'credit_cards';
  static const String paymentStoreName = 'payments';

  // Shared Preferences / Simple Local Storage Keys
  static const String settingsStoreName = 'settings';
  static const String themeModeKey = 'theme_mode';
  static const String isFirstRunKey = 'is_first_run';

  // Card Types
  static const String typeVisa = 'Visa';
  static const String typeMastercard = 'Mastercard';
  static const String typeAmex = 'American Express';
  static const String typeDiscover = 'Discover';
  static const String typeRuPay = 'RuPay';
  static const String typeOther = 'Other';

  static const List<String> cardTypes = [
    typeVisa,
    typeMastercard,
    typeAmex,
    typeDiscover,
    typeRuPay,
    typeOther,
  ];

  // Card Colors
  static const String colorCarbon = 'Carbon';
  static const String colorSapphire = 'Sapphire';
  static const String colorEmerald = 'Emerald';
  static const String colorAmethyst = 'Amethyst';
  static const String colorCrimson = 'Crimson';
  static const String colorSunset = 'Sunset';
  static const String colorRoseGold = 'RoseGold';

  static const List<String> cardColors = [
    colorCarbon,
    colorSapphire,
    colorEmerald,
    colorAmethyst,
    colorCrimson,
    colorSunset,
    colorRoseGold,
  ];
}
