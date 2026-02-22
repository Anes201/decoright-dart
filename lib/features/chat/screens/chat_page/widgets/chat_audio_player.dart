import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:decoright/core/config/supabase_config.dart';
import 'package:decoright/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class ChatAudioPlayer extends StatefulWidget {
  final String audioPath;
  final bool isLocal;
  final bool isUserMessage;

  const ChatAudioPlayer({
    super.key,
    required this.audioPath,
    required this.isLocal,
    required this.isUserMessage,
  });

  @override
  State<ChatAudioPlayer> createState() => _ChatAudioPlayerState();
}

class _ChatAudioPlayerState extends State<ChatAudioPlayer> {
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initAudio();
  }

  Future<void> _initAudio() async {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) {
        setState(() {
          duration = newDuration;
        });
      }
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() {
          position = newPosition;
        });
      }
    });

    // We don't auto-load to save resources, load on play
  }

  Future<void> _playPause() async {
    if (isPlaying) {
      await _audioPlayer.pause();
    } else {
      if (!isLoaded) {
         try {
           if (widget.isLocal) {
             await _audioPlayer.setSourceDeviceFile(widget.audioPath);
           } else {
             final signedUrl = await SupabaseConfig.client.storage
                 .from('request-attachments')
                 .createSignedUrl(widget.audioPath, 3600); // 1 hour validity
             await _audioPlayer.setSourceUrl(signedUrl);
           }
           isLoaded = true;
         } catch(e) {
           debugPrint('Error loading audio: $e');
           // Show error?
           return;
         }
      }
      await _audioPlayer.resume();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200, // Fixed width for consistency
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
              color: widget.isUserMessage ? Colors.white : TColors.primary,
              size: 32,
            ),
            onPressed: _playPause,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                    trackHeight: 2,
                    activeTrackColor: widget.isUserMessage ? Colors.white : TColors.primary,
                    inactiveTrackColor: widget.isUserMessage 
                        ? Colors.white.withOpacity(0.3) 
                        : TColors.primary.withOpacity(0.3),
                    thumbColor: widget.isUserMessage ? Colors.white : TColors.primary,
                  ),
                  child: Slider(
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    value: position.inSeconds.toDouble(),
                    onChanged: (value) async {
                      final position = Duration(seconds: value.toInt());
                      await _audioPlayer.seek(position);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatDuration(position),
                        style: TextStyle(
                          fontSize: 10,
                          color: widget.isUserMessage ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      Text(
                        _formatDuration(duration),
                        style: TextStyle(
                          fontSize: 10,
                          color: widget.isUserMessage ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
