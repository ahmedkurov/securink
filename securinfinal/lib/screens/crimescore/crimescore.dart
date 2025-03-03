import 'package:flutter/material.dart';
import 'dart:math' as math;

class CrimeScoreMeterPage extends StatefulWidget {
  const CrimeScoreMeterPage({super.key});

  @override
  State<CrimeScoreMeterPage> createState() => _CrimeScoreMeterPageState();
}

class _CrimeScoreMeterPageState extends State<CrimeScoreMeterPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  // Random generator
  final _random = math.Random();

  // Crime score and other random values
  late double crimeScore;
  late Map<String, dynamic> violentOffenses;
  late Map<String, dynamic> propertyCrimes;
  late Map<String, dynamic> drugOffenses;
  late Map<String, dynamic> recidivismRisk;
  late Map<String, dynamic> rehabilitationProgress;
  late List<Map<String, dynamic>> rehabPrograms;

  // Score ranges and their corresponding risk levels
  final List<Map<String, dynamic>> riskLevels = [
    {'min': 0, 'max': 20, 'label': 'Low Risk', 'color': Colors.green},
    {'min': 21, 'max': 40, 'label': 'Moderate Risk', 'color': Colors.lightGreen},
    {'min': 41, 'max': 60, 'label': 'Medium Risk', 'color': Colors.yellow},
    {'min': 61, 'max': 80, 'label': 'High Risk', 'color': Colors.orange},
    {'min': 81, 'max': 100, 'label': 'Severe Risk', 'color': Colors.red},
  ];

  @override
  void initState() {
    super.initState();

    // Generate random scores
    _generateRandomScores();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = Tween<double>(
      begin: 0,
      end: crimeScore / 100,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  void _generateRandomScores() {
    // Generate main crime score (0-100) with higher probability of 0
    // 30% chance of getting a 0 score
    if (_random.nextDouble() < 0.3) {
      crimeScore = 0;
    } else {
      crimeScore = _random.nextDouble() * 100;
    }

    // Generate random assessment factors
    violentOffenses = _generateRandomFactor();
    propertyCrimes = _generateRandomFactor();
    drugOffenses = _generateRandomFactor();
    recidivismRisk = _generateRandomFactor();
    rehabilitationProgress = _generateRandomFactor();

    // Generate random rehabilitation programs
    rehabPrograms = [
      _generateRandomRehabProgram('Anger Management Program'),
      _generateRandomRehabProgram('Substance Abuse Treatment'),
      _generateRandomRehabProgram('Vocational Training'),
      _generateRandomRehabProgram('Community Service'),
      _generateRandomRehabProgram('Counseling Sessions'),
    ];
  }
  Map<String, dynamic> _generateRandomFactor() {
    final percentage = _random.nextInt(101); // 0-100
    String level;

    if (percentage < 30) {
      level = 'Low';
    } else if (percentage < 70) {
      level = 'Medium';
    } else {
      level = 'High';
    }

    return {
      'level': level,
      'percentage': percentage,
    };
  }

  Map<String, dynamic> _generateRandomRehabProgram(String name) {
    final progress = _random.nextInt(101); // 0-100
    final isCompleted = progress == 100;

    return {
      'name': name,
      'status': isCompleted ? 'Completed' : 'In Progress',
      'progress': progress,
    };
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String getRiskLevel() {
    for (var level in riskLevels) {
      if (crimeScore >= level['min'] && crimeScore <= level['max']) {
        return level['label'];
      }
    }
    return 'Unknown';
  }

  Color getRiskColor() {
    for (var level in riskLevels) {
      if (crimeScore >= level['min'] && crimeScore <= level['max']) {
        return level['color'];
      }
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000435),
      appBar: AppBar(
        backgroundColor: const Color(0xFF000435),
        elevation: 0,
        title: const Text(
          'Crime Risk Assessment',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Refresh button to generate new random scores
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {
                _generateRandomScores();
                _animationController.reset();
                _animation = Tween<double>(
                  begin: 0,
                  end: crimeScore / 100,
                ).animate(CurvedAnimation(
                  parent: _animationController,
                  curve: Curves.easeOutCubic,
                ));
                _animationController.forward();
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Crime score meter
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 220,
                          width: double.infinity,
                          child: CustomPaint(
                            painter: CrimeScoreMeterPainter(
                              progress: _animation.value,
                              riskLevels: riskLevels,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          crimeScore.toInt().toString(),
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          getRiskLevel(),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: getRiskColor(),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 40),

                // Risk level legend
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Risk Levels',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: riskLevels.map((level) {
                          return Column(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: level['color'],
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${level['min']}-${level['max']}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Criminal history details
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Criminal History Assessment',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildFactorRow('Violent Offenses', violentOffenses['level'], violentOffenses['percentage']),
                      _buildFactorRow('Property Crimes', propertyCrimes['level'], propertyCrimes['percentage']),
                      _buildFactorRow('Drug-Related Offenses', drugOffenses['level'], drugOffenses['percentage']),
                      _buildFactorRow('Recidivism Risk', recidivismRisk['level'], recidivismRisk['percentage']),
                      _buildFactorRow('Rehabilitation Progress', rehabilitationProgress['level'], rehabilitationProgress['percentage']),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Recent incidents
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recent Incidents',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildIncidentItem(
                        'Assault and Battery',
                        _getRandomDate(),
                        'Violent',
                        Colors.red,
                      ),
                      _buildIncidentItem(
                        'Theft',
                        _getRandomDate(),
                        'Property',
                        Colors.orange,
                      ),
                      _buildIncidentItem(
                        'Possession of Controlled Substance',
                        _getRandomDate(),
                        'Drug',
                        Colors.yellow,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Rehabilitation progress
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Rehabilitation Progress',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ...rehabPrograms.map((program) =>
                          _buildRehabItem(program['name'], program['status'], program['progress'])
                      ).toList(),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Recommendations
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recommendations',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildRecommendationItem('Continue substance abuse treatment program'),
                      _buildRecommendationItem('Increase frequency of counseling sessions'),
                      _buildRecommendationItem('Complete vocational training for employment opportunities'),
                      _buildRecommendationItem('Regular check-ins with probation officer'),
                      _buildRecommendationItem('Participate in community reintegration program'),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getRandomDate() {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final month = months[_random.nextInt(months.length)];
    final day = _random.nextInt(28) + 1; // 1-28
    final year = 2023;

    return '$month $day, $year';
  }

  Widget _buildFactorRow(String title, String level, int percentage) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              Text(
                level,
                style: TextStyle(
                  color: _getLevelColor(level),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: Colors.grey.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(_getLevelColor(level)),
            minHeight: 5,
            borderRadius: BorderRadius.circular(2.5),
          ),
        ],
      ),
    );
  }
  Color _getLevelColor(String level) {
    switch (level) {
      case 'Low':
        return Colors.green;
      case 'Medium':
        return Colors.yellow;
      case 'High':
        return Colors.red;
      case 'Good':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Widget _buildIncidentItem(String incident, String date, String category, Color categoryColor) {
    // Generate a random case status
    final statuses = ['Pending', 'Sentenced', 'Dismissed', 'On Trial', 'Under Investigation'];
    final status = statuses[_random.nextInt(statuses.length)];

    // Get status color based on the status
    Color statusColor;
    switch (status) {
      case 'Pending':
        statusColor = Colors.orange;
        break;
      case 'Sentenced':
        statusColor = Colors.red;
        break;
      case 'Dismissed':
        statusColor = Colors.green;
        break;
      case 'On Trial':
        statusColor = Colors.purple;
        break;
      case 'Under Investigation':
        statusColor = Colors.blue;
        break;
      default:
        statusColor = Colors.grey;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: categoryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              category,
              style: TextStyle(
                color: categoryColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  incident,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      date,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRehabItem(String program, String status, int progress) {
    final isCompleted = status == 'Completed';

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                program,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isCompleted ? Colors.green.withOpacity(0.2) : Colors.blue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: isCompleted ? Colors.green : Colors.blue,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress / 100,
            backgroundColor: Colors.grey.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(isCompleted ? Colors.green : Colors.blue),
            minHeight: 5,
            borderRadius: BorderRadius.circular(2.5),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationItem(String recommendation) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.arrow_right,
            color: Color(0xFF00BFAE),
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              recommendation,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for the crime score meter with improved arrow design
class CrimeScoreMeterPainter extends CustomPainter {
  final double progress;
  final List<Map<String, dynamic>> riskLevels;

  CrimeScoreMeterPainter({
    required this.progress,
    required this.riskLevels,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 30);
    final radius = math.min(size.width, size.height - 60) * 0.85;

    // Draw background arc
    final bgPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      bgPaint,
    );

    // Draw colored segments
    for (int i = 0; i < riskLevels.length; i++) {
      final level = riskLevels[i];
      final startAngle = math.pi + (math.pi * level['min'] / 100);
      final sweepAngle = math.pi * (level['max'] - level['min']) / 100;

      final segmentPaint = Paint()
        ..color = level['color']
        ..style = PaintingStyle.stroke
        ..strokeWidth = 25
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        segmentPaint,
      );
    }

    // Calculate needle angle
    final needleAngle = math.pi + (math.pi * progress);

    // Draw a more dynamic arrow
    final arrowLength = radius + 15;
    final arrowEnd = Offset(
      center.dx + arrowLength * math.cos(needleAngle),
      center.dy + arrowLength * math.sin(needleAngle),
    );

    // Draw arrow shaft
    final arrowShaftPaint = Paint()
      ..color = const Color(0xFF00BFAE)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(center, arrowEnd, arrowShaftPaint);

    // Draw arrow head
    final arrowHeadSize = 12.0;
    final arrowHeadAngle1 = needleAngle + math.pi * 0.9;
    final arrowHeadAngle2 = needleAngle + math.pi * 1.1;

    final arrowHead1 = Offset(
      arrowEnd.dx + arrowHeadSize * math.cos(arrowHeadAngle1),
      arrowEnd.dy + arrowHeadSize * math.sin(arrowHeadAngle1),
    );

    final arrowHead2 = Offset(
      arrowEnd.dx + arrowHeadSize * math.cos(arrowHeadAngle2),
      arrowEnd.dy + arrowHeadSize * math.sin(arrowHeadAngle2),
    );

    final arrowHeadPaint = Paint()
      ..color = const Color(0xFF00BFAE)
      ..style = PaintingStyle.fill;

    final arrowHeadPath = Path()
      ..moveTo(arrowEnd.dx, arrowEnd.dy)
      ..lineTo(arrowHead1.dx, arrowHead1.dy)
      ..lineTo(arrowHead2.dx, arrowHead2.dy)
      ..close();

    canvas.drawPath(arrowHeadPath, arrowHeadPaint);

    // Draw the pivot point with a gradient effect
    final pivotPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF00BFAE),
          const Color(0xFF00BFAE).withOpacity(0.7),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: 15));

    canvas.drawCircle(center, 15, pivotPaint);

    // Add a highlight to the pivot
    final pivotHighlightPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(center.dx - 5, center.dy - 5),
      5,
      pivotHighlightPaint,
    );

    // Add tick marks
    final tickPaint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (int i = 0; i <= 10; i++) {
      final tickAngle = math.pi + (math.pi * i / 10);
      final tickStart = Offset(
        center.dx + (radius - 15) * math.cos(tickAngle),
        center.dy + (radius - 15) * math.sin(tickAngle),
      );
      final tickEnd = Offset(
        center.dx + (radius + 15) * math.cos(tickAngle),
        center.dy + (radius + 15) * math.sin(tickAngle),
      );

      canvas.drawLine(tickStart, tickEnd, tickPaint);

      // Add labels for major ticks
      if (i % 2 == 0) {
        final labelValue = i * 10;
        final labelOffset = Offset(
          center.dx + (radius - 40) * math.cos(tickAngle),
          center.dy + (radius - 40) * math.sin(tickAngle),
        );

        final textPainter = TextPainter(
          text: TextSpan(
            text: labelValue.toString(),
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
          ),
          textDirection: TextDirection.ltr,
        );

        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
            labelOffset.dx - textPainter.width / 2,
            labelOffset.dy - textPainter.height / 2,
          ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}