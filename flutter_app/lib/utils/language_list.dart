import '../models/language.dart';

class LanguageList {
  static const List<Language> languages = [
    // Popular languages first
    Language(code: 'en', name: 'English', nativeName: 'English'),
    Language(code: 'es', name: 'Spanish', nativeName: 'Español'),
    Language(code: 'fr', name: 'French', nativeName: 'Français'),
    Language(code: 'de', name: 'German', nativeName: 'Deutsch'),
    Language(code: 'it', name: 'Italian', nativeName: 'Italiano'),
    Language(code: 'pt', name: 'Portuguese', nativeName: 'Português'),
    Language(code: 'ru', name: 'Russian', nativeName: 'Русский'),
    Language(code: 'zh', name: 'Chinese', nativeName: '中文'),
    Language(code: 'ja', name: 'Japanese', nativeName: '日本語'),
    Language(code: 'ko', name: 'Korean', nativeName: '한국어'),
    Language(code: 'ar', name: 'Arabic', nativeName: 'العربية'),
    Language(code: 'hi', name: 'Hindi', nativeName: 'हिन्दी'),
    
    // Indian languages
    Language(code: 'te', name: 'Telugu', nativeName: 'తెలుగు'),
    Language(code: 'ta', name: 'Tamil', nativeName: 'தமிழ்'),
    Language(code: 'bn', name: 'Bengali', nativeName: 'বাংলা'),
    Language(code: 'gu', name: 'Gujarati', nativeName: 'ગુજરાતી'),
    Language(code: 'kn', name: 'Kannada', nativeName: 'ಕನ್ನಡ'),
    Language(code: 'ml', name: 'Malayalam', nativeName: 'മലയാളം'),
    Language(code: 'mr', name: 'Marathi', nativeName: 'मराठी'),
    Language(code: 'pa', name: 'Punjabi', nativeName: 'ਪੰਜਾਬੀ'),
    Language(code: 'or', name: 'Odia', nativeName: 'ଓଡ଼ିଆ'),
    Language(code: 'as', name: 'Assamese', nativeName: 'অসমীয়া'),
    Language(code: 'ur', name: 'Urdu', nativeName: 'اردو'),
    
    // European languages
    Language(code: 'nl', name: 'Dutch', nativeName: 'Nederlands'),
    Language(code: 'sv', name: 'Swedish', nativeName: 'Svenska'),
    Language(code: 'no', name: 'Norwegian', nativeName: 'Norsk'),
    Language(code: 'da', name: 'Danish', nativeName: 'Dansk'),
    Language(code: 'fi', name: 'Finnish', nativeName: 'Suomi'),
    Language(code: 'pl', name: 'Polish', nativeName: 'Polski'),
    Language(code: 'cs', name: 'Czech', nativeName: 'Čeština'),
    Language(code: 'sk', name: 'Slovak', nativeName: 'Slovenčina'),
    Language(code: 'hu', name: 'Hungarian', nativeName: 'Magyar'),
    Language(code: 'ro', name: 'Romanian', nativeName: 'Română'),
    Language(code: 'bg', name: 'Bulgarian', nativeName: 'Български'),
    Language(code: 'hr', name: 'Croatian', nativeName: 'Hrvatski'),
    Language(code: 'sr', name: 'Serbian', nativeName: 'Српски'),
    Language(code: 'sl', name: 'Slovenian', nativeName: 'Slovenščina'),
    Language(code: 'et', name: 'Estonian', nativeName: 'Eesti'),
    Language(code: 'lv', name: 'Latvian', nativeName: 'Latviešu'),
    Language(code: 'lt', name: 'Lithuanian', nativeName: 'Lietuvių'),
    Language(code: 'el', name: 'Greek', nativeName: 'Ελληνικά'),
    Language(code: 'tr', name: 'Turkish', nativeName: 'Türkçe'),
    
    // Other Asian languages
    Language(code: 'th', name: 'Thai', nativeName: 'ไทย'),
    Language(code: 'vi', name: 'Vietnamese', nativeName: 'Tiếng Việt'),
    Language(code: 'id', name: 'Indonesian', nativeName: 'Bahasa Indonesia'),
    Language(code: 'ms', name: 'Malay', nativeName: 'Bahasa Melayu'),
    Language(code: 'tl', name: 'Filipino', nativeName: 'Filipino'),
    Language(code: 'my', name: 'Burmese', nativeName: 'မြန်မာ'),
    Language(code: 'km', name: 'Khmer', nativeName: 'ខ្មែរ'),
    Language(code: 'lo', name: 'Lao', nativeName: 'ລາວ'),
    Language(code: 'si', name: 'Sinhala', nativeName: 'සිංහල'),
    Language(code: 'ne', name: 'Nepali', nativeName: 'नेपाली'),
    
    // African languages
    Language(code: 'sw', name: 'Swahili', nativeName: 'Kiswahili'),
    Language(code: 'zu', name: 'Zulu', nativeName: 'isiZulu'),
    Language(code: 'xh', name: 'Xhosa', nativeName: 'isiXhosa'),
    Language(code: 'af', name: 'Afrikaans', nativeName: 'Afrikaans'),
    Language(code: 'am', name: 'Amharic', nativeName: 'አማርኛ'),
    
    // Other languages
    Language(code: 'he', name: 'Hebrew', nativeName: 'עברית'),
    Language(code: 'fa', name: 'Persian', nativeName: 'فارسی'),
    Language(code: 'uk', name: 'Ukrainian', nativeName: 'Українська'),
    Language(code: 'be', name: 'Belarusian', nativeName: 'Беларуская'),
    Language(code: 'ka', name: 'Georgian', nativeName: 'ქართული'),
    Language(code: 'hy', name: 'Armenian', nativeName: 'Հայերեն'),
    Language(code: 'az', name: 'Azerbaijani', nativeName: 'Azərbaycan'),
    Language(code: 'kk', name: 'Kazakh', nativeName: 'Қазақ'),
    Language(code: 'ky', name: 'Kyrgyz', nativeName: 'Кыргыз'),
    Language(code: 'uz', name: 'Uzbek', nativeName: 'Oʻzbek'),
    Language(code: 'tg', name: 'Tajik', nativeName: 'Тоҷикӣ'),
    Language(code: 'mn', name: 'Mongolian', nativeName: 'Монгол'),
  ];

  // Get language by code
  static Language? getByCode(String code) {
    try {
      return languages.firstWhere((lang) => lang.code == code);
    } catch (e) {
      return null;
    }
  }

  // Search languages by name
  static List<Language> search(String query) {
    if (query.isEmpty) return languages;
    
    final lowerQuery = query.toLowerCase();
    return languages.where((lang) =>
      lang.name.toLowerCase().contains(lowerQuery) ||
      lang.nativeName.toLowerCase().contains(lowerQuery) ||
      lang.code.toLowerCase().contains(lowerQuery)
    ).toList();
  }
}