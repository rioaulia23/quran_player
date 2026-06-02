import 'package:just_audio/just_audio.dart' as ja;

class AudioRepository {
  final ja.AudioPlayer _player;

  AudioRepository() : _player = ja.AudioPlayer();

  Stream<ja.PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get bufferedPositionStream => _player.bufferedPositionStream;
  Stream<Duration?> get durationStream => _player.durationStream;

  bool get isPlaying => _player.playing;
  Duration get position => _player.position;
  Duration? get duration => _player.duration;
  ja.ProcessingState get processingState => _player.processingState;

  Future<Duration?> playUrl(String url) async {
    final duration = await _player.setUrl(url);
    await _player.play();
    return duration;
  }

  Future<void> pause() => _player.pause();
  Future<void> resume() => _player.play();
  Future<void> seekTo(Duration position) => _player.seek(position);
  Future<void> stop() => _player.stop();
  Future<void> dispose() => _player.dispose();
}
