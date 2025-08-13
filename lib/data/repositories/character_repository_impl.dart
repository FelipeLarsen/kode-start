import '../../domain/repositories/character_repository.dart';
import '../datasources/character_remote_datasource.dart';
import '../models/api_response_model.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterRemoteDataSource remoteDataSource;

  CharacterRepositoryImpl({required this.remoteDataSource});

  @override
  Future<CharacterApiResponse> getCharacters(int page, [String? name]) async {
    return await remoteDataSource.getCharacters(page, name);
  }

  @override
  Future<String> getEpisodeName(String episodeUrl) async {
    return await remoteDataSource.getEpisodeName(episodeUrl);
  }
}