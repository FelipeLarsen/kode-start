import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/character_model.dart';
import '../../domain/repositories/character_repository.dart';
import '../widgets/custom_app_bar.dart';

class CharacterDetailPage extends StatelessWidget {
  final CharacterModel character;

  const CharacterDetailPage({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final double topSafeAreaHeight = MediaQuery.of(context).padding.top;
    const double appBarContentHeight = 55 + 1 + 75;
    final double totalAppBarHeight = topSafeAreaHeight + appBarContentHeight;

    const Color detailTextColor = Color(0xFF07144B);

    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(totalAppBarHeight),
        child: const CustomAppBar(hasBackButton: true),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
        child: Hero(
          tag: 'character_card_${character.id}',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CachedNetworkImage(
                  imageUrl: character.image,
                  fit: BoxFit.cover,
                  height: 160,
                ),
                Container(
                  padding: const EdgeInsets.all(20.0),
                  color: const Color(0xFF87A1FA),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        character.name.toUpperCase(),
                        style: GoogleFonts.lato(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: detailTextColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildStatusRow(
                        status: character.status,
                        species: character.species,
                        textColor: detailTextColor,
                      ),
                      const SizedBox(height: 20),
                      _buildLabelAndValue(
                        "Gender:",
                        character.gender,
                        textColor: detailTextColor,
                      ),
                      const SizedBox(height: 20),
                      _buildLabelAndValue(
                        "Last known location:",
                        character.location.name,
                        textColor: detailTextColor,
                      ),
                      const SizedBox(height: 20),
                      _buildFirstAppearance(
                        context,
                        character.episode.first,
                        textColor: detailTextColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusRow({
    required String status,
    required String species,
    required Color textColor,
  }) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: status == 'Alive'
                ? const Color(0xFF27AE60)
                : (status == 'Dead'
                    ? const Color(0xFFEB5757)
                    : Colors.grey.shade600),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$status - $species',
          style: GoogleFonts.lato(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildLabelAndValue(String label, String value, {required Color textColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.lato(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: textColor.withAlpha(204),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.lato(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: textColor,
          ),
        ),
      ],
    );
  }

  Widget _buildFirstAppearance(BuildContext context, String episodeUrl, {required Color textColor}) {
    final repo = context.read<CharacterRepository>();
    return FutureBuilder<String>(
      future: repo.getEpisodeName(episodeUrl),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLabelAndValue("First seen in:", "Loading...", textColor: textColor);
        }
        if (snapshot.hasError) {
          return _buildLabelAndValue("First seen in:", "Could not load", textColor: textColor);
        }
        if (snapshot.hasData) {
          return _buildLabelAndValue("First seen in:", snapshot.data!, textColor: textColor);
        }
        return const SizedBox.shrink();
      },
    );
  }
}
