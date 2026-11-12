import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Жизненный цикл Flutter',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _open(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute<void>(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Практика Flutter')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton(
                onPressed: () => _open(context, const LifecycleScreen()),
                child: const Text('Жизненный цикл'),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => _open(context, const StopwatchScreen()),
                child: const Text('Секундомер'),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => _open(context, const InfoCardScreen()),
                child: const Text('Stateless и Stateful'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => _open(context, const ControllerScreen()),
                child: const Text('TextEditingController'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LifecycleScreen extends StatefulWidget {
  const LifecycleScreen({super.key});

  @override
  State<LifecycleScreen> createState() => _LifecycleScreenState();
}

class _LifecycleScreenState extends State<LifecycleScreen> {
  @override
  void initState() {
    super.initState();
    debugPrint('initState вызван');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('didChangeDependencies вызван');
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('build вызван');
    return Scaffold(
      appBar: AppBar(title: const Text('Жизненный цикл')),
      body: Center(
        child: FilledButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Назад'),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant LifecycleScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    debugPrint('didUpdateWidget вызван');
  }

  @override
  void deactivate() {
    debugPrint('deactivate вызван');
    super.deactivate();
  }

  @override
  void dispose() {
    debugPrint('dispose вызван');
    super.dispose();
  }
}

class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});

  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  Timer? _timer;
  int _seconds = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _seconds++);
      debugPrint('Секундомер: $_seconds сек.');
    });
  }

  void _pauseOrResume() {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
      _timer = null;
      setState(() {});
    } else {
      _startTimer();
      setState(() {});
    }
  }

  void _reset() {
    setState(() => _seconds = 0);
  }

  @override
  void dispose() {
    _timer?.cancel();
    debugPrint('Секундомер остановлен');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (_seconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_seconds % 60).toString().padLeft(2, '0');
    final isRunning = _timer?.isActive ?? false;

    return Scaffold(
      appBar: AppBar(title: const Text('Секундомер')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$minutes:$seconds',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              children: [
                FilledButton(
                  onPressed: _pauseOrResume,
                  child: Text(isRunning ? 'Пауза' : 'Продолжить'),
                ),
                OutlinedButton(onPressed: _reset, child: const Text('Сброс')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({required this.title, required this.count, super.key});

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text('Счётчик: $count'),
          ],
        ),
      ),
    );
  }
}

class InfoCardScreen extends StatefulWidget {
  const InfoCardScreen({super.key});

  @override
  State<InfoCardScreen> createState() => _InfoCardScreenState();
}

class _InfoCardScreenState extends State<InfoCardScreen> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stateless и Stateful')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InfoCard(title: 'Пример InfoCard', count: _count),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => setState(() => _count++),
              child: const Text('+1'),
            ),
          ],
        ),
      ),
    );
  }
}

class ControllerScreen extends StatefulWidget {
  const ControllerScreen({super.key});

  @override
  State<ControllerScreen> createState() => _ControllerScreenState();
}

class _ControllerScreenState extends State<ControllerScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_logText);
  }

  void _logText() {
    debugPrint('Введённый текст: ${_controller.text}');
  }

  @override
  void dispose() {
    _controller.removeListener(_logText);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TextEditingController')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: TextField(
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'Введите текст',
            border: OutlineInputBorder(),
          ),
        ),
      ),
    );
  }
}
