import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meter_reader_new/Utils/common_widgets/res/environment_config.dart';
import 'package:meter_reader_new/features/billHistory/domain/model/bill_history_model.dart';
import 'package:meter_reader_new/features/billPrint/domain/bloc/bill_print_bloc.dart';
import 'package:meter_reader_new/features/billPrint/presentation/pages/bill_printer_page.dart';

/// Compact bill card (~130px tall).
///
///  (👤)  Customer                     [🖨 Print]
///        Ramesh Kumar
///        BP 1234567890
///  ┌──────────────────────┬───────────────────┐
///  │ ⏲ MTR-0091           │ ☎ 98xxxxxx21      │
///  └──────────────────────┴───────────────────┘
///  ⌂ 12, Shanti Nagar                  Bill #4521
class BillHistoryBoxWidget extends StatelessWidget {
  final BillHistoryModel billHistoryData;
  final String schema;
  final String userId;

  const BillHistoryBoxWidget({
    Key? key,
    required this.billHistoryData,
    required this.userId,
    required this.schema,
  }) : super(key: key);

  static const Color _ink = Color(0xFF1F2937);
  static const Color _muted = Color(0xFF6B7280);
  static const Color _line = Color(0xFFE9ECF1);

  // ---------------- Data helpers ----------------

  String _clean(dynamic v) {
    final s = v?.toString().trim() ?? '';
    return (s.isEmpty || s.toLowerCase() == 'null') ? '' : s;
  }

  String _orDash(String s) => s.isEmpty ? '—' : s;

  String get _name => [
    _clean(billHistoryData.fistName),
    _clean(billHistoryData.lastName),
  ].where((e) => e.isNotEmpty).join(' ');

  String get _address => [
    _clean(billHistoryData.houseNumber),
    _clean(billHistoryData.locality),
  ].where((e) => e.isNotEmpty).join(', ');

  String get _initials {
    final parts = _name.split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    final letters = parts.take(2).map((p) => p[0].toUpperCase()).join();
    return letters.isEmpty ? '?' : letters;
  }

  // ---------------- Actions ----------------

  void _copyBp(BuildContext context, String bp) {
    if (bp.isEmpty) return;
    Clipboard.setData(ClipboardData(text: bp));
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text('BP number $bp copied'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ));
  }

  void _print(BuildContext context) {
    BlocProvider.of<BillPrintBloc>(context).add(
      BillPrintPageLoaderEvent(
        context: context,
        billId: billHistoryData.billId.toString(),
        schema: schema,
      ),
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => BillPrinterPage()),
    );
  }

  // ---------------- Build ----------------

  @override
  Widget build(BuildContext context) {
    final config = EnvironmentConfig.of(context);
    final primary = config?.primaryTheme ?? Colors.green.shade800;
    final secondary = config?.secondaryTheme ?? primary;

    final bp = _clean(billHistoryData.bpNumber);
    final billId = _clean(billHistoryData.billId);

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 5, 12, 5),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _line),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.07),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ---- Row 1: avatar, name + BP, print ----
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _avatar(primary, secondary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _name.isEmpty ? 'Unnamed customer' : _name,
                      softWrap: true,
                      style: const TextStyle(
                        color: _ink,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _bpChip(context, primary, bp),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _printButton(context, primary, secondary),
            ],
          ),

          const SizedBox(height: 10),

          // ---- Row 2: meter | mobile ----
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _mini(
                    Icons.speed_rounded,
                    _orDash(_clean(billHistoryData.meterNumber)),
                    primary,
                  ),
                ),
                Container(
                  width: 1,
                  height: 18,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  color: primary.withOpacity(0.15),
                ),
                Expanded(
                  child: _mini(
                    Icons.phone_rounded,
                    _orDash(_clean(billHistoryData.mobileNumber)),
                    primary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // ---- Row 3: address + bill id ----
          Row(
            children: [
              const Icon(Icons.location_on_rounded, size: 15, color: _muted),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  _orDash(_address),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (billId.isNotEmpty) ...[
                const SizedBox(width: 8),
                Text(
                  'Bill #$billId',
                  style: const TextStyle(
                    color: _muted,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- Pieces ----------------

  /// Simple person icon instead of initials, so it reads as "customer".
  Widget _avatar(Color primary, Color secondary) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: primary.withOpacity(0.10),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.person_rounded, size: 22, color: primary),
    );
  }

  Widget _bpChip(BuildContext context, Color primary, String bp) {
    return GestureDetector(
      onLongPress: () => _copyBp(context, bp),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'BP ',
            style: TextStyle(
              color: primary.withOpacity(0.7),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          Flexible(
            child: Text(
              _orDash(bp),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: primary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mini(IconData icon, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: _ink,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ],
    );
  }

  /// Labelled button so it is clear what it does.
  Widget _printButton(BuildContext context, Color primary, Color secondary) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [secondary, primary],
        ),
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          splashColor: Colors.white24,
          onTap: () => _print(context),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.print_rounded, size: 17, color: Colors.white),
                SizedBox(width: 6),
                Text(
                  'Print',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
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