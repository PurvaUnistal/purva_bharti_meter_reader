import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meter_reader_new/Utils/common_widgets/background_widget.dart';
import 'package:meter_reader_new/Utils/common_widgets/logout_widget.dart';
import 'package:meter_reader_new/Utils/common_widgets/app_bar_widget.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/app_color.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/app_config.dart';
import 'package:meter_reader_new/features/Home/domain/bloc/home_bloc.dart';
import 'package:meter_reader_new/features/Home/domain/bloc/home_event.dart';
import 'package:meter_reader_new/features/Home/domain/bloc/home_state.dart';
import 'package:meter_reader_new/features/Home/domain/model/propert_type_model.dart';
import 'package:meter_reader_new/features/billingRequest/presentation/billing_request_page.dart';

// ── Tokens ───────────────────────────────────────────────────────
class _C {
  static const ink = Color(0xFF141A17);
  static const muted = Color(0xFF6B7684);
  static const skeleton = Color(0xFFEDF0F2);
  static const disabledTile = Color(0xFFF1F3F5);
  static const tileHeight = 172.0;
}

/// Each property type gets its own colour, icon and hint.
class _Palette {
  final Color base; // tile colour when selected
  final Color on; // text/icon colour on top of [base]
  final IconData icon;
  final String hint;
  const _Palette(this.base, this.on, this.icon, this.hint);
}

_Palette _paletteFor(String? code) {
  switch (code) {
    case 'dom':
      return const _Palette(Color(0xFFFFB020), Color(0xFF3A2600),
          Icons.home_rounded, 'Houses and flats');
    case 'com':
      return const _Palette(Color(0xFF2F80ED), Colors.white,
          Icons.storefront_rounded, 'Shops and offices');
    case 'indus':
      return const _Palette(Color(0xFF7B5CFA), Colors.white,
          Icons.factory_rounded, 'Factories and plants');
    default:
      return const _Palette(Color(0xFF12B886), Colors.white,
          Icons.category_rounded, 'Other property');
  }
}

bool _still(BuildContext context) => MediaQuery.of(context).disableAnimations;

// ── Page ─────────────────────────────────────────────────────────
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PropertyTypeModel? selected;

  /// Blocks double taps while the next screen is opening.
  bool _navigating = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    BlocProvider.of<HomeBloc>(context)
        .add(HomePageLoadingEvent(context: context));
  }

  /// Tapping a tile selects it and opens the next screen straight away.
  Future<void> _openType(PropertyTypeModel t) async {
    if (_navigating) return;
    HapticFeedback.selectionClick();
    setState(() {
      selected = t;
      _navigating = true;
    });

    // Short pause so the selection animation is visible before the push.
    if (!_still(context)) {
      await Future.delayed(const Duration(milliseconds: 180));
    }
    if (!mounted) return;

    AppConfig.instanceInit()?.setPropertyCategoryId(val: t);
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BillingRequestPage()),
    );

    // Back on this screen: clear the highlight so tiles look fresh.
    if (!mounted) return;
    setState(() {
      selected = null;
      _navigating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final hPad = width > 600 ? (width - 560) / 2 : 16.0;
    final bottom = MediaQuery.of(context).viewPadding.bottom;

    return Scaffold(
      appBar: AppBarWidget(
        title: "Property type",
        boolLeading: false,
        actions: [
          IconButton(
            onPressed: () => LogoutWidget.show(context),
            icon: Icon(Icons.logout, color: AppColor.white),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: BackgroundWidget(
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              final types =
              state is HomeFetchDataState ? state.listOfPropertyType : null;

              return ListView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 24 + bottom),
                children: [
                  if (types == null)
                    const _SkeletonGrid()
                  else if (types.isEmpty)
                    _EmptyState(onRetry: _load)
                  else ...[
                      const Padding(
                        padding: EdgeInsets.only(left: 4, bottom: 14),
                        child: Text(
                          'Tap a property type to start a reading',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: _C.muted,
                          ),
                        ),
                      ),
                      _grid(types),
                    ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  /// Two tiles per row; an odd last tile spans the full width.
  Widget _grid(List<PropertyTypeModel> types) {
    Widget tile(PropertyTypeModel t, {bool wide = false}) => _Tile(
      type: t,
      wide: wide,
      selected: selected?.id == t.id,
      onTap: t.isActive ? () => _openType(t) : null,
    );

    final rows = <Widget>[];
    for (var i = 0; i < types.length; i += 2) {
      if (i + 1 < types.length) {
        rows.add(Row(
          children: [
            Expanded(child: tile(types[i])),
            const SizedBox(width: 12),
            Expanded(child: tile(types[i + 1])),
          ],
        ));
      } else {
        rows.add(tile(types[i], wide: true));
      }
      rows.add(const SizedBox(height: 12));
    }
    return Column(children: rows);
  }
}

// ── Tile ─────────────────────────────────────────────────────────
class _Tile extends StatefulWidget {
  final PropertyTypeModel type;
  final bool selected;
  final bool wide;
  final VoidCallback? onTap;

  const _Tile({
    required this.type,
    required this.selected,
    required this.onTap,
    this.wide = false,
  });

  @override
  State<_Tile> createState() => _TileState();
}

class _TileState extends State<_Tile> {
  bool _pressed = false;

  void _press(bool v) {
    if (_pressed != v) setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    final p = _paletteFor(widget.type.propCode);
    final sel = widget.selected;
    final disabled = widget.onTap == null;
    final still = _still(context);
    final dur = still ? Duration.zero : const Duration(milliseconds: 220);

    final bg = disabled
        ? _C.disabledTile
        : sel
        ? p.base
        : Color.lerp(p.base, Colors.white, 0.84)!;
    final fg = sel ? p.on : _C.ink;
    final accent = disabled ? _C.muted : (sel ? p.on : p.base);

    return Semantics(
      button: true,
      selected: sel,
      enabled: !disabled,
      label: widget.type.name,
      hint: disabled ? null : 'Opens billing request',
      excludeSemantics: true,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: disabled ? null : (_) => _press(true),
        onTapUp: disabled ? null : (_) => _press(false),
        onTapCancel: disabled ? null : () => _press(false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _pressed && !still ? 0.95 : 1,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: dur,
            curve: Curves.easeOutCubic,
            height: widget.wide ? 132 : _C.tileHeight,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: sel ? p.base : p.base.withOpacity(disabled ? 0 : 0.22),
                width: 1.2,
              ),
              boxShadow: sel
                  ? [
                BoxShadow(
                  color: p.base.withOpacity(0.38),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ]
                  : const [],
            ),
            child: Stack(
              children: [
                // Oversized icon bleeding off the corner.
                Positioned(
                  right: -22,
                  bottom: -26,
                  child: AnimatedRotation(
                    turns: sel ? -0.03 : 0,
                    duration: dur,
                    child: Icon(
                      p.icon,
                      size: 128,
                      color: accent.withOpacity(sel ? 0.2 : 0.13),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          AnimatedContainer(
                            duration: dur,
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: sel
                                  ? Colors.white.withOpacity(0.25)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Icon(
                              disabled ? Icons.lock_rounded : p.icon,
                              color: accent,
                              size: 22,
                            ),
                          ),
                          const Spacer(),
                          // Arrow tells the user a tap opens the next
                          // screen; it turns into a check when tapped.
                          if (!disabled)
                            AnimatedContainer(
                              duration: dur,
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: sel ? p.on : Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: AnimatedSwitcher(
                                duration: dur,
                                transitionBuilder: (child, anim) =>
                                    ScaleTransition(scale: anim, child: child),
                                child: Icon(
                                  sel
                                      ? Icons.check_rounded
                                      : Icons.arrow_forward_rounded,
                                  key: ValueKey(sel),
                                  size: 17,
                                  color: p.base,
                                ),
                              ),
                            ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AnimatedDefaultTextStyle(
                            duration: dur,
                            style: TextStyle(
                              fontSize: 19,
                              height: 1.15,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                              color: fg,
                            ),
                            child: Text(
                              widget.type.name ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 3),
                          AnimatedDefaultTextStyle(
                            duration: dur,
                            style: TextStyle(
                              fontSize: 13,
                              color: fg.withOpacity(0.7),
                            ),
                            child: Text(
                              disabled ? 'Not available' : p.hint,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
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
}

// ── Loading + empty ──────────────────────────────────────────────
class _SkeletonGrid extends StatelessWidget {
  const _SkeletonGrid();

  @override
  Widget build(BuildContext context) {
    Widget box() => Expanded(
      child: Container(
        height: _C.tileHeight,
        decoration: BoxDecoration(
          color: _C.skeleton,
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );

    return Column(
      children: [
        Row(children: [box(), const SizedBox(width: 12), box()]),
        const SizedBox(height: 12),
        Row(children: [box(), const SizedBox(width: 12), box()]),
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onRetry;
  const _EmptyState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        children: [
          const Icon(Icons.inbox_rounded, size: 40, color: _C.muted),
          const SizedBox(height: 12),
          const Text(
            'No property types found',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w700, color: _C.ink),
          ),
          const SizedBox(height: 4),
          const Text(
            'Reload the list. If it stays empty, contact support.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: _C.muted),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text('Retry'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColor.primer,
              side: BorderSide(color: AppColor.primer.withOpacity(0.4)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}