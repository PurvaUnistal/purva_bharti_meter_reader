import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Sirf ek kaam: photo par Latitude, Longitude, Address, Date-Time draw karna.
class ImageStampHelper {
  static Future<File> stamp({
    required File file,
    required double latitude,
    required double longitude,
    String? address,
  }) async {
    final now = DateTime.now();
    final cleanAddress = _cleanAddress(address);

    final lines = <String>[
      'Latitude: ${latitude.toStringAsFixed(6)}, '
          'Longitude: ${longitude.toStringAsFixed(6)}',
      if (cleanAddress.isNotEmpty) 'Address: $cleanAddress',
      DateFormat('dd-MM-yyyy  hh:mm:ss a').format(now),
    ];

    final bytes = await file.readAsBytes();
    final stamped =
    await compute(_drawStamp, {'bytes': bytes, 'lines': lines});

    final dir = await getTemporaryDirectory();
    final out =
    File(p.join(dir.path, 'stamped_${now.millisecondsSinceEpoch}.jpg'));
    await out.writeAsBytes(stamped);
    return out;
  }

  /// Address se "null", khaali parts aur non-English characters hatao.
  static String _cleanAddress(String? address) {
    if (address == null) return '';
    return address
        .replaceAll(RegExp(r'[^\x20-\x7E]'), '') // font sirf English draw karta hai
        .split(',')
        .map((e) => e.replaceAll('null', '').trim())
        .where((e) => e.isNotEmpty)
        .join(', ');
  }
}

/// Top-level hona zaroori hai, compute() ke liye.
Uint8List _drawStamp(Map<String, dynamic> args) {
  final Uint8List bytes = args['bytes'] as Uint8List;
  final List<String> rawLines = List<String>.from(args['lines'] as List);

  img.Image? decoded = img.decodeImage(bytes);
  if (decoded == null) throw Exception('Could not read image');

  final img.Image image = img.bakeOrientation(decoded);

  final img.BitmapFont font =
  image.width > 1500 ? img.arial_48 : img.arial_24;
  const int padding = 14;
  final int maxWidth = image.width - padding * 2;

  int textWidth(String text) {
    int w = 0;
    for (final c in text.codeUnits) {
      final ch = font.characters[c];
      w += ch != null ? ch.xadvance : font.size ~/ 2;
    }
    return w;
  }

  // Lambi lines ko width ke hisaab se tod do.
  final lines = <String>[];
  for (final line in rawLines) {
    String current = '';
    for (final word in line.split(' ')) {
      final test = current.isEmpty ? word : '$current $word';
      if (textWidth(test) > maxWidth && current.isNotEmpty) {
        lines.add(current);
        current = word;
      } else {
        current = test;
      }
    }
    if (current.isNotEmpty) lines.add(current);
  }

  final int lineHeight = font.lineHeight + 6;
  final int boxHeight = lines.length * lineHeight + padding * 2;
  final int top = image.height - boxHeight;

  // Semi-transparent black strip at the bottom.
  img.fillRect(
    image,
    0,
    top,
    image.width - 1,
    image.height - 1,
    img.getColor(0, 0, 0, 160),
  );

  // White text.
  final int white = img.getColor(255, 255, 255);
  for (var i = 0; i < lines.length; i++) {
    img.drawString(
      image,
      font,
      padding,
      top + padding + i * lineHeight,
      lines[i],
      color: white,
    );
  }

  return Uint8List.fromList(img.encodeJpg(image, quality: 85));
}