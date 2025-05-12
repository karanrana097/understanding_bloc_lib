import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whiteboard/whiteboard.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whiteboard App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const WhiteboardScreen(),
    );
  }
}

class WhiteboardScreen extends StatefulWidget {
  const WhiteboardScreen({Key? key}) : super(key: key);

  @override
  State<WhiteboardScreen> createState() => _WhiteboardScreenState();
}

class _WhiteboardScreenState extends State<WhiteboardScreen> {
  final GlobalKey _whiteboardKey = GlobalKey();
  final WhiteBoardController _controller = WhiteBoardController();
  Color _selectedColor = Colors.black;
  double _strokeWidth = 3.0;
  bool _isLoading = false;

  final List<Color> _colors = [
    Colors.black,
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Whiteboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveToGallery,
            tooltip: 'Save to Gallery',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _controller.clear,
            tooltip: 'Clear Board',
          ),
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: _controller.undo,
            tooltip: 'Undo',
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: RepaintBoundary(
                  key: _whiteboardKey,
                  child: Container(
                    color: Colors.white,
                    child: WhiteBoard(
                      controller: _controller,
                      strokeWidth: _strokeWidth,
                      strokeColor: _selectedColor,
                      backgroundColor: Colors.white,
                      isErasing: false,
                    ),
                  ),
                ),
              ),
              _buildColorPalette(),
              _buildStrokeSlider(),
              const SizedBox(height: 8),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildColorPalette() {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _colors.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedColor = _colors[index];
              });
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _colors[index],
                shape: BoxShape.circle,
                border: Border.all(
                  color: _selectedColor == _colors[index]
                      ? Colors.blue
                      : Colors.grey,
                  width: _selectedColor == _colors[index] ? 3 : 1,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStrokeSlider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          const Icon(Icons.line_weight, size: 20),
          Expanded(
            child: Slider(
              value: _strokeWidth,
              min: 1.0,
              max: 20.0,
              divisions: 19,
              label: _strokeWidth.round().toString(),
              onChanged: (value) {
                setState(() {
                  _strokeWidth = value;
                });
              },
            ),
          ),
          Text('${_strokeWidth.round()}px'),
        ],
      ),
    );
  }

  Future<void> _saveToGallery() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var status = await Permission.storage.request();
      if (!status.isGranted) {
        _showMessage('Storage permission is required to save the image');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final boundary = _whiteboardKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final buffer = byteData!.buffer.asUint8List();

      final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(buffer),
        quality: 100,
        name: 'whiteboard_${DateTime.now().millisecondsSinceEpoch}',
      );

      if ((result['isSuccess'] ?? false) == true) {
        _showMessage('Drawing saved to gallery');
      } else {
        _showMessage('Failed to save drawing');
      }
    } catch (e) {
      _showMessage('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
