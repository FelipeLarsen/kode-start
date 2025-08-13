// ========== lib/presentation/bloc/character_event.dart ==========

// Importa o pacote equatable para facilitar a comparação de objetos.
import 'package:equatable/equatable.dart';

// A classe base para todos os eventos. Herdar de `Equatable` nos permite
// comparar instâncias de eventos, o que é útil para testes e para o BLoC.
abstract class CharacterEvent extends Equatable {
  const CharacterEvent();
  // `props` é uma lista de propriedades que serão usadas para a comparação de igualdade.
  @override
  List<Object?> get props => [];
}

// Evento disparado para buscar uma nova lista de personagens (ou a primeira).
class FetchCharacters extends CharacterEvent {
  // Propriedade para carregar o termo de busca. É opcional (`?`) porque a
  // carga inicial da lista não tem um filtro de nome.
  final String? name;

  // Construtor que permite passar o nome.
  const FetchCharacters({this.name});

  // Adicionamos `name` à lista de `props` para que eventos com nomes diferentes
  // sejam considerados diferentes. Ex: FetchCharacters(name: "rick") != FetchCharacters(name: "morty").
  @override
  List<Object?> get props => [name];
}

// Evento disparado quando o usuário rola até o final da lista para carregar mais personagens.
class FetchMoreCharacters extends CharacterEvent {
  const FetchMoreCharacters();
}