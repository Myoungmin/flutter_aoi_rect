import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class AoiState {
  final double width;
  final double height;
  final double offsetX;
  final double offsetY;
  final double aoiWidth;
  final double aoiHeight;

  AoiState({
    required this.width,
    required this.height,
    required this.offsetX,
    required this.offsetY,
    required this.aoiWidth,
    required this.aoiHeight,
  });

  AoiState copyWith({
    double? width,
    double? height,
    double? offsetX,
    double? offsetY,
    double? aoiWidth,
    double? aoiHeight,
  }) {
    return AoiState(
      width: width ?? this.width,
      height: height ?? this.height,
      offsetX: offsetX ?? this.offsetX,
      offsetY: offsetY ?? this.offsetY,
      aoiWidth: aoiWidth ?? this.aoiWidth,
      aoiHeight: aoiHeight ?? this.aoiHeight,
    );
  }
}

class AoiNotifier extends Notifier<AoiState> {
  @override
  AoiState build() {
    return AoiState(
      width: 3840,
      height: 2160,
      offsetX: 500,
      offsetY: 700,
      aoiWidth: 1920,
      aoiHeight: 1080,
    );
  }

  void update(
      {double? width,
      double? height,
      double? offsetX,
      double? offsetY,
      double? aoiWidth,
      double? aoiHeight}) {
    state = state.copyWith(
      width: width,
      height: height,
      offsetX: offsetX,
      offsetY: offsetY,
      aoiWidth: aoiWidth,
      aoiHeight: aoiHeight,
    );
  }
}

final aoiProvider =
    NotifierProvider<AoiNotifier, AoiState>(() => AoiNotifier());

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Rectangle with AOI')),
        body: const Column(
          children: [
            Expanded(child: Center(child: AoiRect())),
            AoiControls(),
          ],
        ),
      ),
    );
  }
}

class AoiRect extends ConsumerWidget {
  const AoiRect({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aoi = ref.watch(aoiProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final scaleX = constraints.maxWidth / aoi.width;
        final scaleY = constraints.maxHeight / aoi.height;
        final scale = scaleX < scaleY ? scaleX : scaleY;

        final rectWidth = aoi.width * scale;
        final rectHeight = aoi.height * scale;
        final aoiLeft = aoi.offsetX * scale;
        final aoiTop = aoi.offsetY * scale;
        final aoiRectWidth = aoi.aoiWidth * scale;
        final aoiRectHeight = aoi.aoiHeight * scale;

        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: rectWidth,
              height: rectHeight,
              color: Colors.blue.withOpacity(0.5),
            ),
            Positioned(
              left: aoiLeft,
              top: aoiTop,
              child: Container(
                width: aoiRectWidth,
                height: aoiRectHeight,
                color: Colors.amber.withOpacity(0.5),
              ),
            ),
          ],
        );
      },
    );
  }
}

class AoiControls extends ConsumerWidget {
  const AoiControls({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aoiNotifier = ref.read(aoiProvider.notifier);

    Widget buildTextField(
        String label, double value, Function(String) onChanged) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: TextField(
          decoration: InputDecoration(
              labelText: label, border: const OutlineInputBorder()),
          keyboardType: TextInputType.number,
          controller: TextEditingController(text: value.toString()),
          onSubmitted: onChanged,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          buildTextField('Width', ref.watch(aoiProvider).width,
              (val) => aoiNotifier.update(width: double.tryParse(val))),
          buildTextField('Height', ref.watch(aoiProvider).height,
              (val) => aoiNotifier.update(height: double.tryParse(val))),
          buildTextField('Offset X', ref.watch(aoiProvider).offsetX,
              (val) => aoiNotifier.update(offsetX: double.tryParse(val))),
          buildTextField('Offset Y', ref.watch(aoiProvider).offsetY,
              (val) => aoiNotifier.update(offsetY: double.tryParse(val))),
          buildTextField('AOI Width', ref.watch(aoiProvider).aoiWidth,
              (val) => aoiNotifier.update(aoiWidth: double.tryParse(val))),
          buildTextField('AOI Height', ref.watch(aoiProvider).aoiHeight,
              (val) => aoiNotifier.update(aoiHeight: double.tryParse(val))),
        ],
      ),
    );
  }
}
