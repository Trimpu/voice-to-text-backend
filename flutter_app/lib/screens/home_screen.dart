import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../providers/app_state.dart';
import '../services/api_service.dart';
import '../services/audio_service.dart';
import '../widgets/language_selector.dart';
import '../widgets/recording_button.dart';
import '../widgets/text_result_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  late final ApiService _apiService;
  late final AudioService _audioService;
  File? _selectedFile;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _apiService = ApiService();
    _audioService = AudioService();
    _initializeServices();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _audioService.dispose();
    super.dispose();
  }

  Future<void> _initializeServices() async {
    try {
      await _audioService.initialize();
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      debugPrint('Error initializing services: $e');
      if (mounted) {
        _showError('Failed to initialize audio services: $e');
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {},
        ),
      ),
    );
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = File(result.files.first.path!);
        setState(() {
          _selectedFile = file;
        });
        _showSuccess('Audio file selected: ${result.files.first.name}');
      }
    } catch (e) {
      _showError('Error picking file: $e');
    }
  }

  Future<void> _transcribeAudio(File audioFile) async {
    final appState = Provider.of<AppState>(context, listen: false);
    
    try {
      appState.setLoading(true);
      appState.clearError();

      final result = await _apiService.transcribeAudio(
        audioFile: audioFile,
        targetLanguage: appState.selectedLanguage.code,
      );

      appState.setTranscribedText(result.originalText);
      appState.setTranslatedText(result.translatedText);
      
      _showSuccess('Transcription completed successfully!');
    } catch (e) {
      appState.setError(e.toString());
      _showError('Transcription failed: $e');
    } finally {
      appState.setLoading(false);
    }
  }

  Future<void> _onRecordingComplete(File audioFile) async {
    setState(() {
      _selectedFile = audioFile;
    });
    
    // Automatically transcribe the recorded audio
    await _transcribeAudio(audioFile);
  }

  void _clearAll() {
    final appState = Provider.of<AppState>(context, listen: false);
    appState.clearText();
    setState(() {
      _selectedFile = null;
    });
    _audioService.deleteCurrentRecording();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice to Text'),
        actions: [
          Consumer<AppState>(
            builder: (context, appState, child) {
              return IconButton(
                icon: Icon(
                  appState.isDarkMode 
                    ? Icons.light_mode 
                    : Icons.dark_mode
                ),
                onPressed: appState.toggleTheme,
                tooltip: 'Toggle theme',
              );
            },
          ),
        ],
      ),
      body: !_isInitialized
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Initializing audio services...'),
                ],
              ),
            )
          : Consumer<AppState>(
              builder: (context, appState, child) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Language Selector
                      const LanguageSelector(),
                      const SizedBox(height: 24),

                      // Recording Section
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    MdiIcons.microphone,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Voice Recording',
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              RecordingButton(
                                audioService: _audioService,
                                onRecordingComplete: _onRecordingComplete,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // File Upload Section
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    MdiIcons.fileMusic,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Upload Audio File',
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                onPressed: appState.isLoading ? null : _pickFile,
                                icon: const Icon(Icons.upload_file),
                                label: const Text('Choose Audio File'),
                              ),
                              if (_selectedFile != null) ...[
                                const SizedBox(height: 8),
                                Text(
                                  'Selected: ${_selectedFile!.path.split('/').last}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton.icon(
                                  onPressed: appState.isLoading 
                                      ? null 
                                      : () => _transcribeAudio(_selectedFile!),
                                  icon: const Icon(Icons.transcribe),
                                  label: const Text('Transcribe'),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Loading Indicator
                      if (appState.isLoading)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              children: [
                                SpinKitWave(
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 30,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Processing audio...',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Error Display
                      if (appState.errorMessage.isNotEmpty)
                        Card(
                          color: Theme.of(context).colorScheme.errorContainer,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.error,
                                      color: Theme.of(context).colorScheme.error,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        appState.errorMessage,
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.error,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: appState.clearError,
                                  child: const Text('Dismiss'),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Results Section
                      if (appState.transcribedText.isNotEmpty ||
                          appState.translatedText.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        TextResultCard(
                          transcribedText: appState.transcribedText,
                          translatedText: appState.translatedText,
                          targetLanguage: appState.selectedLanguage,
                        ),
                      ],

                      // Clear Button
                      if (appState.transcribedText.isNotEmpty ||
                          appState.translatedText.isNotEmpty ||
                          _selectedFile != null) ...[
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: appState.isLoading ? null : _clearAll,
                          icon: const Icon(Icons.clear),
                          label: const Text('Clear All'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],

                      const SizedBox(height: 32),
                    ],
                  ),
                );
              },
            ),
    );
  }
}