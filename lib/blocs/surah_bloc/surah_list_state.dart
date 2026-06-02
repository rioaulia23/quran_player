part of 'surah_list_bloc.dart';

abstract class SurahListState extends Equatable {
  const SurahListState();

  @override
  List<Object?> get props => [];
}

class SurahListInitial extends SurahListState {
  const SurahListInitial();
}

class SurahListLoading extends SurahListState {
  const SurahListLoading();
}

class SurahListLoaded extends SurahListState {
  final List<Surah> allSurahs;
  final List<Surah> filteredSurahs;
  final String searchQuery;

  const SurahListLoaded({
    required this.allSurahs,
    required this.filteredSurahs,
    this.searchQuery = '',
  });

  SurahListLoaded copyWith({
    List<Surah>? allSurahs,
    List<Surah>? filteredSurahs,
    String? searchQuery,
  }) {
    return SurahListLoaded(
      allSurahs: allSurahs ?? this.allSurahs,
      filteredSurahs: filteredSurahs ?? this.filteredSurahs,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [allSurahs, filteredSurahs, searchQuery];
}

class SurahListError extends SurahListState {
  final String message;

  const SurahListError(this.message);

  @override
  List<Object?> get props => [message];
}
