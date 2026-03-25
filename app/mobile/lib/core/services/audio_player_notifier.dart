import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

// ─── Supported qaris ────────────────────────────────────────────────────────

class QariInfo {
  final String id;
  final String name;
  final String nameAr;
  const QariInfo(this.id, this.name, this.nameAr);
}

const List<QariInfo> kSupportedQari = [
  QariInfo('ar.alafasy',              'Mishary Alafasy',    'مشاري العفاسي'),
  QariInfo('ar.abdulbasitmurattal',   'Abdul Basit',        'عبد الباسط'),
  QariInfo('ar.abdurrahmanas-sudais', 'Abdurrahman Sudais', 'عبد الرحمن السديس'),
  QariInfo('ar.mahermuaiqly',         'Maher Al-Muaiqly',   'ماهر المعيقلي'),
];

// ─── State ───────────────────────────────────────────────────────────────────

class QuranAudioState {
  final int? surahNumber;
  final int? ayatNumber;
  final bool isPlaying;
  final bool isLoading;
  final Duration position;
  final Duration duration;
  final String qariId;
  final String? error;

  const QuranAudioState({
    this.surahNumber,
    this.ayatNumber,
    this.isPlaying = false,
    this.isLoading = false,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.qariId = 'ar.alafasy',
    this.error,
  });

  bool get hasActiveAudio => surahNumber != null && ayatNumber != null;

  double get progress =>
      duration.inMilliseconds > 0
          ? position.inMilliseconds / duration.inMilliseconds
          : 0.0;

  QuranAudioState copyWith({
    int? surahNumber,
    int? ayatNumber,
    bool? isPlaying,
    bool? isLoading,
    Duration? position,
    Duration? duration,
    String? qariId,
    String? error,
    bool clearAudio = false,
  }) {
    return QuranAudioState(
      surahNumber: clearAudio ? null : (surahNumber ?? this.surahNumber),
      ayatNumber: clearAudio ? null : (ayatNumber ?? this.ayatNumber),
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      qariId: qariId ?? this.qariId,
      error: error,
    );
  }
}

// ─── Notifier ────────────────────────────────────────────────────────────────

class QuranAudioNotifier extends Notifier<QuranAudioState> {
  late final AudioPlayer _player;

  @override
  QuranAudioState build() {
    _player = AudioPlayer();

    _player.playerStateStream.listen((ps) {
      state = state.copyWith(
        isPlaying: ps.playing,
        isLoading: ps.processingState == ProcessingState.loading ||
            ps.processingState == ProcessingState.buffering,
      );
      if (ps.processingState == ProcessingState.completed) {
        state = state.copyWith(isPlaying: false, position: Duration.zero);
      }
    });

    _player.positionStream.listen((pos) {
      state = state.copyWith(position: pos);
    });

    _player.durationStream.listen((dur) {
      if (dur != null) state = state.copyWith(duration: dur);
    });

    ref.onDispose(() => _player.dispose());

    return const QuranAudioState();
  }

  Future<void> playAyat({
    required int surahNumber,
    required int ayatNumber,
    required String audioUrl,
  }) async {
    try {
      // Same ayat — toggle play/pause
      if (state.surahNumber == surahNumber && state.ayatNumber == ayatNumber) {
        if (state.isPlaying) {
          await _player.pause();
        } else {
          await _player.play();
        }
        return;
      }

      // New ayat
      state = state.copyWith(
        surahNumber: surahNumber,
        ayatNumber: ayatNumber,
        isLoading: true,
        isPlaying: false,
        position: Duration.zero,
        duration: Duration.zero,
      );
      await _player.setUrl(audioUrl);
      await _player.play();
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Gagal memutar audio');
    }
  }

  Future<void> pause() async => await _player.pause();
  Future<void> resume() async => await _player.play();

  Future<void> seek(double progress) async {
    final target = Duration(
      milliseconds: (state.duration.inMilliseconds * progress).round(),
    );
    await _player.seek(target);
  }

  Future<void> stop() async {
    await _player.stop();
    state = const QuranAudioState(qariId: 'ar.alafasy');
  }

  Future<void> setQari(String qariId) async {
    state = state.copyWith(qariId: qariId, clearAudio: true);
    await _player.stop();
  }
}

final quranAudioProvider =
    NotifierProvider<QuranAudioNotifier, QuranAudioState>(QuranAudioNotifier.new);
