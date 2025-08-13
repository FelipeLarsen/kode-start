import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

import 'data/datasources/character_remote_datasource.dart';
import 'data/repositories/character_repository_impl.dart';
import 'domain/repositories/character_repository.dart';
import 'presentation/bloc/character_bloc.dart';
import 'presentation/pages/character_list_page.dart';
import 'presentation/bloc/character_event.dart';

void main() {
  final CharacterRepository characterRepository = CharacterRepositoryImpl(
    remoteDataSource: CharacterRemoteDataSourceImpl(client: http.Client()),
  );

  runApp(
    RepositoryProvider<CharacterRepository>.value(
      value: characterRepository,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CharacterBloc(
        characterRepository: context.read<CharacterRepository>(),
      )..add(const FetchCharacters()),
      child: MaterialApp(
        title: 'Rick & Morty App', 
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: const Color(0xFF000000),
          textTheme: GoogleFonts.latoTextTheme( 
            Theme.of(context).textTheme.apply(
                  bodyColor: Colors.white,    
                  displayColor: Colors.white,  
                ),
          ),
        ),
        home: const CharacterListPage(),
      ),
    );
  }
}
