import 'package:material_ui/material_ui.dart';

void main() {
  runApp(const NextFitApp());
}

const _ink = Color(0xFF20251F);
const _muted = Color(0xFF777D75);
const _green = Color(0xFF315C3B);
const _lime = Color(0xFFD8F279);
const _canvas = Color(0xFFF5F6F2);
const _line = Color(0xFFE7E9E3);

class NextFitApp extends StatelessWidget {
  const NextFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NextFit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: _canvas,
        colorScheme: ColorScheme.fromSeed(seedColor: _green, surface: _canvas),
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            color: _ink,
            fontSize: 28,
            height: 1.12,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.8,
          ),
          titleLarge: TextStyle(
            color: _ink,
            fontSize: 19,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.3,
          ),
          titleMedium: TextStyle(
            color: _ink,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
          bodyMedium: TextStyle(color: _muted, fontSize: 14, height: 1.4),
        ),
      ),
      home: const StudentHome(),
    );
  }
}

class StudentHome extends StatefulWidget {
  const StudentHome({super.key});

  @override
  State<StudentHome> createState() => _StudentHomeState();
}

class _StudentHomeState extends State<StudentHome> {
  int _tab = 0;
  bool _workoutStarted = false;
  final Set<int> _completedExercises = {};
  final List<bool> _habits = [true, false, false];

  void _toggleHabit(int index) {
    setState(() => _habits[index] = !_habits[index]);
  }

  void _toggleExercise(int index) {
    setState(() {
      if (!_completedExercises.add(index)) {
        _completedExercises.remove(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(
        habits: _habits,
        onHabitTap: _toggleHabit,
        onOpenWorkout: () => setState(() => _tab = 1),
        onOpenProgress: () => setState(() => _tab = 2),
        onOpenHabits: () => setState(() => _tab = 3),
      ),
      WorkoutPage(
        started: _workoutStarted,
        completedExercises: _completedExercises,
        onToggleStarted: () =>
            setState(() => _workoutStarted = !_workoutStarted),
        onToggleExercise: _toggleExercise,
      ),
      const ProgressPage(),
      HabitsPage(habits: _habits, onToggleHabit: _toggleHabit),
    ];

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: _tab, children: pages),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (index) => setState(() => _tab = index),
        backgroundColor: Colors.white,
        indicatorColor: _lime.withValues(alpha: 0.55),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center_outlined),
            selectedIcon: Icon(Icons.fitness_center_rounded),
            label: 'Treino',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            selectedIcon: Icon(Icons.insights_rounded),
            label: 'Progresso',
          ),
          NavigationDestination(
            icon: Icon(Icons.check_circle_outline_rounded),
            selectedIcon: Icon(Icons.check_circle_rounded),
            label: 'Hábitos',
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({
    required this.habits,
    required this.onHabitTap,
    required this.onOpenWorkout,
    required this.onOpenProgress,
    required this.onOpenHabits,
    super.key,
  });

  final List<bool> habits;
  final ValueChanged<int> onHabitTap;
  final VoidCallback onOpenWorkout;
  final VoidCallback onOpenProgress;
  final VoidCallback onOpenHabits;

  @override
  Widget build(BuildContext context) {
    final completed = habits.where((done) => done).length;
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 18, 22, 28),
      children: [
        const _TopBar(),
        const SizedBox(height: 30),
        Text(_todayLabel(), style: _eyebrow),
        const SizedBox(height: 8),
        Text(
          'Vamos com tudo,\nAna.',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 22),
        _WeeklyCard(completed: completed),
        const SizedBox(height: 28),
        _SectionHeading(title: 'Seu próximo passo', action: 'Ver treino'),
        const SizedBox(height: 13),
        _WorkoutCard(onTap: onOpenWorkout),
        const SizedBox(height: 27),
        _SectionHeading(
          title: 'Hábitos de hoje',
          action: '$completed de ${habits.length}',
          onAction: onOpenHabits,
        ),
        const SizedBox(height: 10),
        _HabitPreview(habits: habits, onTap: onHabitTap),
        const SizedBox(height: 24),
        _ProgressNudge(onTap: onOpenProgress),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: _green,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.bolt_rounded, color: _lime, size: 23),
        ),
        const SizedBox(width: 10),
        const Text(
          'nextfit',
          style: TextStyle(
            color: _ink,
            fontWeight: FontWeight.w800,
            fontSize: 20,
            letterSpacing: -0.8,
          ),
        ),
        const Spacer(),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: _line),
          ),
          child: const Center(
            child: Text(
              'A',
              style: TextStyle(color: _green, fontWeight: FontWeight.w800),
            ),
          ),
        ),
      ],
    );
  }
}

class _WeeklyCard extends StatelessWidget {
  const _WeeklyCard({required this.completed});

  final int completed;

  @override
  Widget build(BuildContext context) {
    const days = ['S', 'T', 'Q', 'Q', 'S', 'S', 'D'];
    const active = [true, true, false, false, false, false, false];
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 17, 18, 16),
      decoration: BoxDecoration(
        color: _green,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'SUA SEMANA',
                  style: TextStyle(
                    color: Color(0xFFC9D8C6),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              Text(
                '$completed hábitos hoje',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: List.generate(days.length, (index) {
              final isDone = active[index];
              return Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 31,
                      height: 31,
                      decoration: BoxDecoration(
                        color: isDone
                            ? _lime
                            : Colors.white.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isDone ? Icons.check_rounded : Icons.circle,
                        color: isDone
                            ? _green
                            : Colors.white.withValues(alpha: 0.28),
                        size: isDone ? 18 : 6,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      days[index],
                      style: TextStyle(
                        color: isDone ? Colors.white : const Color(0xFFC9D8C6),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.title,
    required this.action,
    this.onAction,
  });

  final String title;
  final String action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title, style: Theme.of(context).textTheme.titleLarge),
        ),
        GestureDetector(
          onTap: onAction,
          child: Text(
            action,
            style: const TextStyle(
              color: _green,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _WorkoutCard extends StatelessWidget {
  const _WorkoutCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _lime.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(
                      Icons.fitness_center_rounded,
                      color: _green,
                    ),
                  ),
                  const SizedBox(width: 13),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('TREINO A · SUPERIORES', style: _eyebrow),
                        SizedBox(height: 5),
                        Text(
                          'Peito, ombro e tríceps',
                          style: TextStyle(
                            color: _ink,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: _green,
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(height: 1, color: _line),
              const SizedBox(height: 14),
              const Row(
                children: [
                  Icon(Icons.schedule_rounded, size: 16, color: _muted),
                  SizedBox(width: 6),
                  Text('45 min', style: _meta),
                  SizedBox(width: 18),
                  Icon(Icons.list_alt_rounded, size: 16, color: _muted),
                  SizedBox(width: 6),
                  Text('5 exercícios', style: _meta),
                  Spacer(),
                  Text(
                    'Começar',
                    style: TextStyle(
                      color: _green,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HabitPreview extends StatelessWidget {
  const _HabitPreview({required this.habits, required this.onTap});

  final List<bool> habits;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    const names = ['Beber 2L de água', 'Dormir 8 horas', 'Alongar por 10 min'];
    const icons = [
      Icons.water_drop_outlined,
      Icons.bedtime_outlined,
      Icons.self_improvement,
    ];
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: List.generate(names.length, (index) {
          return InkWell(
            onTap: () => onTap(index),
            child: SizedBox(
              height: 53,
              child: Row(
                children: [
                  Icon(icons[index], size: 19, color: _muted),
                  const SizedBox(width: 11),
                  Expanded(child: Text(names[index], style: _meta)),
                  Icon(
                    habits[index]
                        ? Icons.check_circle_rounded
                        : Icons.circle_outlined,
                    size: 21,
                    color: habits[index] ? _green : const Color(0xFFC7CCC4),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _ProgressNudge extends StatelessWidget {
  const _ProgressNudge({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFFECEFE6),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.trending_up_rounded, color: _green, size: 23),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Pequenos passos, grandes mudanças.',
              style: TextStyle(
                color: _ink,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          IconButton(
            onPressed: onTap,
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.arrow_forward_rounded, color: _green),
          ),
        ],
      ),
    );
  }
}

class WorkoutPage extends StatelessWidget {
  const WorkoutPage({
    required this.started,
    required this.completedExercises,
    required this.onToggleStarted,
    required this.onToggleExercise,
    super.key,
  });

  final bool started;
  final Set<int> completedExercises;
  final VoidCallback onToggleStarted;
  final ValueChanged<int> onToggleExercise;

  @override
  Widget build(BuildContext context) {
    const exercises = [
      (
        'Supino reto com halteres',
        '3 séries · 10-12 repetições',
        Icons.fitness_center,
      ),
      ('Supino inclinado', '3 séries · 10-12 repetições', Icons.fitness_center),
      (
        'Crucifixo na máquina',
        '3 séries · 12-15 repetições',
        Icons.sports_gymnastics,
      ),
      ('Elevação lateral', '3 séries · 12-15 repetições', Icons.fitness_center),
      ('Tríceps na polia', '3 séries · 12 repetições', Icons.fitness_center),
    ];
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 23, 22, 30),
      children: [
        Text('SEU PLANO', style: _eyebrow),
        const SizedBox(height: 8),
        Text(
          'Treino de hoje',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 19),
        Container(
          padding: const EdgeInsets.all(19),
          decoration: BoxDecoration(
            color: _green,
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TREINO A',
                style: TextStyle(
                  color: _lime,
                  fontSize: 11,
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Peito, ombro\\ne tríceps',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  height: 1.16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 17),
              Row(
                children: [
                  _WorkoutMeta(icon: Icons.schedule_rounded, label: '45 min'),
                  SizedBox(width: 17),
                  _WorkoutMeta(
                    icon: Icons.list_alt_rounded,
                    label: '5 exercícios',
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _SectionHeading(
          title: 'Exercícios',
          action: '${completedExercises.length}/${exercises.length}',
        ),
        const SizedBox(height: 11),
        ...List.generate(exercises.length, (index) {
          final exercise = exercises[index];
          final done = completedExercises.contains(index);
          return Container(
            margin: const EdgeInsets.only(bottom: 9),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(17),
            ),
            child: InkWell(
              onTap: () => onToggleExercise(index),
              borderRadius: BorderRadius.circular(17),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 15,
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: done ? _lime.withValues(alpha: 0.5) : _canvas,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(exercise.$3, size: 19, color: _green),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exercise.$1,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(exercise.$2, style: _meta),
                        ],
                      ),
                    ),
                    Icon(
                      done ? Icons.check_circle_rounded : Icons.circle_outlined,
                      color: done ? _green : const Color(0xFFC7CCC4),
                      size: 22,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 9),
        FilledButton(
          onPressed: onToggleStarted,
          style: FilledButton.styleFrom(
            backgroundColor: started ? _ink : _green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 17),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          child: Text(
            started ? 'Finalizar treino' : 'Começar treino',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _WorkoutMeta extends StatelessWidget {
  const _WorkoutMeta({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFFC9D8C6)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }
}

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 23, 22, 30),
      children: [
        Text('CONSISTÊNCIA É TUDO', style: _eyebrow),
        const SizedBox(height: 8),
        Text(
          'Seu progresso',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 20),
        Row(
          children: const [
            Expanded(
              child: _MetricCard(
                label: 'Treinos',
                value: '12',
                detail: 'este mês',
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _MetricCard(
                label: 'Frequência',
                value: '3x',
                detail: 'por semana',
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Treinos por semana',
                style: TextStyle(
                  color: _ink,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              const Text('Nas últimas 4 semanas', style: _meta),
              const SizedBox(height: 16),
              SizedBox(
                height: 142,
                child: CustomPaint(
                  painter: _BarChartPainter(),
                  child: const SizedBox.expand(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: _green,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            children: [
              Icon(Icons.emoji_events_outlined, color: _lime, size: 26),
              SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Você está no caminho certo!',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Mantenha sua frequência para alcançar seus objetivos.',
                      style: TextStyle(
                        color: Color(0xFFC9D8C6),
                        fontSize: 12,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Atividade recente',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 11),
        const _ActivityRow(
          icon: Icons.fitness_center_rounded,
          title: 'Treino B · Inferiores',
          subtitle: 'Ontem · 52 min',
        ),
        const _ActivityRow(
          icon: Icons.fitness_center_rounded,
          title: 'Treino A · Superiores',
          subtitle: 'Segunda · 47 min',
        ),
        const _ActivityRow(
          icon: Icons.fitness_center_rounded,
          title: 'Treino C · Corpo todo',
          subtitle: 'Sábado · 55 min',
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.detail,
  });

  final String label;
  final String value;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _meta),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: _ink,
                  fontSize: 27,
                  height: 1,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 6),
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Text(
                  detail,
                  style: const TextStyle(color: _muted, fontSize: 11),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BarChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const values = [0.48, 0.76, 0.58, 0.9];
    const labels = ['S1', 'S2', 'S3', 'S4'];
    final baseY = size.height - 22;
    final chartHeight = size.height - 38;
    final gridPaint = Paint()
      ..color = _line
      ..strokeWidth = 1;
    final barPaint = Paint()..color = _green;
    final activePaint = Paint()..color = _lime;
    final labelPainter = TextPainter(textDirection: TextDirection.ltr);

    for (var line = 0; line < 3; line++) {
      final y = chartHeight * line / 2 + 5;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final slotWidth = size.width / values.length;
    for (var index = 0; index < values.length; index++) {
      final barWidth = slotWidth * 0.43;
      final left = slotWidth * index + (slotWidth - barWidth) / 2;
      final height = chartHeight * values[index];
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, baseY - height, barWidth, height),
        const Radius.circular(7),
      );
      canvas.drawRRect(
        rect,
        index == values.length - 1 ? activePaint : barPaint,
      );
      labelPainter.text = TextSpan(
        text: labels[index],
        style: const TextStyle(
          color: _muted,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      );
      labelPainter.layout();
      labelPainter.paint(
        canvas,
        Offset(
          slotWidth * index + (slotWidth - labelPainter.width) / 2,
          baseY + 7,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 39,
            height: 39,
            decoration: BoxDecoration(
              color: _canvas,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 18, color: _green),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: _ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(subtitle, style: _meta),
              ],
            ),
          ),
          const Icon(Icons.check_circle_rounded, color: _green, size: 20),
        ],
      ),
    );
  }
}

class HabitsPage extends StatelessWidget {
  const HabitsPage({
    required this.habits,
    required this.onToggleHabit,
    super.key,
  });

  final List<bool> habits;
  final ValueChanged<int> onToggleHabit;

  @override
  Widget build(BuildContext context) {
    const names = ['Beber 2L de água', 'Dormir 8 horas', 'Alongar por 10 min'];
    const descriptions = [
      'Cuide da hidratação ao longo do dia.',
      'Uma boa noite ajuda na recuperação.',
      'Reserve alguns minutos para se alongar.',
    ];
    const icons = [
      Icons.water_drop_outlined,
      Icons.bedtime_outlined,
      Icons.self_improvement,
    ];
    final completed = habits.where((done) => done).length;
    return ListView(
      padding: const EdgeInsets.fromLTRB(22, 23, 22, 30),
      children: [
        Text('UM DIA DE CADA VEZ', style: _eyebrow),
        const SizedBox(height: 8),
        Text('Seus hábitos', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 7),
        const Text('Pequenas escolhas também fazem parte do treino.'),
        const SizedBox(height: 21),
        Container(
          padding: const EdgeInsets.all(19),
          decoration: BoxDecoration(
            color: _green,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HOJE',
                      style: TextStyle(
                        color: Color(0xFFC9D8C6),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Seu ritmo,\\nseu progresso.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        height: 1.2,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 72,
                height: 72,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: completed / habits.length,
                      strokeWidth: 6,
                      backgroundColor: Colors.white.withValues(alpha: 0.18),
                      valueColor: const AlwaysStoppedAnimation<Color>(_lime),
                    ),
                    Text(
                      '$completed/${habits.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 23),
        Text('Rotina diária', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 11),
        ...List.generate(names.length, (index) {
          final done = habits[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: InkWell(
              onTap: () => onToggleHabit(index),
              borderRadius: BorderRadius.circular(18),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: done ? _lime.withValues(alpha: 0.5) : _canvas,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(icons[index], color: _green, size: 21),
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            names[index],
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(descriptions[index], style: _meta),
                        ],
                      ),
                    ),
                    const SizedBox(width: 5),
                    Icon(
                      done ? Icons.check_circle_rounded : Icons.circle_outlined,
                      color: done ? _green : const Color(0xFFC7CCC4),
                      size: 23,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 9),
        const Text(
          'As marcações são temporárias neste MVP.',
          textAlign: TextAlign.center,
          style: TextStyle(color: _muted, fontSize: 11),
        ),
      ],
    );
  }
}

const _eyebrow = TextStyle(
  color: _muted,
  fontSize: 10,
  letterSpacing: 1.1,
  fontWeight: FontWeight.w800,
);

String _todayLabel() {
  const weekdays = [
    'SEGUNDA-FEIRA',
    'TERÇA-FEIRA',
    'QUARTA-FEIRA',
    'QUINTA-FEIRA',
    'SEXTA-FEIRA',
    'SÁBADO',
    'DOMINGO',
  ];
  const months = [
    'JAN',
    'FEV',
    'MAR',
    'ABR',
    'MAI',
    'JUN',
    'JUL',
    'AGO',
    'SET',
    'OUT',
    'NOV',
    'DEZ',
  ];
  final now = DateTime.now();
  return '${weekdays[now.weekday - 1]}, ${now.day} ${months[now.month - 1]}';
}

const _meta = TextStyle(
  color: _muted,
  fontSize: 12,
  fontWeight: FontWeight.w500,
);
