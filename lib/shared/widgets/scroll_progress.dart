import 'dart:async';

import 'package:flutter/material.dart';
import 'package:portfolio_jps/core/theme/app_colors.dart';

/// A vertical scroll progress indicator displayed on the right edge of the
/// screen. Shows a thin bar that fills based on scroll position, with a small
/// circle indicator at the current scroll point.
///
/// Only visible on desktop viewports (width > 1024px). Fades in after the user
/// has scrolled past 100px and fades out after 2 seconds of inactivity.
class ScrollProgress extends StatefulWidget {
  const ScrollProgress({
    required this.scrollController,
    super.key,
  });

  final ScrollController scrollController;

  @override
  State<ScrollProgress> createState() => _ScrollProgressState();
}

class _ScrollProgressState extends State<ScrollProgress> {
  double _progress = 0;
  bool _visible = false;
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_onScroll);
    _hideTimer?.cancel();
    super.dispose();
  }

  void _onScroll() {
    final controller = widget.scrollController;
    if (!controller.hasClients) return;

    final maxExtent = controller.position.maxScrollExtent;
    if (maxExtent <= 0) return;

    final offset = controller.offset;
    final newProgress = (offset / maxExtent).clamp(0.0, 1.0);
    final shouldShow = offset > 100;

    setState(() {
      _progress = newProgress;
      _visible = shouldShow;
    });

    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _visible = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    // Only visible on desktop
    if (screenWidth <= 1024) {
      return const SizedBox.shrink();
    }

    return Positioned(
      right: 0,
      top: 60,
      bottom: 60,
      child: AnimatedOpacity(
        opacity: _visible ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        child: SizedBox(
          width: 20,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final trackHeight = constraints.maxHeight;
              final indicatorY = trackHeight * _progress;

              return Stack(
                clipBehavior: Clip.none,
                children: [
                  // Track background
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    width: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0x0FFFFFFF),
                        borderRadius: BorderRadius.circular(1.5),
                      ),
                    ),
                  ),

                  // Filled portion
                  Positioned(
                    right: 0,
                    top: 0,
                    width: 3,
                    height: trackHeight * _progress,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(1.5),
                        gradient: const LinearGradient(
                          colors: [
                            AppColors.accent, // #00d4ff
                            AppColors.secondaryEnd, // #8b5cf6
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),

                  // Circle indicator at current position
                  Positioned(
                    right: -1.5,
                    top: indicatorY - 3,
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accent.withValues(alpha: 0.6),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
