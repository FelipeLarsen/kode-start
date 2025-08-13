import 'package:equatable/equatable.dart';
import 'character_model.dart';

class InfoModel extends Equatable {
  final int count;
  final int pages;
  final String? next;
  final String? prev;

  const InfoModel({
    required this.count,
    required this.pages,
    this.next,
    this.prev,
  });

  factory InfoModel.fromJson(Map<String, dynamic> json) {
    return InfoModel(
      count: json['count'],
      pages: json['pages'],
      next: json['next'],
      prev: json['prev'],
    );
  }

  @override
  List<Object?> get props => [count, pages, next, prev];
}


class CharacterApiResponse extends Equatable {
  final InfoModel info;
  final List<CharacterModel> results;

  const CharacterApiResponse({required this.info, required this.results});

  factory CharacterApiResponse.fromJson(Map<String, dynamic> json) {
    return CharacterApiResponse(
      info: InfoModel.fromJson(json['info']),
      results: List<CharacterModel>.from(
        json['results'].map((x) => CharacterModel.fromJson(x)),
      ),
    );
  }

  @override
  List<Object?> get props => [info, results];
}
