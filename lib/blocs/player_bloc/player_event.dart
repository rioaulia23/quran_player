part of 'player_bloc.dart';

abstract class PlayerEvent extends Equatable {
  const PlayerEvent();

  @override
  List<Object?> get props => [];
}

class PlayerPlayRequested extends PlayerEvent {
  final Surah surah;
  const PlayerPlayRequested(this.surah);

  @override
  List<Object?> get props => [surah];
}

class PlayerPauseRequested extends PlayerEvent {
  const PlayerPauseRequested();
}

class PlayerResumeRequested extends PlayerEvent {
  const PlayerResumeRequested();
}

class PlayerSeekRequested extends PlayerEvent {
  final Duration position;
  const PlayerSeekRequested(this.position);

  @override
  List<Object?> get props => [position];
}

class PlayerPositionUpdated extends PlayerEvent {
  final Duration position;
  const PlayerPositionUpdated(this.position);

  @override
  List<Object?> get props => [position];
}

class PlayerDurationUpdated extends PlayerEvent {
  final Duration? duration;
  const PlayerDurationUpdated(this.duration);

  @override
  List<Object?> get props => [duration];
}

class PlayerPlaybackCompleted extends PlayerEvent {
  const PlayerPlaybackCompleted();
}

class PlayerStopRequested extends PlayerEvent {
  const PlayerStopRequested();
}
