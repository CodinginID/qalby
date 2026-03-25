import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../shared/widgets/arabic_text.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../features/auth/domain/auth_provider.dart';
import '../../data/playlist_model.dart';
import '../../domain/playlist_provider.dart';

// ─── Dummy playlists untuk skeleton ───────────────────────────────────────────
final _skeletonPlaylists = List.generate(
  4,
  (i) => Playlist(
    id: 'skeleton_$i',
    name: 'Nama Playlist Hafalan',
    description: 'Deskripsi singkat playlist ini',
    items: const [],
    createdAt: DateTime.now(),
  ),
);

// ─── Page ─────────────────────────────────────────────────────────────────────

class PlaylistListPage extends ConsumerWidget {
  const PlaylistListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playlists = ref.watch(playlistsProvider);
    final isLoading = ref.watch(playlistsIsLoadingProvider);
    final isLoggedIn = ref.watch(isLoggedInProvider);

    ref.listen<String?>(playlistErrorProvider, (_, error) {
      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.redAccent),
        );
        ref.read(playlistErrorProvider.notifier).clear();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.surface,
      floatingActionButton: isLoggedIn
          ? FloatingActionButton(
              onPressed: () => _showCreateSheet(context, ref),
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
              child: const Icon(Icons.add_rounded),
            ).animate().scale(
                begin: const Offset(0, 0),
                curve: Curves.elasticOut,
                delay: 300.ms,
              )
          : null,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          _buildHeader(playlists, isLoading),
          if (!isLoggedIn)
            SliverToBoxAdapter(
              child: _GuestBanner(onLogin: () => context.push('/login')),
            ),
        ],
        body: RefreshIndicator(
          color: AppColors.accent,
          onRefresh: () => ref.read(playlistsProvider.notifier).refresh(),
          child: isLoading
              ? _PlaylistBody(playlists: _skeletonPlaylists, isLoading: true)
              : playlists.isEmpty
                  ? _EmptyBody(onAdd: () => _showCreateSheet(context, ref))
                  : _PlaylistBody(playlists: playlists, isLoading: false),
        ),
      ),
    );
  }

  Widget _buildHeader(List<Playlist> playlists, bool isLoading) {
    final count = isLoading ? 0 : playlists.length;
    final totalAyat = isLoading
        ? 0
        : playlists.fold<int>(0, (s, p) => s + p.totalAyat);

    return SliverAppBar(
      expandedHeight: 130,
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.accentDark,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(gradient: AppColors.goldGradient),
          padding: const EdgeInsets.fromLTRB(AppSpacing.lg, 56, AppSpacing.lg, 0),
          child: SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Playlist Hafalan',
                        style: AppTextStyles.headingMedium
                            .copyWith(color: Colors.white),
                      ),
                      const Gap(2),
                      isLoading
                          ? Text(
                              'Memuat...',
                              style: AppTextStyles.caption
                                  .copyWith(color: Colors.white70),
                            )
                          : Text(
                              '$count playlist · $totalAyat ayat total',
                              style: AppTextStyles.caption
                                  .copyWith(color: Colors.white70),
                            ),
                    ],
                  ),
                ),
                ArabicText(
                  text: 'حِفْظ',
                  style: AppTextStyles.arabicSurahName.copyWith(
                    color: Colors.white.withValues(alpha: 0.25),
                    fontSize: 36,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCreateSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CreatePlaylistSheet(
        onCreate: (name, desc) =>
            ref.read(playlistsProvider.notifier).create(name, desc),
      ),
    );
  }
}

// ─── Guest banner ──────────────────────────────────────────────────────────────

class _GuestBanner extends StatelessWidget {
  final VoidCallback onLogin;
  const _GuestBanner({required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.lock_outline_rounded, color: AppColors.accent, size: 18),
          const Gap(AppSpacing.sm),
          Expanded(
            child: Text(
              'Masuk untuk menyimpan playlist ke cloud',
              style: AppTextStyles.caption.copyWith(color: AppColors.accent),
            ),
          ),
          TextButton(
            onPressed: onLogin,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.accent,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              visualDensity: VisualDensity.compact,
            ),
            child: const Text('Masuk'),
          ),
        ],
      ),
    );
  }
}

// ─── Playlist body ─────────────────────────────────────────────────────────────

class _PlaylistBody extends StatelessWidget {
  final List<Playlist> playlists;
  final bool isLoading;
  const _PlaylistBody({required this.playlists, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, AppSpacing.md, AppSpacing.md, AppSpacing.xxl),
        itemCount: playlists.length,
        itemBuilder: (_, i) {
          final p = playlists[i];
          return isLoading
              ? _PlaylistCard(playlist: p, index: i)
              : _PlaylistCard(playlist: p, index: i)
                  .animate(delay: (i * 60).ms)
                  .fadeIn(duration: 300.ms)
                  .slideY(begin: 0.05);
        },
      ),
    );
  }
}

// ─── Empty state ───────────────────────────────────────────────────────────────

class _EmptyBody extends StatelessWidget {
  final VoidCallback onAdd;
  const _EmptyBody({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.6,
          child: EmptyStateWidget(
            icon: Icons.playlist_play_rounded,
            iconColor: AppColors.accent,
            title: 'Belum ada playlist',
            subtitle:
                'Buat playlist pertamamu dan mulai\nhafal Al-Quran dengan caramu',
            action: FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text('Buat Playlist'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Playlist card ─────────────────────────────────────────────────────────────

class _PlaylistCard extends ConsumerStatefulWidget {
  final Playlist playlist;
  final int index;
  const _PlaylistCard({required this.playlist, required this.index});

  @override
  ConsumerState<_PlaylistCard> createState() => _PlaylistCardState();
}

class _PlaylistCardState extends ConsumerState<_PlaylistCard> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final playlist = widget.playlist;
    final gradient = AppColors.playlistGradientAt(widget.index);

    return GestureDetector(
      onTap: () => context.push('/playlists/${playlist.id}'),
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          playlist.name,
                          style: AppTextStyles.titleCard
                              .copyWith(color: Colors.white),
                        ),
                        if (playlist.description.isNotEmpty) ...[
                          const Gap(4),
                          Text(
                            playlist.description,
                            style: AppTextStyles.caption
                                .copyWith(color: Colors.white70),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const Gap(AppSpacing.sm),
                        Row(
                          children: [
                            _InfoChip(
                                icon: Icons.format_list_numbered_rounded,
                                label: '${playlist.items.length} item'),
                            const Gap(AppSpacing.xs),
                            _InfoChip(
                                icon: Icons.auto_stories_rounded,
                                label: '${playlist.totalAyat} ayat'),
                            if (playlist.totalPracticed > 0) ...[
                              const Gap(AppSpacing.xs),
                              _InfoChip(
                                  icon: Icons.repeat_rounded,
                                  label:
                                      '${playlist.totalPracticed}x latihan'),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert_rounded,
                        color: Colors.white70, size: 20),
                    color: AppColors.surfaceCard,
                    onSelected: (v) {
                      if (v == 'delete') {
                        _confirmDelete(context, playlist);
                      } else if (v == 'practice') {
                        if (playlist.items.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Playlist masih kosong')),
                          );
                          return;
                        }
                        context
                            .push('/playlists/${playlist.id}/practice');
                      }
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                          value: 'practice',
                          child: Row(children: [
                            Icon(Icons.play_arrow_rounded,
                                size: 18, color: AppColors.primary),
                            Gap(8),
                            Text('Mulai Latihan'),
                          ])),
                      const PopupMenuItem(
                          value: 'delete',
                          child: Row(children: [
                            Icon(Icons.delete_outline_rounded,
                                size: 18, color: Colors.red),
                            Gap(8),
                            Text('Hapus',
                                style: TextStyle(color: Colors.red)),
                          ])),
                    ],
                  ),
                ],
              ),
            ),
            // Progress bar
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(AppRadius.lg),
                bottomRight: Radius.circular(AppRadius.lg),
              ),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: playlist.progressPercent),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                builder: (_, val, __) => LinearProgressIndicator(
                  value: val,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(Colors.white),
                  minHeight: 4,
                ),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Playlist playlist) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Hapus Playlist?'),
        content:
            Text('Playlist "${playlist.name}" akan dihapus permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              ref.read(playlistsProvider.notifier).delete(playlist.id);
              Navigator.pop(context);
            },
            child: const Text('Hapus',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: Colors.white70),
          const Gap(3),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Create playlist bottom sheet (U5: form validation) ───────────────────────

class _CreatePlaylistSheet extends StatefulWidget {
  final void Function(String name, String desc) onCreate;
  const _CreatePlaylistSheet({required this.onCreate});

  @override
  State<_CreatePlaylistSheet> createState() => _CreatePlaylistSheetState();
}

class _CreatePlaylistSheetState extends State<_CreatePlaylistSheet>
    with SingleTickerProviderStateMixin {
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _nameFocus = FocusNode();

  String? _nameError;
  int _nameLength = 0;
  bool _submitted = false;

  late AnimationController _shakeCtrl;
  late Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnim = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -8.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: -6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -6.0, end: 6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 6.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(parent: _shakeCtrl, curve: Curves.easeInOut));

    _nameCtrl.addListener(() {
      setState(() {
        _nameLength = _nameCtrl.text.length;
        if (_submitted) _validateName();
      });
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    _nameFocus.dispose();
    _shakeCtrl.dispose();
    super.dispose();
  }

  void _validateName() {
    final name = _nameCtrl.text.trim();
    setState(() {
      if (name.isEmpty) {
        _nameError = 'Nama playlist tidak boleh kosong';
      } else if (name.length > 50) {
        _nameError = 'Maksimal 50 karakter';
      } else {
        _nameError = null;
      }
    });
  }

  void _submit() {
    setState(() => _submitted = true);
    _validateName();
    if (_nameError != null) {
      _shakeCtrl.forward(from: 0);
      return;
    }
    widget.onCreate(_nameCtrl.text.trim(), _descCtrl.text.trim());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    final isValid = _nameCtrl.text.trim().isNotEmpty && _nameLength <= 50;

    return Container(
      margin: const EdgeInsets.fromLTRB(AppSpacing.sm, 0, AppSpacing.sm, AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      padding: EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, bottom + AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
          ),
          const Gap(AppSpacing.md),

          Text('Buat Playlist Baru', style: AppTextStyles.headingMedium),
          const Gap(AppSpacing.lg),

          // Name field with shake animation
          AnimatedBuilder(
            animation: _shakeAnim,
            builder: (_, child) => Transform.translate(
              offset: Offset(_shakeAnim.value, 0),
              child: child,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nameCtrl,
                  focusNode: _nameFocus,
                  autofocus: true,
                  maxLength: 50,
                  decoration: InputDecoration(
                    hintText: 'Nama playlist...',
                    prefixIcon: const Icon(Icons.playlist_play_rounded, size: 20),
                    errorText: _nameError,
                    counterText: '$_nameLength/50',
                    counterStyle: AppTextStyles.caption.copyWith(
                      color: _nameLength > 45
                          ? Colors.orange
                          : AppColors.textHint,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Gap(AppSpacing.sm),

          // Description field
          TextField(
            controller: _descCtrl,
            maxLength: 120,
            decoration: const InputDecoration(
              hintText: 'Deskripsi (opsional)',
              prefixIcon: Icon(Icons.notes_rounded, size: 20),
              counterText: '',
            ),
          ),
          const Gap(AppSpacing.lg),

          // Submit button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.check_rounded, size: 18),
                label: const Text('Buat Playlist'),
                style: FilledButton.styleFrom(
                  backgroundColor:
                      isValid ? AppColors.accent : AppColors.divider,
                  foregroundColor: isValid ? Colors.white : AppColors.textHint,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
