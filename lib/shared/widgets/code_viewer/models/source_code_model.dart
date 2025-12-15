import 'package:equatable/equatable.dart';

/// Represents a source code file that can be displayed in the code viewer.
///
/// This model holds all information needed to display code with syntax
/// highlighting, including metadata like file path, language, and related files.
class SourceCodeModel extends Equatable {
  const SourceCodeModel({
    required this.fileName,
    required this.filePath,
    required this.code,
    required this.language,
    this.githubUrl,
    this.relatedFiles = const [],
    this.description,
  });

  /// Creates a SourceCodeModel from a JSON map.
  factory SourceCodeModel.fromJson(Map<String, dynamic> json) {
    return SourceCodeModel(
      fileName: json['fileName'] as String,
      filePath: json['filePath'] as String,
      code: json['code'] as String,
      language: json['language'] as String? ?? 'dart',
      githubUrl: json['githubUrl'] as String?,
      description: json['description'] as String?,
      relatedFiles: (json['relatedFiles'] as List<dynamic>?)
              ?.map((e) => SourceCodeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }

  /// The display name of the file (e.g., "hero_section.dart")
  final String fileName;

  /// The relative path to the file (e.g., "lib/features/hero/...")
  final String filePath;

  /// The actual source code content
  final String code;

  /// Programming language for syntax highlighting (e.g., "dart", "yaml")
  final String language;

  /// Optional URL to the file on GitHub
  final String? githubUrl;

  /// Optional description explaining what this code does
  final String? description;

  /// Related files that can be viewed alongside this one
  final List<SourceCodeModel> relatedFiles;

  /// Returns the total number of lines in the code
  int get lineCount => code.split('\n').length;

  /// Returns an estimated file size in bytes
  int get fileSize => code.length;

  /// Returns a human-readable file size string
  String get fileSizeFormatted {
    if (fileSize < 1024) {
      return '$fileSize B';
    } else if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    } else {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
  }

  /// Converts this model to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'fileName': fileName,
      'filePath': filePath,
      'code': code,
      'language': language,
      'githubUrl': githubUrl,
      'description': description,
      'relatedFiles': relatedFiles.map((e) => e.toJson()).toList(),
    };
  }

  /// Creates a copy of this model with some fields replaced.
  SourceCodeModel copyWith({
    String? fileName,
    String? filePath,
    String? code,
    String? language,
    String? githubUrl,
    String? description,
    List<SourceCodeModel>? relatedFiles,
  }) {
    return SourceCodeModel(
      fileName: fileName ?? this.fileName,
      filePath: filePath ?? this.filePath,
      code: code ?? this.code,
      language: language ?? this.language,
      githubUrl: githubUrl ?? this.githubUrl,
      description: description ?? this.description,
      relatedFiles: relatedFiles ?? this.relatedFiles,
    );
  }

  @override
  List<Object?> get props => [
        fileName,
        filePath,
        code,
        language,
        githubUrl,
        description,
        relatedFiles,
      ];
}
