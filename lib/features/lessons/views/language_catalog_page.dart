import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;
import '../../../shared/theme/app_colors.dart';
import '../viewmodels/languages_provider.dart';

// ─────────────────────────────────────────────
//  Extra metadata per language (badge + tagline)
// ─────────────────────────────────────────────
const _langMeta = {
  'ar': (badge: 'Populaire', tagline: '400M locuteurs'),
  'fr': (badge: 'Recommandé', tagline: '300M locuteurs'),
  'en': (badge: '🔥 Top 1', tagline: '1,5Md locuteurs'),
  'es': (badge: 'Populaire', tagline: '500M locuteurs'),
  'it': (badge: '', tagline: '65M locuteurs'),
  'tr': (badge: 'Nouveau', tagline: '80M locuteurs'),
  'de': (badge: '', tagline: '100M locuteurs'),
};

class LanguageCatalogPage extends ConsumerStatefulWidget {
  const LanguageCatalogPage({super.key});

  @override
  ConsumerState<LanguageCatalogPage> createState() =>
      _LanguageCatalogPageState();
}

class _LanguageCatalogPageState extends ConsumerState<LanguageCatalogPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _headerCtrl;
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _headerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
    _searchCtrl.addListener(() => setState(() => _query = _searchCtrl.text));
  }

  @override
  void dispose() {
    _headerCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final languages = ref.watch(languagesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = screenWidth > 900 ? 24.0 : 14.0;
    final crossAxisCount = screenWidth > 1100
        ? 5
        : screenWidth > 760
            ? 4
            : screenWidth > 500
                ? 3
                : 2;

    final filtered = _query.isEmpty
        ? languages
        : languages
            .where((l) =>
                l.name.toLowerCase().contains(_query.toLowerCase()))
            .toList();

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── Animated Header ──────────────────────────────
          SliverToBoxAdapter(
            child: _AnimatedHeader(
              ctrl: _headerCtrl,
              isDark: isDark,
              onBack: () => context.go('/'),
            ),
          ),

          // ── Search bar ───────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(horizontalPadding + 2, 0, horizontalPadding + 2, 8),
              child: _SearchBar(controller: _searchCtrl, isDark: isDark),
            ),
          ),

          // ── Count label ──────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.fromLTRB(horizontalPadding + 6, 4, horizontalPadding + 6, 8),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      filtered.isEmpty
                          ? 'Aucune langue'
                          : '${filtered.length} langue${filtered.length > 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : AppColors.textSecondary,
                      ),
                    ),
                  ),
                  if (_query.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Résultats pour "$_query"',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: isDark ? Colors.white38 : Colors.black45,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // ── Grid ─────────────────────────────────────────
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: screenWidth > 760 
                    ? 0.9 
                    : screenWidth > 500
                        ? 0.84 
                        : 0.80,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final lang = filtered[index];
                  final meta = _langMeta[lang.id] ??
                      (badge: '', tagline: '');
                  return _LanguageCard(
                    key: ValueKey(lang.id),
                    language: lang,
                    badge: meta.badge,
                    tagline: meta.tagline,
                    index: index,
                    isDark: isDark,
                    onTap: () {
                      ref
                          .read(selectedLanguageIdProvider.notifier)
                          .state = lang.id;
                      context.push('/lessons/${lang.id}');
                    },
                  );
                },
                childCount: filtered.length,
              ),
            ),
          ),

          const SliverPadding(padding: EdgeInsets.only(bottom: 48)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Animated gradient header
// ─────────────────────────────────────────────
class _AnimatedHeader extends StatelessWidget {
  final AnimationController ctrl;
  final bool isDark;
  final VoidCallback onBack;

  const _AnimatedHeader({
    required this.ctrl,
    required this.isDark,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ctrl,
      builder: (_, __) {
        final t = ctrl.value;
        return Container(
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(math.cos(t * math.pi) * 0.5, -1),
              end: Alignment(1, math.sin(t * math.pi) * 0.5 + 0.5),
              colors: isDark
                  ? const [
                      Color(0xFF1E3A5F),
                      Color(0xFF1A56DB),
                      Color(0xFF0E7490),
                    ]
                  : const [
                      Color(0xFF1A56DB),
                      Color(0xFF1CB0F6),
                      Color(0xFF0E7490),
                    ],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                // Decorative circles
                Positioned(
                  right: -30,
                  top: -30,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.07),
                    ),
                  ),
                ),
                Positioned(
                  left: -20,
                  bottom: -20,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.07),
                    ),
                  ),
                ),
                // Content
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button
                      GestureDetector(
                        onTap: onBack,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Globe icon row
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text('🌍',
                                style: TextStyle(fontSize: 20)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Catalogue des Langues',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.3,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Choisissez votre prochaine aventure',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
//  Search bar
// ─────────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isDark;
  const _SearchBar({required this.controller, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final hasQuery = controller.text.isNotEmpty;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(
          color: isDark ? Colors.white : AppColors.textPrimary,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: 'Rechercher une langue…',
          hintStyle: TextStyle(
            color: isDark ? Colors.white38 : Colors.black38,
            fontSize: 14,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: isDark ? Colors.white38 : Colors.black38,
            size: 20,
          ),
          suffixIcon: hasQuery
              ? IconButton(
                  icon: Icon(Icons.close_rounded,
                      size: 18,
                      color: isDark ? Colors.white38 : Colors.black38),
                  onPressed: () => controller.clear(),
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Language card
// ─────────────────────────────────────────────
class _LanguageCard extends StatefulWidget {
  final dynamic language;
  final String badge;
  final String tagline;
  final int index;
  final bool isDark;
  final VoidCallback onTap;

  const _LanguageCard({
    super.key,
    required this.language,
    required this.badge,
    required this.tagline,
    required this.index,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_LanguageCard> createState() => _LanguageCardState();
}

class _LanguageCardState extends State<_LanguageCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _entryCtrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _fadeAnim = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.18),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut));

    // Stagger: each card starts slightly later
    Future.delayed(Duration(milliseconds: 60 * widget.index), () {
      if (mounted) _entryCtrl.forward();
    });
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.language.color as Color;
    final isDark = widget.isDark;
    final badgeBg = isDark ? color.withOpacity(0.2) : color.withOpacity(0.15);

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) {
            setState(() => _isPressed = false);
            widget.onTap();
          },
          onTapCancel: () => setState(() => _isPressed = false),
          child: AnimatedScale(
            scale: _isPressed ? 0.93 : 1.0,
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: color.withOpacity(_isPressed ? 0.6 : 0.25),
                  width: 1.5,
                ),
                boxShadow: _isPressed
                    ? []
                    : [
                        BoxShadow(
                          color: color.withOpacity(isDark ? 0.25 : 0.22),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Colored top strip with gradient ──
                    Container(
                      height: 6,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            color,
                            color.withOpacity(0.5),
                          ],
                        ),
                      ),
                    ),

                    // ── Card body ──
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 10, 8, 8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Flag circle
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                gradient: RadialGradient(
                                  colors: [
                                    color.withOpacity(0.22),
                                    color.withOpacity(0.06),
                                  ],
                                ),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                          child: Text(
                                widget.language.flagEmoji,
                                style: const TextStyle(fontSize: 29),
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Language name
                            Text(
                              widget.language.name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: isDark
                                    ? Colors.white
                                    : AppColors.textPrimary,
                                letterSpacing: -0.2,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 3),

                            // Tagline
                            Text(
                              widget.tagline,
                              style: TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? Colors.white38
                                    : AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            // Badge (optional)
                            if (widget.badge.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: badgeBg,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  widget.badge,
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w700,
                                    color: color,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ),
                            ],
                            const SizedBox(height: 7),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withOpacity(0.07)
                                    : color.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                'Explorer',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? Colors.white70 : color,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
