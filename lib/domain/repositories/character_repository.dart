import '../../data/models/api_response_model.dart';

abstract class CharacterRepository {
  Future<CharacterApiResponse> getCharacters(int page, [String? name]);
  
  Future<String> getEpisodeName(String episodeUrl);
}
