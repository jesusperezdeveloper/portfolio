import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio_jps/shared/widgets/code_peek/cubit/dev_mode_cubit.dart';
import 'package:portfolio_jps/shared/widgets/code_peek/cubit/dev_mode_state.dart';
import 'package:portfolio_jps/shared/widgets/code_peek/presentation/code_peek_modal.dart';

/// Overlay widget that listens for component selections and shows the modal.
///
/// Place this in your app's widget tree to enable the Code Peek modal:
/// ```dart
/// Stack(
///   children: [
///     YourMainContent(),
///     const CodePeekOverlay(),
///   ],
/// )
/// ```
class CodePeekOverlay extends StatelessWidget {
  const CodePeekOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DevModeCubit, DevModeState>(
      listenWhen: (previous, current) =>
          previous.selectedComponentId != current.selectedComponentId,
      listener: (context, state) {
        if (state.hasSelection) {
          showCodePeekModal(context);
        }
      },
      child: const SizedBox.shrink(),
    );
  }
}

/// Alternative: A builder widget that provides Dev Mode context.
///
/// Use this to conditionally render content based on Dev Mode state:
/// ```dart
/// DevModeBuilder(
///   builder: (context, isEnabled) {
///     return isEnabled
///         ? Text('Dev Mode is ON')
///         : const SizedBox.shrink();
///   },
/// )
/// ```
class DevModeBuilder extends StatelessWidget {
  const DevModeBuilder({
    required this.builder,
    super.key,
  });

  final Widget Function(BuildContext context, {required bool isEnabled}) builder;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DevModeCubit, DevModeState>(
      buildWhen: (previous, current) => previous.isEnabled != current.isEnabled,
      builder: (context, state) => builder(context, isEnabled: state.isEnabled),
    );
  }
}
