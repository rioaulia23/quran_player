import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/player_bloc/player_bloc.dart';
import '../utils/app_theme.dart';
import '../widgets/player_controls.dart';

class PlayerScreen extends StatelessWidget {
  const PlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: BlocBuilder<PlayerBloc, PlayerState>(
        builder: (context, state) {
          return SafeArea(
            child: Column(
              children: [
                _TopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 32),
                        _AlbumArt(surahNumber: state.currentSurah?.number),
                        const SizedBox(height: 32),
                        _SurahInfo(state: state),
                        const SizedBox(height: 40),
                        const PlayerControls(),
                        const SizedBox(height: 48),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 30),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Text(
              'Now Playing',
              textAlign: TextAlign.center,
              style: AppTheme.caption.copyWith(
                letterSpacing: 1.2,
                fontSize: 12,
                color: AppTheme.onSurfaceSecondary,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}

class _AlbumArt extends StatelessWidget {
  final int? surahNumber;
  const _AlbumArt({this.surahNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [AppTheme.primaryDark, AppTheme.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.35),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.12),
                  width: 1.5,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.08),
                  width: 1.5,
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.auto_stories_rounded,
                size: 72,
                color: Colors.white.withOpacity(0.9),
              ),
              if (surahNumber != null) ...[
                const SizedBox(height: 12),
                Text(
                  'Surah $surahNumber',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _SurahInfo extends StatelessWidget {
  final PlayerState state;
  const _SurahInfo({required this.state});

  @override
  Widget build(BuildContext context) {
    if (state.currentSurah == null) {
      return Text('Select a Surah to play', style: AppTheme.bodyMedium);
    }

    final surah = state.currentSurah!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          Text(
            surah.name,
            style: AppTheme.arabicText.copyWith(fontSize: 32),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            surah.englishName,
            style: AppTheme.titleLarge.copyWith(fontSize: 22),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            '${surah.englishNameTranslation}  ·  ${surah.numberOfAyahs} Ayahs',
            style: AppTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
            ),
            child: Text(
              surah.revelationType,
              style: AppTheme.caption.copyWith(
                color: AppTheme.primaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (state.status == PlaybackStatus.error &&
              state.errorMessage != null) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline_rounded,
                    color: AppTheme.error, size: 16),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    state.errorMessage!,
                    style: AppTheme.caption.copyWith(color: AppTheme.error),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
