/// Code Viewer Feature
///
/// An interactive code viewer that displays source code with syntax
/// highlighting, typing animation, and glassmorphism design.
///
/// ## Usage
///
/// ### Option 1: Using CodeViewerWrapper (Recommended)
/// Wrap your section content with [CodeViewerWrapper]:
/// ```dart
/// CodeViewerWrapper(
///   sourceCode: CodeSnippets.heroSection,
///   child: HeroSectionContent(),
/// )
/// ```
///
/// ### Option 2: Manual integration with Stack
/// Add [CodeViewerButton] to a Stack with your content:
/// ```dart
/// BlocProvider(
///   create: (_) => CodeViewerCubit(),
///   child: Stack(
///     children: [
///       YourSectionContent(),
///       Positioned(
///         right: 24,
///         bottom: 24,
///         child: CodeViewerButton(
///           sourceCode: CodeSnippets.heroSection,
///         ),
///       ),
///     ],
///   ),
/// )
/// ```
///
/// ## Features
/// - Syntax highlighting with VS Code Dark+ theme
/// - Typing animation for code reveal
/// - File tabs for related files
/// - Copy to clipboard
/// - Direct GitHub links
/// - Responsive: bottom sheet on mobile, panel on desktop
/// - Keyboard shortcuts (Escape to close)
library code_viewer;

import 'package:portfolio_jps/shared/widgets/code_viewer/code_viewer.dart' show CodeViewerButton, CodeViewerWrapper;
import 'package:portfolio_jps/shared/widgets/code_viewer/presentation/code_viewer_button.dart' show CodeViewerButton, CodeViewerWrapper;

export 'cubit/code_viewer_cubit.dart';
export 'cubit/code_viewer_state.dart';
export 'models/source_code_model.dart';
export 'presentation/code_display.dart';
export 'presentation/code_footer.dart';
export 'presentation/code_header.dart';
export 'presentation/code_viewer_button.dart';
export 'presentation/code_viewer_panel.dart';
export 'presentation/typing_animation.dart';
export 'utils/code_snippets.dart';
export 'utils/syntax_highlighter.dart';
