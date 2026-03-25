import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ─── Tajweed rule colors ──────────────────────────────────────────────────────

const _ruleColors = <String, Color>{
  'ham_wasl':         Color(0xFF4FC3F7), // Hamzah Wasl – light blue
  'slnt':             Color(0xFF90A4AE), // Silent – grey
  'laam_shamsiyah':   Color(0xFF4FC3F7), // Lam Shamsiyah
  'madda_normal':     Color(0xFF29B6F6), // Madd Normal – cyan
  'madda_permissible':Color(0xFF0288D1), // Madd Jaiz – dark cyan
  'madda_necessary':  Color(0xFF6A0DAD), // Madd Lazim – purple
  'madda_obligatory': Color(0xFF006064), // Madd Wajib – teal dark
  'qalaqah':          Color(0xFFAB47BC), // Qalqalah – purple
  'ikhf_mus':         Color(0xFF26C6DA), // Ikhfa Musyaddad
  'ikhf':             Color(0xFF00ACC1), // Ikhfa – teal
  'idghm_mus':        Color(0xFF43A047), // Idgham Musyaddad
  'idghm_mim':        Color(0xFF66BB6A), // Idgham Mim
  'idghm_ghunnah':    Color(0xFF81C784), // Idgham + Ghunnah
  'idghm_no_ghunnah': Color(0xFF388E3C), // Idgham – Ghunnah
  'idghm':            Color(0xFF4CAF50), // Idgham
  'iqlb':             Color(0xFFFF8A65), // Iqlab – orange
  'ghn':              Color(0xFFEF5350), // Ghunnah – red
  'ixf_syf':          Color(0xFF42A5F5), // Ikhfa Shafawi
  'idgm_shfw':        Color(0xFF66BB6A), // Idgham Shafawi
};

// ─── Legend ───────────────────────────────────────────────────────────────────

const _legendItems = [
  _LegendItem('Hamzah Wasl',    Color(0xFF4FC3F7)),
  _LegendItem('Madd',           Color(0xFF0288D1)),
  _LegendItem('Madd Lazim',     Color(0xFF6A0DAD)),
  _LegendItem('Qalqalah',       Color(0xFFAB47BC)),
  _LegendItem('Ikhfa',          Color(0xFF00ACC1)),
  _LegendItem('Idgham',         Color(0xFF4CAF50)),
  _LegendItem('Iqlab',          Color(0xFFFF8A65)),
  _LegendItem('Ghunnah',        Color(0xFFEF5350)),
  _LegendItem('Diam',           Color(0xFF90A4AE)),
];

class _LegendItem {
  final String label;
  final Color color;
  const _LegendItem(this.label, this.color);
}

// ─── Tajweed text widget ──────────────────────────────────────────────────────

class TajweedText extends StatelessWidget {
  final String tajweedHtml;
  final TextStyle? baseStyle;

  const TajweedText({super.key, required this.tajweedHtml, this.baseStyle});

  static final _regex = RegExp(r'<tajweed class="([^"]+)">([^<]*)</tajweed>|([^<]+)');

  TextSpan _buildSpan(TextStyle base) {
    final spans = <TextSpan>[];
    for (final m in _regex.allMatches(tajweedHtml)) {
      final plain = m.group(3);
      if (plain != null) {
        spans.add(TextSpan(text: plain));
      } else {
        final cls = m.group(1)!;
        final text = m.group(2)!;
        final color = _ruleColors[cls];
        spans.add(TextSpan(
          text: text,
          style: color != null ? TextStyle(color: color) : null,
        ));
      }
    }
    return TextSpan(style: base, children: spans);
  }

  @override
  Widget build(BuildContext context) {
    final base = baseStyle ??
        GoogleFonts.amiri(
          fontSize: 26,
          height: 2.2,
          color: Theme.of(context).colorScheme.onSurface,
        );
    return RichText(
      text: _buildSpan(base),
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.right,
    );
  }
}

// ─── Tajweed legend card ──────────────────────────────────────────────────────

class TajweedLegendCard extends StatelessWidget {
  const TajweedLegendCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      children: _legendItems.map((item) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 10, height: 10,
            decoration: BoxDecoration(color: item.color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(item.label, style: const TextStyle(fontSize: 11)),
        ],
      )).toList(),
    );
  }
}
