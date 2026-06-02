import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart' as ja;
import '../../models/surah.dart';
import '../../repositories/audio_repository.dart';

part 'player_event.dart';
part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final AudioRepository _repository;

  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<Duration?>? _durationSub;
  StreamSubscription<ja.PlayerState>? _playerStateSub;

  PlayerBloc({required AudioRepository repository})
      : _repository = repository,
        super(const PlayerState()) {
    on<PlayerPlayRequested>(_onPlayRequested);
    on<PlayerPauseRequested>(_onPauseRequested);
    on<PlayerResumeRequested>(_onResumeRequested);
    on<PlayerSeekRequested>(_onSeekRequested);
    on<PlayerPositionUpdated>(_onPositionUpdated);
    on<PlayerDurationUpdated>(_onDurationUpdated);
    on<PlayerPlaybackCompleted>(_onPlaybackCompleted);
    on<PlayerStopRequested>(_onStopRequested);

    _positionSub = _repository.positionStream.listen(
      (pos) => add(PlayerPositionUpdated(pos)),
    );

    _durationSub = _repository.durationStream.listen(
      (dur) => add(PlayerDurationUpdated(dur)),
    );

    _playerStateSub = _repository.playerStateStream.listen(
      (ps) {
        if (ps.processingState == ja.ProcessingState.completed) {
          add(const PlayerPlaybackCompleted());
        }
      },
    );
  }

  Future<void> _onPlayRequested(
    PlayerPlayRequested event,
    Emitter<PlayerState> emit,
  ) async {
    if (state.currentSurah?.number == event.surah.number &&
        state.status == PlaybackStatus.playing) {
      return;
    }

    emit(state.copyWith(
      currentSurah: event.surah,
      status: PlaybackStatus.loading,
      position: Duration.zero,
      clearDuration: true,
      clearError: true,
    ));

    try {
      await _repository.playUrl(event.surah.audioUrl);
      emit(state.copyWith(status: PlaybackStatus.playing));
    } catch (e) {
      emit(state.copyWith(
        status: PlaybackStatus.error,
        errorMessage: 'Failed to load audio: $e',
      ));
    }
  }

  Future<void> _onPauseRequested(
    PlayerPauseRequested event,
    Emitter<PlayerState> emit,
  ) async {
    if (state.status != PlaybackStatus.playing) return;
    await _repository.pause();
    emit(state.copyWith(status: PlaybackStatus.paused));
  }

  Future<void> _onResumeRequested(
    PlayerResumeRequested event,
    Emitter<PlayerState> emit,
  ) async {
    if (state.status != PlaybackStatus.paused) return;
    await _repository.resume();
    emit(state.copyWith(status: PlaybackStatus.playing));
  }

  Future<void> _onSeekRequested(
    PlayerSeekRequested event,
    Emitter<PlayerState> emit,
  ) async {
    await _repository.seekTo(event.position);
    emit(state.copyWith(position: event.position));
  }

  void _onPositionUpdated(
    PlayerPositionUpdated event,
    Emitter<PlayerState> emit,
  ) =>
      emit(state.copyWith(position: event.position));

  void _onDurationUpdated(
    PlayerDurationUpdated event,
    Emitter<PlayerState> emit,
  ) =>
      emit(state.copyWith(duration: event.duration));

  void _onPlaybackCompleted(
    PlayerPlaybackCompleted event,
    Emitter<PlayerState> emit,
  ) =>
      emit(state.copyWith(
        status: PlaybackStatus.completed,
        position: state.duration ?? Duration.zero,
      ));

  Future<void> _onStopRequested(
    PlayerStopRequested event,
    Emitter<PlayerState> emit,
  ) async {
    await _repository.stop();
    emit(const PlayerState());
  }

  @override
  Future<void> close() async {
    await _positionSub?.cancel();
    await _durationSub?.cancel();
    await _playerStateSub?.cancel();
    await _repository.dispose();
    return super.close();
  }
}
