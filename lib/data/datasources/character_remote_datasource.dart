import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_response_model.dart';

abstract class CharacterRemoteDataSource {
  Future<CharacterApiResponse> getCharacters(int page, [String? name]);
  Future<String> getEpisodeName(String episodeUrl);
}

class CharacterRemoteDataSourceImpl implements CharacterRemoteDataSource {
  final http.Client client;
  final String _baseUrl = "https://rickandmortyapi.com/api";

  CharacterRemoteDataSourceImpl({required this.client});

  @override
  Future<CharacterApiResponse> getCharacters(int page, [String? name]) async {
    String url = '$_baseUrl/character/?page=$page';
    if (name != null && name.isNotEmpty) {
      url += '&name=$name';
    }
    
    final response = await client.get(Uri.parse(url));

    if (response.statusCode == 200) { // 200 = OK
      return CharacterApiResponse.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) { // 404 = Not Found
      return CharacterApiResponse(
        info: const InfoModel(count: 0, pages: 0, next: null, prev: null),
        results: [],
      );
    } else {
      throw Exception('Failed to load characters');
    }
  }

  @override
  Future<String> getEpisodeName(String episodeUrl) async {
    final response = await client.get(Uri.parse(episodeUrl));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['name'];
    } else {
      throw Exception('Failed to load episode');
    }
  }
}