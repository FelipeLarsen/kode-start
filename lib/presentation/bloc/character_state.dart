// ========== lib/presentation/bloc/character_state.dart ==========

import 'package:equatable/equatable.dart';
import '../../data/models/character_model.dart';

// A classe base para todos os estados que a UI pode ter.
abstract class CharacterState extends Equatable {
  const CharacterState();
  @override
  List<Object?> get props => [];
}

// O estado inicial, antes que qualquer coisa aconteça.
class CharacterInitial extends CharacterState {}

// O estado que representa que os dados estão sendo carregados (ex: mostra um CircularProgressIndicator).
class CharacterLoading extends CharacterState {}

// O estado que representa que os dados foram carregados com sucesso.
class CharacterLoaded extends CharacterState {
  // A lista de personagens a ser exibida.
  final List<CharacterModel> characters;
  // Um booleano que nos diz se chegamos ao final da lista (para parar de mostrar o loading da paginação).
  final bool hasReachedMax;

  const CharacterLoaded({required this.characters, this.hasReachedMax = false});

  // Um método auxiliar para criar uma cópia deste estado com algumas propriedades alteradas.
  // É útil para a paginação, onde queremos manter os personagens existentes e adicionar novos.
  CharacterLoaded copyWith({
    List<CharacterModel>? characters,
    bool? hasReachedMax,
  }) {
    return CharacterLoaded(
      characters: characters ?? this.characters,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  // As propriedades usadas para comparação. A UI só será reconstruída se
  // a lista de personagens ou o `hasReachedMax` mudarem.
  @override
  List<Object?> get props => [characters, hasReachedMax];
}

// O estado que representa que ocorreu um erro durante a busca dos dados.
class CharacterError extends CharacterState {
  // A mensagem de erro a ser exibida.
  final String message;
  const CharacterError(this.message);
  @override
  List<Object?> get props => [message];
}