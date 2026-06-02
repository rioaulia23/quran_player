import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/player_bloc/player_bloc.dart';
import '../utils/app_theme.dart';
import '../utils/duration_formatter.dart';

class PlayerControls extends StatelessWidget {
  const PlayerControls({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerState>(
      builder: (context, state) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ProgressSection(state: state),
            const SizedBox(height: 24),
            _ButtonRow(state: state),
          ],
        );
      },
    );
  }
}

class _ProgressSection extends StatelessWidget {
  final PlayerState state;
  const _ProgressSection({required this.state});

  @override
  Widget build(BuildContext context) {
    final duration = state.duration ?? Duration.zero;

    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
          ),
          child: Slider(
            value: state.progress,
            onChanged: state.currentSurah == null
                ? null
                : (value) {
                    if (duration.inMilliseconds > 0) {
                      final target = Duration(
                        milliseconds: (value * duration.inMilliseconds).round(),
                      );
                      context
                          .read<PlayerBloc>()
                          .add(PlayerSeekRequested(target));
                    }
                  },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatDuration(state.position),
                style: AppTheme.caption.copyWith(fontSize: 12),
              ),
              Text(
                formatDuration(duration),
                style: AppTheme.caption.copyWith(fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ButtonRow extends StatelessWidget {
  final PlayerState state;
  const _ButtonRow({required this.state});

  void _skip(BuildContext context, Duration delta) {
    final newPos = state.position + delta;
    final duration = state.duration ?? Duration.zero;
    final clamped = newPos.isNegative
        ? Duration.zero
        : newPos > duration
            ? duration
            : newPos;
    context.read<PlayerBloc>().add(PlayerSeekRequested(clamped));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.replay_10_rounded, size: 36),
          color: state.currentSurah == null
              ? AppTheme.onSurfaceSecondary
              : AppTheme.onSurface,
          onPressed: state.currentSurah == null
              ? null
              : () => _skip(context, const Duration(seconds: -10)),
        ),
        const SizedBox(width: 28),
        _MainPlayButton(state: state),
        const SizedBox(width: 28),
        IconButton(
          icon: const Icon(Icons.forward_10_rounded, size: 36),
          color: state.currentSurah == null
              ? AppTheme.onSurfaceSecondary
              : AppTheme.onSurface,
          onPressed: state.currentSurah == null
              ? null
              : () => _skip(context, const Duration(seconds: 10)),
        ),
      ],
    );
  }
}

class _MainPlayButton extends StatelessWidget {
  final PlayerState state;
  const _MainPlayButton({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppTheme.primary.withOpacity(0.2),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: AppTheme.primaryLight,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: state.currentSurah == null
          ? null
          : () {
              if (state.isPlaying) {
                context.read<PlayerBloc>().add(const PlayerPauseRequested());
              } else {
                context.read<PlayerBloc>().add(const PlayerResumeRequested());
              }
            },
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [AppTheme.primary, AppTheme.primaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primary.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Icon(
          state.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          color: Colors.white,
          size: 36,
        ),
      ),
    );
  }
}
