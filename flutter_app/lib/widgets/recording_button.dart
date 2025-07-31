import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../services/audio_service.dart';

class RecordingButton extends StatefulWidget {
  final AudioService audioService;
  final Function(File) onRecordingComplete;

  const RecordingButton({
    super.key,
    required this.audioService,
    required this.onRecordingComplete,
  });

  @override
  State<RecordingButton> createState() => _RecordingButtonState();
}

class _RecordingButtonState extends State<RecordingButton>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _scaleController;
  Duration _recordingDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes);
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Future<void> _toggleRecording() async {
    if (widget.audioService.isRecording) {
      // Stop recording
      _pulseController.stop();
      _scaleController.reverse();
      
      final audioFile = await widget.audioService.stopRecording();
      if (audioFile != null) {
        widget.onRecordingComplete(audioFile);
      } else {
        _showError('Failed to save recording');
      }
      
      setState(() {
        _recordingDuration = Duration.zero;
      });
    } else {
      // Start recording
      final success = await widget.audioService.startRecording();
      if (success) {
        _pulseController.repeat();
        _scaleController.forward();
        _startDurationTimer();
      } else {
        _showError('Failed to start recording. Please check microphone permissions.');
      }
    }
  }

  void _startDurationTimer() {
    // Listen to recording progress
    widget.audioService.recordingStream?.listen((event) {
      if (mounted && widget.audioService.isRecording) {
        setState(() {
          _recordingDuration = event.duration;
        });
      }
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isRecording = widget.audioService.isRecording;
    
    return Column(
      children: [
        // Recording Duration
        if (isRecording)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.fiber_manual_record,
                  color: Theme.of(context).colorScheme.error,
                  size: 12,
                ),
                const SizedBox(width: 8),
                Text(
                  'Recording: ${_formatDuration(_recordingDuration)}',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        
        const SizedBox(height: 16),

        // Recording Button
        GestureDetector(
          onTapDown: (_) => _scaleController.forward(),
          onTapUp: (_) => _scaleController.reverse(),
          onTapCancel: () => _scaleController.reverse(),
          onTap: _toggleRecording,
          child: AnimatedBuilder(
            animation: Listenable.merge([_pulseController, _scaleController]),
            builder: (context, child) {
              final pulseValue = _pulseController.value;
              final scaleValue = 1.0 - (_scaleController.value * 0.1);
              
              return Transform.scale(
                scale: scaleValue,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isRecording
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.primary,
                    boxShadow: [
                      BoxShadow(
                        color: (isRecording
                                ? Theme.of(context).colorScheme.error
                                : Theme.of(context).colorScheme.primary)
                            .withOpacity(0.3),
                        blurRadius: 20 + (pulseValue * 10),
                        spreadRadius: 5 + (pulseValue * 5),
                      ),
                    ],
                  ),
                  child: Icon(
                    isRecording ? Icons.stop : MdiIcons.microphone,
                    size: 48,
                    color: isRecording
                        ? Theme.of(context).colorScheme.onError
                        : Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              );
            },
          ),
        ),
        
        const SizedBox(height: 16),

        // Instructions
        Text(
          isRecording 
              ? 'Tap to stop recording'
              : 'Tap to start recording',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),

        // Playback Button (if recording exists and not currently recording)
        if (!isRecording && widget.audioService.currentRecordingPath != null)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: ElevatedButton.icon(
              onPressed: widget.audioService.isPlaying
                  ? widget.audioService.stopPlaying
                  : () => widget.audioService.playRecording(
                        widget.audioService.currentRecordingPath!,
                      ),
              icon: Icon(
                widget.audioService.isPlaying
                    ? Icons.stop
                    : Icons.play_arrow,
              ),
              label: Text(
                widget.audioService.isPlaying
                    ? 'Stop Playback'
                    : 'Play Recording',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
      ],
    );
  }
}