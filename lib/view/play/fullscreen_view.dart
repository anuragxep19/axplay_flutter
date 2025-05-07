import 'dart:async' show Timer;
import 'package:axplay/controller/video_controller.dart';
import 'package:flutter/material.dart';
import 'package:axplay/view/play/widgets/player.dart';
import 'package:axplay/view/play/widgets/tool_bar.dart';
import 'package:provider/provider.dart';

class FullscreenView extends StatefulWidget {
  const FullscreenView({super.key});

  @override
  State<FullscreenView> createState() => _FullscreenViewState();
}

class _FullscreenViewState extends State<FullscreenView> {
  final ValueNotifier<bool> _showToolbar = ValueNotifier(true);
  Timer? _hideTimer;
  @override
  void initState() {
    super.initState();

    context.read<VideoController>().fullscreenToggle();
    _startHideTimer();
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      _showToolbar.value = false;
    });
  }

  void _onTapScreen() {
    _showToolbar.value = true;
    _startHideTimer();
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _showToolbar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoController = context.watch<VideoController>();

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) => videoController.fullscreenToggle(),

      child: GestureDetector(
        onTap: _onTapScreen,
        behavior: HitTestBehavior.opaque,
        child: Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              Player(),
              Align(
                alignment: Alignment.bottomCenter,
                child: ValueListenableBuilder(
                  valueListenable: _showToolbar,
                  builder:
                      (context, visible, child) => IgnorePointer(
                        ignoring: !visible,
                        child: AnimatedOpacity(
                          opacity: visible ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: SafeArea(child: ToolBar()),
                        ),
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
