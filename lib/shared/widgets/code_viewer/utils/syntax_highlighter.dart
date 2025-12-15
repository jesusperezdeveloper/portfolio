import 'package:flutter/material.dart';

/// Custom syntax highlighter for Dart code using VS Code Dark+ theme colors.
///
/// This implementation uses RegExp patterns to tokenize Dart code and apply
/// appropriate colors without external dependencies.
class SyntaxHighlighter {
  const SyntaxHighlighter._();

  // VS Code Dark+ Theme Colors
  static const Color _keyword = Color(0xFFc792ea); // purple
  static const Color _string = Color(0xFFc3e88d); // green
  static const Color _className = Color(0xFFffcb6b); // yellow
  static const Color _function = Color(0xFF82aaff); // blue
  static const Color _comment = Color(0xFF546e7a); // gray
  static const Color _number = Color(0xFFf78c6c); // orange
  static const Color _operator = Color(0xFF89ddff); // light cyan
  static const Color _annotation = Color(0xFFc792ea); // purple
  static const Color _parameter = Color(0xFFe4e4e7); // light gray
  static const Color _property = Color(0xFF80cbc4); // teal
  static const Color _defaultText = Color(0xFFe4e4e7); // light gray

  /// Dart keywords
  static const _keywords = <String>{
    'abstract',
    'as',
    'assert',
    'async',
    'await',
    'base',
    'break',
    'case',
    'catch',
    'class',
    'const',
    'continue',
    'covariant',
    'default',
    'deferred',
    'do',
    'dynamic',
    'else',
    'enum',
    'export',
    'extends',
    'extension',
    'external',
    'factory',
    'false',
    'final',
    'finally',
    'for',
    'Function',
    'get',
    'hide',
    'if',
    'implements',
    'import',
    'in',
    'interface',
    'is',
    'late',
    'library',
    'mixin',
    'new',
    'null',
    'on',
    'operator',
    'part',
    'required',
    'rethrow',
    'return',
    'sealed',
    'set',
    'show',
    'static',
    'super',
    'switch',
    'sync',
    'this',
    'throw',
    'true',
    'try',
    'typedef',
    'var',
    'void',
    'when',
    'while',
    'with',
    'yield',
  };

  /// Built-in types
  static const _builtInTypes = <String>{
    'int',
    'double',
    'num',
    'bool',
    'String',
    'List',
    'Map',
    'Set',
    'Iterable',
    'Future',
    'Stream',
    'Object',
    'Type',
    'Symbol',
    'Null',
    'Never',
    'Duration',
    'DateTime',
    'Uri',
    'RegExp',
    'Pattern',
    'Match',
    'Error',
    'Exception',
    'StackTrace',
    'Comparable',
    'Iterator',
    'Sink',
    'EventSink',
    'StringSink',
    'StringBuffer',
    'Runes',
    'RuneIterator',
  };

  /// Highlights Dart code and returns a list of TextSpans.
  static List<TextSpan> highlight(String code) {
    final spans = <TextSpan>[];
    final tokens = _tokenize(code);

    for (final token in tokens) {
      spans.add(
        TextSpan(
          text: token.text,
          style: TextStyle(color: token.color),
        ),
      );
    }

    return spans;
  }

  /// Tokenizes the code into colored segments.
  static List<_Token> _tokenize(String code) {
    final tokens = <_Token>[];
    var index = 0;

    while (index < code.length) {
      final result = _matchToken(code, index);
      if (result != null) {
        tokens.add(result);
        index += result.text.length;
      } else {
        // Single character, default color
        tokens.add(_Token(code[index], _defaultText));
        index++;
      }
    }

    return _mergeAdjacentTokens(tokens);
  }

  /// Attempts to match a token at the given index.
  static _Token? _matchToken(String code, int index) {
    final remaining = code.substring(index);

    // Multi-line comment
    if (remaining.startsWith('/*')) {
      final end = remaining.indexOf('*/');
      if (end != -1) {
        return _Token(remaining.substring(0, end + 2), _comment);
      }
      return _Token(remaining, _comment);
    }

    // Single-line comment
    if (remaining.startsWith('//')) {
      final end = remaining.indexOf('\n');
      if (end != -1) {
        return _Token(remaining.substring(0, end), _comment);
      }
      return _Token(remaining, _comment);
    }

    // Documentation comment
    if (remaining.startsWith('///')) {
      final end = remaining.indexOf('\n');
      if (end != -1) {
        return _Token(remaining.substring(0, end), _comment);
      }
      return _Token(remaining, _comment);
    }

    // Raw string with triple quotes
    if (remaining.startsWith("r'''") || remaining.startsWith('r"""')) {
      final quote = remaining.substring(1, 4);
      final end = remaining.indexOf(quote, 4);
      if (end != -1) {
        return _Token(remaining.substring(0, end + 4), _string);
      }
      return _Token(remaining, _string);
    }

    // Triple-quoted string
    if (remaining.startsWith("'''") || remaining.startsWith('"""')) {
      final quote = remaining.substring(0, 3);
      final end = remaining.indexOf(quote, 3);
      if (end != -1) {
        return _Token(remaining.substring(0, end + 3), _string);
      }
      return _Token(remaining, _string);
    }

    // Raw string
    if (remaining.startsWith("r'") || remaining.startsWith('r"')) {
      final quote = remaining[1];
      final end = _findStringEnd(remaining, 2, quote);
      return _Token(remaining.substring(0, end), _string);
    }

    // Single/double quoted string
    if (remaining.startsWith("'") || remaining.startsWith('"')) {
      final quote = remaining[0];
      final end = _findStringEnd(remaining, 1, quote);
      return _Token(remaining.substring(0, end), _string);
    }

    // Annotation
    if (remaining.startsWith('@')) {
      final match = RegExp('^@[a-zA-Z_][a-zA-Z0-9_]*').firstMatch(remaining);
      if (match != null) {
        return _Token(match.group(0)!, _annotation);
      }
    }

    // Number (hex, binary, or decimal)
    final numberMatch =
        RegExp(r'^(0x[0-9a-fA-F]+|0b[01]+|\d+\.?\d*([eE][+-]?\d+)?)')
            .firstMatch(remaining);
    if (numberMatch != null) {
      return _Token(numberMatch.group(0)!, _number);
    }

    // Identifier (keyword, type, function, etc.)
    final identifierMatch =
        RegExp(r'^[a-zA-Z_$][a-zA-Z0-9_$]*').firstMatch(remaining);
    if (identifierMatch != null) {
      final word = identifierMatch.group(0)!;

      // Check if it's a keyword
      if (_keywords.contains(word)) {
        return _Token(word, _keyword);
      }

      // Check if it's a built-in type
      if (_builtInTypes.contains(word)) {
        return _Token(word, _className);
      }

      // Check if it's a class name (PascalCase)
      if (word.isNotEmpty &&
          word[0] == word[0].toUpperCase() &&
          word[0] != word[0].toLowerCase()) {
        // Check if followed by ( for constructor call or < for generics
        final afterWord = code.length > index + word.length
            ? code[index + word.length]
            : '';
        if (afterWord == '(' || afterWord == '<' || afterWord == '.') {
          return _Token(word, _className);
        }
        // Still likely a type
        return _Token(word, _className);
      }

      // Check if it's a function call (followed by parenthesis)
      final afterIdentifier = code.length > index + word.length
          ? code[index + word.length]
          : '';
      if (afterIdentifier == '(') {
        return _Token(word, _function);
      }

      // Check if it's a property access (preceded by dot)
      if (index > 0 && code[index - 1] == '.') {
        // Check if followed by ( for method call
        if (afterIdentifier == '(') {
          return _Token(word, _function);
        }
        return _Token(word, _property);
      }

      // Default identifier
      return _Token(word, _parameter);
    }

    // Operators
    final operatorMatch =
        RegExp(r'^(=>|->|\.\.\.|\?\?=|\?\?|\.\.|\?\.|\?\[|[+\-*/%&|^~<>=!?:]+)')
            .firstMatch(remaining);
    if (operatorMatch != null) {
      return _Token(operatorMatch.group(0)!, _operator);
    }

    // Brackets and punctuation
    final punctMatch = RegExp(r'^[(){}\[\];,.]').firstMatch(remaining);
    if (punctMatch != null) {
      return _Token(punctMatch.group(0)!, _defaultText);
    }

    return null;
  }

  /// Finds the end of a string literal, handling escape sequences.
  static int _findStringEnd(String code, int start, String quote) {
    var i = start;
    while (i < code.length) {
      if (code[i] == r'\' && i + 1 < code.length) {
        i += 2; // Skip escape sequence
        continue;
      }
      if (code[i] == quote) {
        return i + 1;
      }
      if (code[i] == '\n') {
        return i; // Unterminated string
      }
      i++;
    }
    return code.length;
  }

  /// Merges adjacent tokens with the same color for efficiency.
  static List<_Token> _mergeAdjacentTokens(List<_Token> tokens) {
    if (tokens.isEmpty) return tokens;

    final merged = <_Token>[];
    var current = tokens.first;

    for (var i = 1; i < tokens.length; i++) {
      if (tokens[i].color == current.color) {
        current = _Token(current.text + tokens[i].text, current.color);
      } else {
        merged.add(current);
        current = tokens[i];
      }
    }
    merged.add(current);

    return merged;
  }
}

/// Represents a token with text and color.
class _Token {
  const _Token(this.text, this.color);

  final String text;
  final Color color;
}

/// Extension to easily highlight code in a Text widget.
extension SyntaxHighlightExtension on String {
  /// Returns a RichText widget with syntax highlighting.
  Widget toHighlightedCode({
    double fontSize = 14,
    double height = 1.5,
    String fontFamily = 'JetBrainsMono',
  }) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize,
          height: height,
        ),
        children: SyntaxHighlighter.highlight(this),
      ),
    );
  }
}
