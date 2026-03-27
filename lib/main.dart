import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(const MagicBallApp());

class MagicBallApp extends StatelessWidget {
  const MagicBallApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Магический Шар',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const BallScreen(),
    );
  }
}

class BallScreen extends StatefulWidget {
  const BallScreen({super.key});

  @override
  State<BallScreen> createState() => _BallScreenState();
}

class _BallScreenState extends State<BallScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shakeAnim;
  final _rng = Random();
  String _answer = 'Трясни меня!';
  int _answerIndex = -1;

  static const _answers = [
    'Бесспорно 👍',
    'Определённо да ✅',
    'Без сомнения 💯',
    'Да, definitely! 🎯',
    'Можешь на это рассчитывать 🤝',
    'По моим данным — да 📊',
    'Весьма вероятно 🎲',
    'Перспектива хорошая 🌅',
    'Знаки говорят — да 🔮',
    'Пока неясно, попробуй снова 🔄',
    'Спроси позже ⏰',
    'Лучше не говорить сейчас 🤐',
    'Сейчас нельзя предсказать 🔍',
    'Сконцентрируйся и спроси опять 🧘',
    'Не рассчитывай на это 😬',
    'Мой ответ — нет ❌',
    'Мои источники говорят нет 📰',
    'Перспективы не очень 📉',
    'Весьма сомнительно 🤔',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _shakeAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 0.15), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.15, end: -0.12), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -0.12, end: 0.08), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 0.08, end: -0.05), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -0.05, end: 0), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _shake() {
    _controller.forward(from: 0);
    int newIndex;
    do {
      newIndex = _rng.nextInt(_answers.length);
    } while (newIndex == _answerIndex);
    _answerIndex = newIndex;
    setState(() => _answer = _answers[newIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A0533), Color(0xFF0D001A)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: GestureDetector(
              onTap: _shake,
              child: AnimatedBuilder(
                animation: _shakeAnim,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _shakeAnim.value,
                    child: child,
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Ball
                    Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const RadialGradient(
                          center: Alignment(-0.3, -0.3),
                          colors: [Color(0xFF2D1B69), Color(0xFF0A0020)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withValues(alpha: 0.6),
                            blurRadius: 40,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF110033),
                            border: Border.all(
                              color: Colors.deepPurpleAccent.withValues(alpha: 0.3),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 400),
                              child: Text(
                                _answer,
                                key: ValueKey(_answer),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.lightBlueAccent,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    Text(
                      'Тапни на шар',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
