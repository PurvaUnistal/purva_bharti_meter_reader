import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:meter_reader_new/features/billPrint/domain/bloc/bill_print_bloc.dart';

/// Shown when the "Nearby devices" (Bluetooth) permission is not granted.
class BluetoothPermissionView extends StatelessWidget {
  final bool permanentlyDenied;

  const BluetoothPermissionView({Key? key, required this.permanentlyDenied})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: primary.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.bluetooth_disabled_rounded,
                  size: 36, color: primary),
            ),
            const SizedBox(height: 16),
            const Text(
              'Allow Nearby devices to print',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              permanentlyDenied
                  ? 'Open Settings, go to Permissions, and turn on Nearby devices. Then come back and tap Try again.'
                  : 'The app needs the Nearby devices permission to find and connect to your Bluetooth printer.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
            ),
            const SizedBox(height: 20),
            if (permanentlyDenied)
              FilledButton.icon(
                onPressed: openAppSettings,
                icon: const Icon(Icons.settings_rounded, size: 18),
                label: const Text('Open settings'),
              ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => context
                  .read<BillPrintBloc>()
                  .add(BillReloadPage(context: context)),
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(permanentlyDenied ? 'Try again' : 'Allow permission'),
            ),
          ],
        ),
      ),
    );
  }
}