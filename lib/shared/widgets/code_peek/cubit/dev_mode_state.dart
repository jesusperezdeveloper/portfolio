import 'package:equatable/equatable.dart';
import 'package:portfolio_jps/shared/widgets/code_peek/code_peek.dart' show CodePeekWrapper;
import 'package:portfolio_jps/shared/widgets/code_peek/presentation/code_peek_wrapper.dart' show CodePeekWrapper;

/// State for the Dev Mode feature.
///
/// When Dev Mode is enabled, components wrapped with [CodePeekWrapper]
/// will show visual indicators and allow viewing their source code.
class DevModeState extends Equatable {
  const DevModeState({
    required this.isEnabled,
    this.selectedComponentId,
  });

  /// Initial state with Dev Mode disabled.
  const DevModeState.initial()
      : isEnabled = false,
        selectedComponentId = null;

  /// Whether Dev Mode is currently enabled.
  final bool isEnabled;

  /// The ID of the currently selected/hovered component (if any).
  /// Used to show the expanded modal view.
  final String? selectedComponentId;

  /// Whether a component is currently selected for viewing.
  bool get hasSelection => selectedComponentId != null;

  DevModeState copyWith({
    bool? isEnabled,
    String? selectedComponentId,
    bool clearSelection = false,
  }) {
    return DevModeState(
      isEnabled: isEnabled ?? this.isEnabled,
      selectedComponentId:
          clearSelection ? null : (selectedComponentId ?? this.selectedComponentId),
    );
  }

  @override
  List<Object?> get props => [isEnabled, selectedComponentId];
}
