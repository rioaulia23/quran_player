import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../models/surah.dart';
import '../../repositories/quran_repository.dart';

part 'surah_list_event.dart';
part 'surah_list_state.dart';

class SurahListBloc extends Bloc<SurahListEvent, SurahListState> {
  final QuranRepository _repository;

  SurahListBloc({required QuranRepository repository})
      : _repository = repository,
        super(const SurahListInitial()) {
    on<SurahListFetchRequested>(_onFetchRequested);
    on<SurahListSearchChanged>(_onSearchChanged);
    on<SurahListSearchCleared>(_onSearchCleared);
  }

  Future<void> _onFetchRequested(
    SurahListFetchRequested event,
    Emitter<SurahListState> emit,
  ) async {
    emit(const SurahListLoading());
    try {
      final surahs = await _repository.fetchAllSurahs();
      emit(SurahListLoaded(allSurahs: surahs, filteredSurahs: surahs));
    } on QuranRepositoryException catch (e) {
      emit(SurahListError(e.message));
    } catch (e) {
      emit(SurahListError('Unexpected error: $e'));
    }
  }

  void _onSearchChanged(
    SurahListSearchChanged event,
    Emitter<SurahListState> emit,
  ) {
    if (state is! SurahListLoaded) return;
    final current = state as SurahListLoaded;
    final query = event.query.toLowerCase().trim();
    final filtered = query.isEmpty
        ? current.allSurahs
        : current.allSurahs.where((s) {
            return s.englishName.toLowerCase().contains(query) ||
                s.englishNameTranslation.toLowerCase().contains(query) ||
                s.number.toString().contains(query);
          }).toList();

    emit(current.copyWith(filteredSurahs: filtered, searchQuery: event.query));
  }

  void _onSearchCleared(
    SurahListSearchCleared event,
    Emitter<SurahListState> emit,
  ) {
    if (state is! SurahListLoaded) return;
    final current = state as SurahListLoaded;
    emit(current.copyWith(filteredSurahs: current.allSurahs, searchQuery: ''));
  }
}
