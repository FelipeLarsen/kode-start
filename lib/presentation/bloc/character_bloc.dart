import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/character_repository.dart';
import 'character_event.dart';
import 'character_state.dart';

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  final CharacterRepository characterRepository;
  int _page = 1;
  String? _currentName;

  CharacterBloc({required this.characterRepository}) : super(CharacterInitial()) {
    on<FetchCharacters>(_onFetchCharacters);
    on<FetchMoreCharacters>(_onFetchMoreCharacters);
  }

  Future<void> _onFetchCharacters(FetchCharacters event, Emitter<CharacterState> emit) async {
    emit(CharacterLoading());
    _page = 1;
    _currentName = event.name;
    try {
      final response = await characterRepository.getCharacters(_page, _currentName);
      emit(CharacterLoaded(
        characters: response.results,
        hasReachedMax: response.info.next == null,
      ));
    } catch (e) {
      emit(const CharacterError("Falha ao buscar personagens."));
    }
  }

  Future<void> _onFetchMoreCharacters(FetchMoreCharacters event, Emitter<CharacterState> emit) async {
    if (state is CharacterLoaded) {
      final currentState = state as CharacterLoaded;
      if (currentState.hasReachedMax) return;

      _page++;
      try {
        final response = await characterRepository.getCharacters(_page, _currentName);
        emit(CharacterLoaded(
          characters: currentState.characters + response.results,
          hasReachedMax: response.info.next == null,
        ));
      } catch (e) { 
        emit(const CharacterError("Falha ao buscar mais personagens."));
      }
    }
  }
}