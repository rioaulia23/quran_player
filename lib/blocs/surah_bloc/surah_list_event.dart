part of 'surah_list_bloc.dart';

abstract class SurahListEvent extends Equatable {
  const SurahListEvent();

  @override
  List<Object?> get props => [];
}

class SurahListFetchRequested extends SurahListEvent {
  const SurahListFetchRequested();
}

class SurahListSearchChanged extends SurahListEvent {
  final String query;

  const SurahListSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class SurahListSearchCleared extends SurahListEvent {
  const SurahListSearchCleared();
}
