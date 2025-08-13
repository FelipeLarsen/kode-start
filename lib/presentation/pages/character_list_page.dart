import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/character_bloc.dart';
import '../bloc/character_event.dart';
import '../bloc/character_state.dart';
import '../widgets/character_card.dart';
import '../widgets/custom_app_bar.dart';

class CharacterListPage extends StatefulWidget {
  const CharacterListPage({super.key});

  @override
  State<CharacterListPage> createState() => _CharacterListPageState();
}

class _CharacterListPageState extends State<CharacterListPage> {
  final _scrollController = ScrollController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<CharacterBloc>().add(const FetchMoreCharacters());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<CharacterBloc>().add(FetchCharacters(name: query));
    });
  }

  @override
  Widget build(BuildContext context) {
    final double topSafeAreaHeight = MediaQuery.of(context).padding.top;
    const double appBarContentHeight = 55 + 1 + 75;
    final double totalAppBarHeight = topSafeAreaHeight + appBarContentHeight;
    final double bottomSafeAreaHeight = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(totalAppBarHeight),
        child: const CustomAppBar(),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
            child: TextField(
              onChanged: _onSearchChanged,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1C1B1F),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                hintText: 'Buscar por nome...',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<CharacterBloc, CharacterState>(
              builder: (context, state) {
                if (state is CharacterInitial || state is CharacterLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is CharacterLoaded) {
                  if (state.characters.isEmpty) {
                    return const Center(
                      child: Text('Nenhum personagem encontrado.'),
                    );
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.fromLTRB(20, 15, 20, 40 + bottomSafeAreaHeight),
                    itemCount: state.hasReachedMax
                        ? state.characters.length
                        : state.characters.length + 1,
                    itemBuilder: (context, index) {
                      if (index >= state.characters.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      final character = state.characters[index];
                      return CharacterCard(character: character);
                    },
                  );
                }
                if (state is CharacterError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
