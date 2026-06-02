part of 'player_bloc.dart';

enum PlaybackStatus { idle, loading, playing, paused, completed, error }

class PlayerState extends Equatable {
  final Surah? currentSurah;
  final PlaybackStatus status;
  final Duration position;
  final Duration? duration;
  final String? errorMessage;

  const PlayerState({
    this.currentSurah,
    this.status = PlaybackStatus.idle,
    this.position = Duration.zero,
    this.duration,
    this.errorMessage,
  });

  bool get isPlaying => status == PlaybackStatus.playing;
  bool get isLoading => status == PlaybackStatus.loading;

  double get progress {
    if (duration == null || duration!.inMilliseconds == 0) return 0.0;
    return (position.inMilliseconds / duration!.inMilliseconds).clamp(0.0, 1.0);
  }

  PlayerState copyWith({
    Surah? currentSurah,
    PlaybackStatus? status,
    Duration? position,
    Duration? duration,
    String? errorMessage,
    bool clearError = false,
    bool clearDuration = false,
    bool clearSurah = false,
  }) {
    return PlayerState(
      currentSurah: clearSurah ? null : (currentSurah ?? this.currentSurah),
      status: status ?? this.status,
      position: position ?? this.position,
      duration: clearDuration ? null : (duration ?? this.duration),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props =>
      [currentSurah, status, position, duration, errorMessage];
}
