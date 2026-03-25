import 'package:flutter/material.dart';

class PlaylistItem {
  final String id;
  final int surahNumber;
  final String surahName;
  final String surahNameArabic;
  final int ayatStart;
  final int ayatEnd;
  int order;

  PlaylistItem({
    required this.id,
    required this.surahNumber,
    required this.surahName,
    required this.surahNameArabic,
    required this.ayatStart,
    required this.ayatEnd,
    required this.order,
  });

  PlaylistItem copyWith({int? order}) => PlaylistItem(
        id: id,
        surahNumber: surahNumber,
        surahName: surahName,
        surahNameArabic: surahNameArabic,
        ayatStart: ayatStart,
        ayatEnd: ayatEnd,
        order: order ?? this.order,
      );

  String get rangeLabel => ayatStart == ayatEnd
      ? 'Ayat $ayatStart'
      : 'Ayat $ayatStart – $ayatEnd';

  int get ayatCount => ayatEnd - ayatStart + 1;
}

class Playlist {
  final String id;
  String name;
  String description;
  List<PlaylistItem> items;
  final DateTime createdAt;
  int totalPracticed;

  Playlist({
    required this.id,
    required this.name,
    required this.description,
    required this.items,
    required this.createdAt,
    this.totalPracticed = 0,
  });

  int get totalAyat => items.fold(0, (sum, i) => sum + i.ayatCount);

  double get progressPercent =>
      items.isEmpty ? 0 : (totalPracticed / items.length).clamp(0, 1);

  Playlist copyWith({
    String? name,
    String? description,
    List<PlaylistItem>? items,
    int? totalPracticed,
  }) =>
      Playlist(
        id: id,
        name: name ?? this.name,
        description: description ?? this.description,
        items: items ?? this.items,
        createdAt: createdAt,
        totalPracticed: totalPracticed ?? this.totalPracticed,
      );
}

@immutable
class PracticeSession {
  final Playlist playlist;
  final int currentIndex;
  final Map<String, int> repetitions; // item.id → jumlah ulang
  final Set<String> completedIds;
  final DateTime startTime;

  const PracticeSession({
    required this.playlist,
    required this.currentIndex,
    required this.repetitions,
    required this.completedIds,
    required this.startTime,
  });

  PlaylistItem get currentItem => playlist.items[currentIndex];

  int get currentRepetitions => repetitions[currentItem.id] ?? 0;

  bool get isCurrentDone => completedIds.contains(currentItem.id);

  bool get isLast => currentIndex == playlist.items.length - 1;

  bool get isFirst => currentIndex == 0;

  bool get isAllDone => completedIds.length == playlist.items.length;

  Duration get elapsed => DateTime.now().difference(startTime);

  PracticeSession copyWith({
    int? currentIndex,
    Map<String, int>? repetitions,
    Set<String>? completedIds,
  }) =>
      PracticeSession(
        playlist: playlist,
        currentIndex: currentIndex ?? this.currentIndex,
        repetitions: repetitions ?? this.repetitions,
        completedIds: completedIds ?? this.completedIds,
        startTime: startTime,
      );
}
