import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/player_bloc/player_bloc.dart';
import '../utils/app_theme.dart';

class MiniPlayerBar extends StatelessWidget {
  final VoidCallback onTap;

  const MiniPlayerBar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerState>(
      builder: (context, state) {
        if (state.currentSurah == null) return const SizedBox.shrink();

        return GestureDetector(
          onTap: onTap,
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: AppTheme.surfaceCard,
              border: const Border(
                top: BorderSide(color: AppTheme.divider, width: 0.5),
              ),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: state.progress,
                  backgroundColor: AppTheme.primary.withOpacity(0.2),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppTheme.primary),
                  minHeight: 2,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                state.currentSurah!.englishName,
                                style: AppTheme.titleMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                state.currentSurah!.name,
                                style: AppTheme.arabicText.copyWith(
                                  fontSize: 14,
                                  color: AppTheme.accent,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _PlayPauseButton(state: state),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PlayPauseButton extends StatelessWidget {
  final PlayerState state;
  const _PlayPauseButton({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.isLoading) {
      return const SizedBox(
        width: 36,
        height: 36,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppTheme.primaryLight,
        ),
      );
    }

    return IconButton(
      icon: Icon(
        state.isPlaying
            ? Icons.pause_circle_filled_rounded
            : Icons.play_circle_filled_rounded,
        color: AppTheme.primaryLight,
        size: 36,
      ),
      onPressed: () {
        if (state.isPlaying) {
          context.read<PlayerBloc>().add(const PlayerPauseRequested());
        } else {
          context.read<PlayerBloc>().add(const PlayerResumeRequested());
        }
      },
    );
  }
}
