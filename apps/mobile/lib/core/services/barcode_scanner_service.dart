import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

/// Barcode scanner service provider
final barcodeScannerServiceProvider = Provider<BarcodeScannerService>((ref) {
  return BarcodeScannerService();
});

/// Barcode scanner service
class BarcodeScannerService {
  /// Show the barcode scanner and return the scanned code
  Future<String?> scanBarcode(BuildContext context) async {
    final result = await Navigator.of(context).push<String>(
      MaterialPageRoute(
        builder: (context) => const _BarcodeScannerPage(),
      ),
    );
    return result;
  }
}

/// Internal barcode scanner page
class _BarcodeScannerPage extends StatefulWidget {
  const _BarcodeScannerPage();

  @override
  State<_BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<_BarcodeScannerPage> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );
  bool _hasScanned = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_hasScanned) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final barcode = barcodes.first;
      if (barcode.rawValue != null) {
        _hasScanned = true;
        Navigator.of(context).pop(barcode.rawValue);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Barcode'),
        actions: [
          IconButton(
            icon: Icon(
              _controller.torchEnabled ? Icons.flash_on : Icons.flash_off,
            ),
            onPressed: () {
              _controller.toggleTorch();
              setState(() {});
            },
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: () => _controller.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),
          // Scanning overlay
          Center(
            child: Container(
              width: 280,
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          // Instructions
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: const Text(
                'Position the barcode within the frame',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Manual entry button
          Positioned(
            bottom: 32,
            left: 24,
            right: 24,
            child: ElevatedButton.icon(
              onPressed: () => _showManualEntryDialog(context),
              icon: const Icon(Icons.keyboard),
              label: const Text('Enter Manually'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showManualEntryDialog(BuildContext context) async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Enter Barcode'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Enter barcode number',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.text,
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              Navigator.of(context).pop(value);
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Navigator.of(context).pop(controller.text);
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if (result != null && mounted) {
      Navigator.of(context).pop(result);
    }
  }
}
