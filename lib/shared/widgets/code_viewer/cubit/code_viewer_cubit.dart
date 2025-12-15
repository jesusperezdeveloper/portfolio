import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio_jps/shared/widgets/code_viewer/cubit/code_viewer_state.dart';
import 'package:portfolio_jps/shared/widgets/code_viewer/models/source_code_model.dart';

/// Cubit for managing the CodeViewer state and interactions.
///
/// Handles opening/closing the panel, switching between files,
/// managing the typing animation, and copying code to clipboard.
class CodeViewerCubit extends Cubit<CodeViewerState> {
  CodeViewerCubit() : super(const CodeViewerInitial());

  /// Opens the code viewer panel with the given source code.
  ///
  /// Emits [CodeViewerOpening] briefly for the entry animation,
  /// then [CodeViewerOpen] with typing animation starting.
  void openViewer(SourceCodeModel sourceCode) {
    emit(CodeViewerOpening(sourceCode: sourceCode, activeFileIndex: 0));

    // After a brief delay, transition to open state
    Future.delayed(const Duration(milliseconds: 50), () {
      if (state is CodeViewerOpening) {
        emit(
          CodeViewerOpen(
            sourceCode: sourceCode,
            activeFileIndex: 0,
            isTypingComplete: false,
          ),
        );
      }
    });
  }

  /// Closes the code viewer panel.
  ///
  /// Emits [CodeViewerClosing] for the exit animation,
  /// then [CodeViewerClosed] after animation completes.
  void closeViewer() {
    emit(const CodeViewerClosing());

    // After animation, set to closed state
    Future.delayed(const Duration(milliseconds: 300), () {
      if (state is CodeViewerClosing) {
        emit(const CodeViewerClosed());
      }
    });
  }

  /// Switches to a different file tab.
  ///
  /// [index] is 0 for the main file, 1+ for related files.
  void switchFile(int index) {
    final currentState = state;
    if (currentState is CodeViewerOpen) {
      if (index >= 0 && index < currentState.fileCount) {
        emit(
          currentState.copyWith(
            activeFileIndex: index,
            isTypingComplete: false,
            visibleCharacters: 0,
          ),
        );
      }
    }
  }

  /// Updates the visible characters count during typing animation.
  void updateTypingProgress(int characters) {
    final currentState = state;
    if (currentState is CodeViewerOpen && !currentState.isTypingComplete) {
      final totalChars = currentState.activeSourceCode.code.length;
      final isComplete = characters >= totalChars;

      emit(
        currentState.copyWith(
          visibleCharacters: characters,
          isTypingComplete: isComplete,
        ),
      );
    }
  }

  /// Marks the typing animation as complete.
  void completeTyping() {
    final currentState = state;
    if (currentState is CodeViewerOpen) {
      emit(
        currentState.copyWith(
          isTypingComplete: true,
          visibleCharacters: currentState.activeSourceCode.code.length,
        ),
      );
    }
  }

  /// Skips the typing animation and shows all code immediately.
  void skipAnimation() {
    final currentState = state;
    if (currentState is CodeViewerOpen && !currentState.isTypingComplete) {
      emit(
        currentState.copyWith(
          isTypingComplete: true,
          visibleCharacters: currentState.activeSourceCode.code.length,
        ),
      );
    }
  }

  /// Copies the current code to clipboard.
  ///
  /// Emits [CodeViewerCopied] temporarily to show feedback,
  /// then returns to [CodeViewerOpen].
  Future<void> copyCode() async {
    final currentState = state;
    if (currentState is CodeViewerOpen) {
      await Clipboard.setData(
        ClipboardData(text: currentState.activeSourceCode.code),
      );

      emit(CodeViewerCopied(previousState: currentState));

      // Return to normal state after showing feedback
      Future.delayed(const Duration(seconds: 2), () {
        if (state is CodeViewerCopied) {
          final copiedState = state as CodeViewerCopied;
          emit(copiedState.previousState);
        }
      });
    }
  }

  /// Resets the cubit to initial state.
  void reset() {
    emit(const CodeViewerInitial());
  }
}
