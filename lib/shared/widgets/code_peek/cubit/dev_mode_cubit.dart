import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio_jps/shared/widgets/code_peek/cubit/dev_mode_state.dart';

/// Cubit that manages the global Dev Mode state.
///
/// Dev Mode allows developers/recruiters to peek at the source code
/// of individual components by clicking on them.
///
/// Usage:
/// ```dart
/// // Toggle dev mode
/// context.read<DevModeCubit>().toggle();
///
/// // Select a component to view its code
/// context.read<DevModeCubit>().selectComponent('AnimatedButton');
///
/// // Close the code viewer
/// context.read<DevModeCubit>().clearSelection();
/// ```
class DevModeCubit extends Cubit<DevModeState> {
  DevModeCubit() : super(const DevModeState.initial());

  /// Toggles Dev Mode on/off.
  void toggle() {
    emit(
      state.copyWith(
        isEnabled: !state.isEnabled,
        clearSelection: true, // Clear any selection when toggling
      ),
    );
  }

  /// Enables Dev Mode.
  void enable() {
    if (!state.isEnabled) {
      emit(state.copyWith(isEnabled: true));
    }
  }

  /// Disables Dev Mode.
  void disable() {
    if (state.isEnabled) {
      emit(state.copyWith(isEnabled: false, clearSelection: true));
    }
  }

  /// Selects a component to view its source code.
  /// This opens the modal/expanded view.
  void selectComponent(String componentId) {
    if (state.isEnabled) {
      emit(state.copyWith(selectedComponentId: componentId));
    }
  }

  /// Clears the current selection (closes the modal).
  void clearSelection() {
    emit(state.copyWith(clearSelection: true));
  }
}
