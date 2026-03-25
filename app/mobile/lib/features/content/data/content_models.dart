import 'package:flutter/material.dart';

// ─── Motivasi ──────────────────────────────────────────────────────────────────

class MotivationQuote {
  final String arabic;
  final String translation;
  final String source;
  final String category; // 'Quran' | 'Hadith' | 'Ulama'

  const MotivationQuote({
    required this.arabic,
    required this.translation,
    required this.source,
    required this.category,
  });
}

// ─── Doa ───────────────────────────────────────────────────────────────────────

class Doa {
  final String name;
  final String arabic;
  final String latin;
  final String translation;
  final String source;
  final String category;

  const Doa({
    required this.name,
    required this.arabic,
    required this.latin,
    required this.translation,
    required this.source,
    required this.category,
  });
}

// ─── Kisah Nabi ────────────────────────────────────────────────────────────────

class ProphetStory {
  final String id;
  final String name;
  final String nameArabic;
  final String epithet; // gelar, mis. "Ulul Azmi"
  final String brief;
  final String story;
  final String lesson;
  final List<String> keyEvents;
  final Color color;

  const ProphetStory({
    required this.id,
    required this.name,
    required this.nameArabic,
    required this.epithet,
    required this.brief,
    required this.story,
    required this.lesson,
    required this.keyEvents,
    required this.color,
  });
}

// ─── Dzikir ────────────────────────────────────────────────────────────────────

class DzikirItem {
  final String arabic;
  final String latin;
  final String translation;
  final int recommendedCount;
  final String source;

  const DzikirItem({
    required this.arabic,
    required this.latin,
    required this.translation,
    required this.recommendedCount,
    required this.source,
  });
}

class DzikirSession {
  final String id; // 'pagi' | 'petang'
  final String name;
  final IconData icon;
  final List<DzikirItem> items;

  const DzikirSession({
    required this.id,
    required this.name,
    required this.icon,
    required this.items,
  });
}

// ─── Sunnah Tracker ────────────────────────────────────────────────────────────

class SunnahItem {
  final String id;
  final String name;
  final String description;
  final String reward;
  final IconData icon;
  final String category; // 'Ibadah' | 'Adab' | 'Kesehatan'

  const SunnahItem({
    required this.id,
    required this.name,
    required this.description,
    required this.reward,
    required this.icon,
    required this.category,
  });
}
