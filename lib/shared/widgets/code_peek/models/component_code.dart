import 'package:equatable/equatable.dart';
import 'package:portfolio_jps/shared/widgets/code_peek/code_peek.dart' show CodePeekWrapper;
import 'package:portfolio_jps/shared/widgets/code_peek/presentation/code_peek_wrapper.dart' show CodePeekWrapper;

/// Model representing the source code information for a component.
///
/// Used by [CodePeekWrapper] to display code when Dev Mode is active.
class ComponentCode extends Equatable {
  const ComponentCode({
    required this.id,
    required this.name,
    required this.code,
    this.description,
    this.filePath,
    this.githubUrl,
  });

  /// Unique identifier for the component.
  final String id;

  /// Display name of the component (e.g., "AnimatedButton").
  final String name;

  /// The source code to display.
  final String code;

  /// Optional description of what the component does.
  final String? description;

  /// Optional relative file path (e.g., "lib/shared/widgets/animated_button.dart").
  final String? filePath;

  /// Optional direct GitHub URL to the source file.
  final String? githubUrl;

  /// Number of lines in the code.
  int get lineCount => code.split('\n').length;

  /// Approximate size in KB.
  String get sizeLabel {
    final bytes = code.length;
    if (bytes < 1024) {
      return '$bytes B';
    }
    return '${(bytes / 1024).toStringAsFixed(1)} KB';
  }

  @override
  List<Object?> get props => [id, name, code, description, filePath, githubUrl];
}
