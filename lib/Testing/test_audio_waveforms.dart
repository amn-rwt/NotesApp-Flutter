import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';

class AudioWaveformTest extends StatefulWidget {
  const AudioWaveformTest({super.key});

  @override
  State<AudioWaveformTest> createState() => _AudioWaveformTestState();
}

class _AudioWaveformTestState extends State<AudioWaveformTest> {
  late PlayerController playerController;

  @override
  void initState() {
    super.initState();
    playerController = PlayerController();
  }

  double height = 30;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('TEST'),
          AnimatedContainer(
            height: height,
            duration: const Duration(milliseconds: 100),
            curve: Curves.bounceIn,
            child: IconButton(
              icon: Icon(
                Icons.mic,
                size: height,
              ),
              onPressed: () {
                setState(() {
                  (height == 30) ? height = 100 : height = 30;
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
