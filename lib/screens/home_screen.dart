import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../blocs/player_bloc/player_bloc.dart';
import '../blocs/surah_bloc/surah_list_bloc.dart';
import '../utils/app_theme.dart';
import '../widgets/mini_player_bar.dart';
import '../widgets/surah_list_tile.dart';
import '../widgets/surah_search_bar.dart';
import 'player_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SurahListBloc>().add(const SurahListFetchRequested());
  }

  void _openPlayer() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => const PlayerScreen(),
        transitionsBuilder: (_, animation, __, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _Header(),
            Expanded(child: _Body(onOpenPlayer: _openPlayer)),
            MiniPlayerBar(onTap: _openPlayer),
            SizedBox(height: MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppTheme.primary, AppTheme.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(Icons.menu_book_rounded,
                    size: 18, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Text('القرآن الكريم',
                  style: AppTheme.arabicText.copyWith(fontSize: 20)),
            ],
          ),
          const SizedBox(height: 4),
          Text('Quran Player', style: AppTheme.displayLarge),
          const SizedBox(height: 2),
          BlocBuilder<SurahListBloc, SurahListState>(
            builder: (context, state) {
              if (state is SurahListLoaded) {
                return Text(
                  '${state.filteredSurahs.length} of 114 Surahs',
                  style: AppTheme.bodyMedium,
                );
              }
              return const SizedBox.shrink();
            },
          ),
          const SizedBox(height: 14),
          const SurahSearchBar(),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final VoidCallback onOpenPlayer;
  const _Body({required this.onOpenPlayer});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SurahListBloc, SurahListState>(
      builder: (context, listState) {
        if (listState is SurahListLoading || listState is SurahListInitial) {
          return _ShimmerList();
        }

        if (listState is SurahListError) {
          return _ErrorView(
            message: listState.message,
            onRetry: () => context
                .read<SurahListBloc>()
                .add(const SurahListFetchRequested()),
          );
        }

        if (listState is SurahListLoaded) {
          if (listState.filteredSurahs.isEmpty) {
            return _EmptySearch(query: listState.searchQuery);
          }

          return BlocBuilder<PlayerBloc, PlayerState>(
            builder: (context, playerState) {
              return ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                itemCount: listState.filteredSurahs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 2),
                itemBuilder: (context, index) {
                  final surah = listState.filteredSurahs[index];
                  final isSelected =
                      playerState.currentSurah?.number == surah.number;
                  final isPlaying = isSelected && playerState.isPlaying;

                  return SurahListTile(
                    surah: surah,
                    isSelected: isSelected,
                    isPlaying: isPlaying,
                    onTap: () {
                      context
                          .read<PlayerBloc>()
                          .add(PlayerPlayRequested(surah));
                      onOpenPlayer();
                    },
                  );
                },
              );
            },
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}

class _ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppTheme.surfaceCard,
      highlightColor: AppTheme.surfaceElevated,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        itemCount: 12,
        itemBuilder: (_, __) => Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          height: 62,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 56, color: AppTheme.error),
            const SizedBox(height: 16),
            Text('Failed to load',
                style: AppTheme.titleLarge.copyWith(color: AppTheme.error)),
            const SizedBox(height: 8),
            Text(message,
                style: AppTheme.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptySearch extends StatelessWidget {
  final String query;
  const _EmptySearch({required this.query});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.search_off_rounded,
              size: 52, color: AppTheme.onSurfaceSecondary),
          const SizedBox(height: 12),
          Text('No results for "$query"', style: AppTheme.bodyMedium),
        ],
      ),
    );
  }
}
