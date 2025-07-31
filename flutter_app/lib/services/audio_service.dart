import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class AudioService {
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  bool _isRecording = false;
  bool _isPlaying = false;
  String? _currentRecordingPath;

  // Getters
  bool get isRecording => _isRecording;
  bool get isPlaying => _isPlaying;
  String? get currentRecordingPath => _currentRecordingPath;

  /// Initialize the audio service
  Future<void> initialize() async {
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();

    await _recorder!.openRecorder();
    await _player!.openPlayer();

    debugPrint('Audio service initialized');
  }

  /// Dispose the audio service
  Future<void> dispose() async {
    await _recorder?.closeRecorder();
    await _player?.closePlayer();
    _recorder = null;
    _player = null;
    debugPrint('Audio service disposed');
  }

  /// Request microphone permission
  Future<bool> requestPermission() async {
    final status = await Permission.microphone.request();
    debugPrint('Microphone permission status: $status');
    return status == PermissionStatus.granted;
  }

  /// Check if microphone permission is granted
  Future<bool> hasPermission() async {
    final status = await Permission.microphone.status;
    return status == PermissionStatus.granted;
  }

  /// Start recording audio
  Future<bool> startRecording() async {
    try {
      if (_recorder == null) {
        throw Exception('Recorder not initialized');
      }

      if (_isRecording) {
        debugPrint('Already recording');
        return false;
      }

      // Check permission
      if (!await hasPermission()) {
        if (!await requestPermission()) {
          throw Exception('Microphone permission denied');
        }
      }

      // Get temporary directory for recording
      final directory = await getTemporaryDirectory();
      final fileName = 'recording_${DateTime.now().millisecondsSinceEpoch}.aac';
      _currentRecordingPath = '${directory.path}/$fileName';

      debugPrint('Starting recording to: $_currentRecordingPath');

      await _recorder!.startRecorder(
        toFile: _currentRecordingPath,
        codec: Codec.aacADTS,
        bitRate: 128000,
        sampleRate: 44100,
      );

      _isRecording = true;
      debugPrint('Recording started successfully');
      return true;
    } catch (e) {
      debugPrint('Error starting recording: $e');
      _isRecording = false;
      return false;
    }
  }

  /// Stop recording audio
  Future<File?> stopRecording() async {
    try {
      if (_recorder == null || !_isRecording) {
        debugPrint('Not currently recording');
        return null;
      }

      await _recorder!.stopRecorder();
      _isRecording = false;

      if (_currentRecordingPath != null) {
        final file = File(_currentRecordingPath!);
        if (await file.exists()) {
          debugPrint('Recording saved to: $_currentRecordingPath');
          return file;
        } else {
          debugPrint('Recording file does not exist');
          return null;
        }
      }

      return null;
    } catch (e) {
      debugPrint('Error stopping recording: $e');
      _isRecording = false;
      return null;
    }
  }

  /// Play recorded audio
  Future<bool> playRecording(String filePath) async {
    try {
      if (_player == null) {
        throw Exception('Player not initialized');
      }

      if (_isPlaying) {
        await _player!.stopPlayer();
      }

      debugPrint('Playing audio from: $filePath');
      
      await _player!.startPlayer(
        fromURI: filePath,
        whenFinished: () {
          _isPlaying = false;
          debugPrint('Playback finished');
        },
      );

      _isPlaying = true;
      return true;
    } catch (e) {
      debugPrint('Error playing audio: $e');
      return false;
    }
  }

  /// Stop playing audio
  Future<void> stopPlaying() async {
    try {
      if (_player != null && _isPlaying) {
        await _player!.stopPlayer();
        _isPlaying = false;
        debugPrint('Playback stopped');
      }
    } catch (e) {
      debugPrint('Error stopping playback: $e');
    }
  }

  /// Delete the current recording file
  Future<void> deleteCurrentRecording() async {
    try {
      if (_currentRecordingPath != null) {
        final file = File(_currentRecordingPath!);
        if (await file.exists()) {
          await file.delete();
          debugPrint('Deleted recording: $_currentRecordingPath');
        }
        _currentRecordingPath = null;
      }
    } catch (e) {
      debugPrint('Error deleting recording: $e');
    }
  }

  /// Get recording duration (if available)
  Stream<RecordingDisposition>? get recordingStream {
    return _recorder?.onProgress;
  }
}