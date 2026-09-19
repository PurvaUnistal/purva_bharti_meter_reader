import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meter_reader_new/Utils/common_widgets/background_widget.dart';
import 'package:meter_reader_new/Utils/common_widgets/logout_widget.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/app_bar_widget.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/app_color.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/app_config.dart';
import 'package:meter_reader_new/features/Home/domain/bloc/home_bloc.dart';
import 'package:meter_reader_new/features/Home/domain/bloc/home_event.dart';
import 'package:meter_reader_new/features/Home/domain/bloc/home_state.dart';
import 'package:meter_reader_new/features/Home/domain/model/propert_type_model.dart';
import 'package:meter_reader_new/features/billingRequest/presentation/billing_request_page.dart';

// ── Design tokens ────────────────────────────────────────────────
class _C {
  static const ink = Color(0xFF141A17);
  static const muted = Color(0xFF6B7684);
  static const faint = Color(0xFF9AA4AD);
  static const line = Color(0xFFE7EBEE);
  static const surface = Colors.white;
  
  static const accentSoft = Color(0xFFE9F2EF);
  static const skeleton = Color(0xFFEDF0F2);
}

IconData _iconFor(String? code) {
  switch (code) {
    case 'dom':
      return Icons.home_rounded;
    case 'com':
      return Icons.apartment_rounded;
    case 'indus':
      return Icons.factory_rounded;
    default:
      return Icons.category_rounded;
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PropertyTypeModel? selected ;

  @override
  void initState() {
    BlocProvider.of<HomeBloc>(context)
        .add(HomePageLoadingEvent(context: context));
    super.initState();
  }

  void _onContinue() {
    AppConfig.instanceInit()?.setPropertyCategoryId(val: selected ?? PropertyTypeModel());
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const BillingRequestPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "Property type",
        boolLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => const LogoutWidget(),
              );
            },
            icon: const Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: BackgroundWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state is! HomeFetchDataState) {
                      return const _SkeletonList();
                    }

                    final types = state.listOfPropertyType;
                    if (types.isEmpty) {
                      return const _EmptyState();
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
                      itemCount: types.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final t = types[i];
                        return _PropertyRow(
                          type: t,
                          selected: selected?.id == t.id,
                          onTap: t.isActive
                              ? () => setState(() => selected = t)
                              : null,
                        );
                      },
                    );
                  },
                ),
              ),

              // Pinned footer
              Container(
                decoration: const BoxDecoration(
                  color: _C.surface,
                  border: Border(top: BorderSide(color: _C.line, width: 1)),
                ),
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
                child: SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: selected == null ? null : _onContinue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primer,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: const Color(0xFFCBD3D8),
                      disabledForegroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                    child: const Text('Continue'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Row ──────────────────────────────────────────────────────────
class _PropertyRow extends StatelessWidget {
  final PropertyTypeModel type;
  final bool selected;
  final VoidCallback? onTap;

  const _PropertyRow({
    required this.type,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;

    return Opacity(
      opacity: disabled ? 0.5 : 1,
      child: Material(
        color: selected ? _C.accentSoft : _C.surface,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: AppColor.primer.withOpacity(0.06),
          highlightColor: AppColor.primer.withOpacity(0.04),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            constraints: const BoxConstraints(minHeight: 76),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected ? AppColor.primer : _C.line,
                width: selected ? 1.6 : 1.2,
              ),
              boxShadow: selected
                  ? [
                BoxShadow(
                  color: AppColor.primer.withOpacity(0.10),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ]
                  : const [],
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: selected ? Colors.white : _C.accentSoft,
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(_iconFor(type.propCode),
                      color: AppColor.primer, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        type.name ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _C.ink,
                        ),
                      ),

                    ],
                  ),
                ),
                _RadioDot(selected: selected),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RadioDot extends StatelessWidget {
  final bool selected;
  const _RadioDot({required this.selected});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: selected ? AppColor.primer : Colors.transparent,
        border: Border.all(
          color: selected ? AppColor.primer : _C.line,
          width: 2,
        ),
      ),
      child: selected
          ? const Icon(Icons.check_rounded, size: 15, color: Colors.white)
          : null,
    );
  }
}

// ── Loading skeleton ─────────────────────────────────────────────
class _SkeletonList extends StatelessWidget {
  const _SkeletonList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => Container(
        height: 76,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _C.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _C.line, width: 1.2),
        ),
        child: Row(
          children: [
            _bar(48, 48, radius: 13),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _bar(140, 13),
                const SizedBox(height: 8),
                _bar(60, 10),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _bar(double w, double h, {double radius = 6}) => Container(
    width: w,
    height: h,
    decoration: BoxDecoration(
      color: _C.skeleton,
      borderRadius: BorderRadius.circular(radius),
    ),
  );
}

// ── Empty state ──────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: _C.accentSoft,
              borderRadius: BorderRadius.circular(18),
            ),
            child:  Icon(Icons.inbox_rounded, color: AppColor.primer, size: 28),
          ),
          const SizedBox(height: 16),
          const Text(
            'No property types available',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: _C.ink),
          ),
          const SizedBox(height: 4),
          const Text(
            'Try again later or contact support.',
            style: TextStyle(fontSize: 14, color: _C.muted),
          ),
        ],
      ),
    );
  }
}