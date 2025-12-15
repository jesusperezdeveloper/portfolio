import 'package:equatable/equatable.dart';
import 'package:portfolio_jps/shared/widgets/code_viewer/models/source_code_model.dart';

/// Base state class for the CodeViewer feature.
sealed class CodeViewerState extends Equatable {
  const CodeViewerState();

  @override
  List<Object?> get props => [];
}

/// Initial state when no code viewer is active.
class CodeViewerInitial extends CodeViewerState {
  const CodeViewerInitial();
}

/// State during the panel opening animation.
class CodeViewerOpening extends CodeViewerState {
  const CodeViewerOpening({
    required this.sourceCode,
    required this.activeFileIndex,
  });

  /// The source code to display.
  final SourceCodeModel sourceCode;

  /// Index of the currently active file (0 for main, 1+ for related files).
  final int activeFileIndex;

  /// Gets the currently active source code model.
  SourceCodeModel get activeSourceCode {
    if (activeFileIndex == 0) return sourceCode;
    if (activeFileIndex - 1 < sourceCode.relatedFiles.length) {
      return sourceCode.relatedFiles[activeFileIndex - 1];
    }
    return sourceCode;
  }

  @override
  List<Object?> get props => [sourceCode, activeFileIndex];
}

/// State when the panel is open and displaying code.
class CodeViewerOpen extends CodeViewerState {
  const CodeViewerOpen({
    required this.sourceCode,
    required this.activeFileIndex,
    required this.isTypingComplete,
    this.visibleCharacters = 0,
  });

  /// The source code to display.
  final SourceCodeModel sourceCode;

  /// Index of the currently active file (0 for main, 1+ for related files).
  final int activeFileIndex;

  /// Whether the typing animation has completed.
  final bool isTypingComplete;

  /// Number of characters currently visible during typing animation.
  final int visibleCharacters;

  /// Gets the currently active source code model.
  SourceCodeModel get activeSourceCode {
    if (activeFileIndex == 0) return sourceCode;
    if (activeFileIndex - 1 < sourceCode.relatedFiles.length) {
      return sourceCode.relatedFiles[activeFileIndex - 1];
    }
    return sourceCode;
  }

  /// Gets all available files (main + related).
  List<SourceCodeModel> get allFiles => [sourceCode, ...sourceCode.relatedFiles];

  /// Total number of files available.
  int get fileCount => 1 + sourceCode.relatedFiles.length;

  /// Creates a copy with updated values.
  CodeViewerOpen copyWith({
    SourceCodeModel? sourceCode,
    int? activeFileIndex,
    bool? isTypingComplete,
    int? visibleCharacters,
  }) {
    return CodeViewerOpen(
      sourceCode: sourceCode ?? this.sourceCode,
      activeFileIndex: activeFileIndex ?? this.activeFileIndex,
      isTypingComplete: isTypingComplete ?? this.isTypingComplete,
      visibleCharacters: visibleCharacters ?? this.visibleCharacters,
    );
  }

  @override
  List<Object?> get props => [
        sourceCode,
        activeFileIndex,
        isTypingComplete,
        visibleCharacters,
      ];
}

/// State after successfully copying code to clipboard.
class CodeViewerCopied extends CodeViewerState {
  const CodeViewerCopied({
    required this.previousState,
  });

  /// The state before the copy action.
  final CodeViewerOpen previousState;

  @override
  List<Object?> get props => [previousState];
}

/// State during the panel closing animation.
class CodeViewerClosing extends CodeViewerState {
  const CodeViewerClosing();
}

/// State when the panel is closed.
class CodeViewerClosed extends CodeViewerState {
  const CodeViewerClosed();
}
