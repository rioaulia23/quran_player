import 'package:flutter/material.dart';
import '../models/surah.dart';
import '../utils/app_theme.dart';

class SurahListTile extends StatelessWidget {
  final Surah surah;
  final bool isSelected;
  final bool isPlaying;
  final VoidCallback onTap;

  const SurahListTile({
    super.key,
    required this.surah,
    required this.onTap,
    this.isSelected = false,
    this.isPlaying = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primary.withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: AppTheme.primary.withOpacity(0.3), width: 1)
              : null,
        ),
        child: Row(
          children: [
            _NumberBadge(number: surah.number, isSelected: isSelected),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          surah.englishName,
                          style: AppTheme.titleMedium.copyWith(
                            color: isSelected
                                ? AppTheme.primaryLight
                                : AppTheme.onSurface,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        surah.name,
                        style: AppTheme.arabicText.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${surah.englishNameTranslation}  ·  ${surah.numberOfAyahs} Ayahs  ·  ${surah.revelationType}',
                    style: AppTheme.caption,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (isPlaying)
              const _PlayingIndicator()
            else
              Icon(
                Icons.play_circle_outline_rounded,
                color: isSelected
                    ? AppTheme.primaryLight
                    : AppTheme.onSurfaceSecondary,
                size: 22,
              ),
          ],
        ),
      ),
    );
  }
}

class _NumberBadge extends StatelessWidget {
  final int number;
  final bool isSelected;

  const _NumberBadge({required this.number, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected
            ? AppTheme.primary.withOpacity(0.25)
            : AppTheme.surfaceElevated,
      ),
      alignment: Alignment.center,
      child: Text(
        '$number',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isSelected ? AppTheme.primaryLight : AppTheme.onSurface,
        ),
      ),
    );
  }
}

class _PlayingIndicator extends StatefulWidget {
  const _PlayingIndicator();

  @override
  State<_PlayingIndicator> createState() => _PlayingIndicatorState();
}

class _PlayingIndicatorState extends State<_PlayingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(3, (i) {
            final height = 6.0 +
                12.0 *
                    (0.3 +
                        0.7 *
                            (i == 1
                                ? _controller.value
                                : i == 0
                                    ? 1 - _controller.value
                                    : _controller.value * 0.7));
            return Container(
              width: 3,
              height: height,
              margin: const EdgeInsets.symmetric(horizontal: 1),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight,
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        );
      },
    );
  }
}
