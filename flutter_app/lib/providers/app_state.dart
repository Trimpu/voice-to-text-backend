import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/language.dart';
import '../utils/language_list.dart';

class AppState extends ChangeNotifier {
  bool _isDarkMode = false;
  Language _selectedLanguage = LanguageList.languages[0]; // Default to English
  String _transcribedText = '';
  String _translatedText = '';
  bool _isLoading = false;
  String _errorMessage = '';

  // Getters
  bool get isDarkMode => _isDarkMode;
  Language get selectedLanguage => _selectedLanguage;
  String get transcribedText => _transcribedText;
  String get translatedText => _translatedText;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  AppState() {
    _loadPreferences();
  }

  // Load saved preferences
  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    
    final savedLanguageCode = prefs.getString('selectedLanguage') ?? 'en';
    _selectedLanguage = LanguageList.languages.firstWhere(
      (lang) => lang.code == savedLanguageCode,
      orElse: () => LanguageList.languages[0],
    );
    
    notifyListeners();
  }

  // Toggle theme
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  // Set selected language
  Future<void> setSelectedLanguage(Language language) async {
    _selectedLanguage = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', language.code);
    notifyListeners();
  }

  // Set transcribed text
  void setTranscribedText(String text) {
    _transcribedText = text;
    notifyListeners();
  }

  // Set translated text
  void setTranslatedText(String text) {
    _translatedText = text;
    notifyListeners();
  }

  // Set loading state
  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Set error message
  void setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  // Clear all text
  void clearText() {
    _transcribedText = '';
    _translatedText = '';
    _errorMessage = '';
    notifyListeners();
  }
}