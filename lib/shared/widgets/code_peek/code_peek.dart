/// Code Peek Feature - Dev Mode for viewing component source code.
///
/// This feature allows developers and technical recruiters to peek at
/// the source code of individual components in the portfolio.
///
/// ## Setup
///
/// 1. Add [DevModeCubit] to your app's BlocProviders:
/// ```dart
/// BlocProvider(create: (_) => DevModeCubit()),
/// ```
///
/// 2. Add [DevModeToggle] to your navbar:
/// ```dart
/// DevModeToggle(), // Full version with "DEV" label
/// // or
/// DevModeToggleCompact(), // Icon only
/// ```
///
/// 3. Add [CodePeekOverlay] to your app (listens for selections):
/// ```dart
/// Stack(
///   children: [
///     YourApp(),
///     const CodePeekOverlay(),
///   ],
/// )
/// ```
///
/// ## Usage
///
/// Wrap any component with [CodePeekWrapper]:
/// ```dart
/// CodePeekWrapper(
///   componentCode: ComponentCodes.animatedButton,
///   child: AnimatedButton(
///     text: 'Contact Me',
///     onPressed: () {},
///   ),
/// )
/// ```
///
/// When Dev Mode is enabled:
/// - Components show a dotted border and code icon on hover
/// - Clicking opens a modal with the source code
/// - Source code has syntax highlighting
/// - Users can copy code or view on GitHub
library code_peek;

import 'package:portfolio_jps/shared/widgets/code_peek/code_peek.dart' show CodePeekOverlay, CodePeekWrapper, DevModeCubit, DevModeToggle;

export 'cubit/dev_mode_cubit.dart';
export 'cubit/dev_mode_state.dart';
export 'data/component_codes.dart';
export 'models/component_code.dart';
export 'presentation/code_peek_modal.dart';
export 'presentation/code_peek_overlay.dart';
export 'presentation/code_peek_wrapper.dart';
export 'presentation/dev_mode_toggle.dart';
