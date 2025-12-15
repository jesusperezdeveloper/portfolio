import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:portfolio_jps/core/config/app_config.dart';
import 'package:portfolio_jps/core/theme/app_colors.dart';
import 'package:portfolio_jps/core/theme/app_spacing.dart';

class TerminalPage extends StatefulWidget {
  const TerminalPage({super.key});

  @override
  State<TerminalPage> createState() => _TerminalPageState();
}

class _TerminalPageState extends State<TerminalPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final List<TerminalLine> _lines = [];

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addWelcomeMessage() {
    _lines.addAll([
      const TerminalLine(
        text: r'''
   ___                      ____
  |_  |                    |  _ \ ___  _ __ ___ ____
    | | ___  ___ _   _ ___ | |_) / _ \| '__/ _ \_  /
    | |/ _ \/ __| | | / __||  __/  __/| | |  __// /
/\__/ /  __/\__ \ |_| \__ \| |   \___||_|  \___/___|
\____/ \___||___/\__,_|___/|_|
''',
        type: LineType.ascii,
      ),
      const TerminalLine(
        text: 'Bienvenido al terminal de Jesús Pérez',
        type: LineType.system,
      ),
      const TerminalLine(
        text: 'Escribe "help" para ver los comandos disponibles',
        type: LineType.system,
      ),
      const TerminalLine(text: '', type: LineType.empty),
    ]);
  }

  void _executeCommand(String input) {
    final command = input.trim().toLowerCase();

    setState(() {
      _lines.add(TerminalLine(
        text: '\$ $input',
        type: LineType.command,
      ),);
    });

    String output;
    var outputType = LineType.output;

    switch (command) {
      case 'help':
        output = '''
Comandos disponibles:
  help        - Muestra este mensaje de ayuda
  about       - Información sobre mí
  skills      - Lista mis habilidades técnicas
  experience  - Mi experiencia profesional
  projects    - Lista mis proyectos destacados
  contact     - Información de contacto
  social      - Mis redes sociales
  clear       - Limpia el terminal
  exit        - Volver al portfolio
  matrix      - 🎮 Easter egg
''';

      case 'about':
        output = '''
╔══════════════════════════════════════════════════════════╗
║  Jesús Pérez                                             ║
║  Software Developer                                      ║
╠══════════════════════════════════════════════════════════╣
║  5+ años de experiencia en desarrollo móvil              ║
║  Especializado en Flutter, Clean Architecture y BLoC     ║
║  Fundador de Paddock Manager                             ║
║  Master en Inteligencia Artificial (Founderz 2025)       ║
║  Ubicación: Jerez de la Frontera, Cádiz, España          ║
╚══════════════════════════════════════════════════════════╝
''';

      case 'skills':
        output = '''
🎯 Lenguajes:
   Dart ████████████████████ Expert
   Kotlin ███████████████░░░░░ Avanzado
   Swift ██████████░░░░░░░░░░ Intermedio
   Python ███████████████░░░░░ Avanzado
   TypeScript ██████████░░░░░░░░░░ Intermedio

📱 Frameworks:
   Flutter ████████████████████ Expert
   BLoC/Cubit ████████████████████ Expert
   Firebase ████████████████████ Expert
   Clean Architecture ████████████████████ Expert

🛠️ Herramientas: Git, Figma, VS Code, Android Studio, Xcode
☁️ Cloud: Firebase, Google Cloud, AWS
''';

      case 'experience':
        output = '''
📋 Experiencia Profesional:

┌─ SlashMobility (May 2025 - Presente)
│  Software Developer
│  Risk Engineers - Sector asegurador UK/USA
│
├─ Paddock Manager (2023 - Presente)
│  Founder & Lead Developer
│  Plataforma motorsport para RFME/ESBK
│
├─ Bit2Me (2022 - 2023)
│  Flutter Developer
│  Plataforma crypto trading
│
└─ Accenture (2020 - 2022)
   Flutter Developer
   KPNTV+ (7M usuarios), QEDU, SGS, Zurich
''';

      case 'projects':
        output = '''
🚀 Proyectos Destacados:

1. Paddock Manager
   Plataforma completa de gestión motorsport
   Tech: Flutter, Firebase, BLoC, 6 idiomas

2. KPNTV+
   App de streaming con 7M+ usuarios
   Tech: Flutter, GraphQL, Video streaming

3. Bit2Me
   Plataforma crypto trading
   Tech: Flutter, Secure Auth, Financial APIs

4. Risk Engineers
   App sector asegurador UK/USA
   Tech: Flutter, Clean Architecture, BLoC
''';

      case 'contact':
        output = '''
📬 Contacto:

   Email:    ${AppConfig.email}
   Phone:    ${AppConfig.phone}
   Location: ${AppConfig.location}

   ¡No dudes en contactarme para cualquier proyecto!
''';

      case 'social':
        output = '''
🌐 Redes Sociales:

   GitHub:   ${AppConfig.githubUrl}
   LinkedIn: ${AppConfig.linkedInUrl}
   Twitter:  ${AppConfig.twitterUrl}
''';

      case 'clear':
        setState(() {
          _lines.clear();
          _addWelcomeMessage();
        });
        _controller.clear();
        return;

      case 'exit':
        context.go('/');
        return;

      case 'matrix':
        output = '''
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⡀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀
⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷
⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿
⠀⠀⠀⠀⠀⣿⣿⣿⠟⠋⠉⠉⠉⠛⢿⣿⣿⣿⣿⡿⠛⠉⠉⠉⠙⠻⣿⣿⣿⣿
⠀⠀⠀⠀⠀⣿⣿⠃⠀⢀⣴⣾⣷⣦⠀⢻⣿⣿⡟⠀⣴⣾⣷⣦⡀⠀⠘⣿⣿⣿
⠀⠀⠀⠀⠀⣿⣿⠀⠀⢸⣿⣿⣿⣿⡇⠀⣿⣿⠀⢸⣿⣿⣿⣿⡇⠀⠀⣿⣿⣿

Wake up, Neo... The Matrix has you...
Follow the white rabbit. 🐇

Knock, knock, Neo.
''';
        outputType = LineType.special;

      case '':
        _controller.clear();
        return;

      default:
        output = 'Comando no encontrado: $command\nEscribe "help" para ver los comandos disponibles.';
        outputType = LineType.error;
    }

    setState(() {
      _lines
        ..add(TerminalLine(text: output, type: outputType))
        ..add(const TerminalLine(text: '', type: LineType.empty));
    });

    _controller.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161B22),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: Row(
          children: [
            Container(
              width: 12,
              height: 12,
              margin: const EdgeInsets.only(right: 8),
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
            ),
            const Text(
              'jesusperez@portfolio ~ %',
              style: TextStyle(
                fontFamily: 'JetBrainsMono',
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.content_copy),
            tooltip: 'Copiar contenido',
            onPressed: () {
              final content = _lines.map((l) => l.text).join('\n');
              Clipboard.setData(ClipboardData(text: content));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Contenido copiado')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Terminal output
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: AppSpacing.paddingAllMd,
              itemCount: _lines.length,
              itemBuilder: (context, index) {
                final line = _lines[index];
                return _buildTerminalLine(line);
              },
            ),
          ),
          // Input line
          Container(
            padding: AppSpacing.paddingAllMd,
            decoration: BoxDecoration(
              color: const Color(0xFF161B22),
              border: Border(
                top: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            child: Row(
              children: [
                const Text(
                  r'$ ',
                  style: TextStyle(
                    fontFamily: 'JetBrainsMono',
                    color: AppColors.terminalGreen,
                    fontSize: 14,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    style: const TextStyle(
                      fontFamily: 'JetBrainsMono',
                      color: Colors.white,
                      fontSize: 14,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    cursorColor: AppColors.terminalGreen,
                    onSubmitted: _executeCommand,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTerminalLine(TerminalLine line) {
    Color color;
    switch (line.type) {
      case LineType.command:
        color = AppColors.terminalGreen;
      case LineType.output:
        color = Colors.white.withValues(alpha: 0.9);
      case LineType.error:
        color = AppColors.error;
      case LineType.system:
        color = AppColors.accent;
      case LineType.special:
        color = AppColors.highlightYellow;
      case LineType.ascii:
        color = AppColors.accent;
      case LineType.empty:
        return const SizedBox(height: 8);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: SelectableText(
        line.text,
        style: TextStyle(
          fontFamily: 'JetBrainsMono',
          fontSize: 13,
          color: color,
          height: 1.4,
        ),
      ),
    );
  }
}

enum LineType { command, output, error, system, special, ascii, empty }

class TerminalLine {
  const TerminalLine({
    required this.text,
    required this.type,
  });

  final String text;
  final LineType type;
}
