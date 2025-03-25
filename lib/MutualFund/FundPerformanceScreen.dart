import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

class InvestmentScreen extends StatefulWidget {
  const InvestmentScreen({super.key});

  @override
  State<InvestmentScreen> createState() => _InvestmentScreenState();
}

class _InvestmentScreenState extends State<InvestmentScreen>
    with TickerProviderStateMixin {
  late AnimationController _chartAnimationController;
  late Animation<double> _chartAnimation;
  double _sliderValue = 1;
  bool _showDetails = false;

  @override
  void initState() {
    super.initState();
    _chartAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

    _chartAnimation = CurvedAnimation(
      parent: _chartAnimationController,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _chartAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              // Share functionality
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(1.0),
        child: ListView(
          children: [
            const Text(
              'Motilal Oswal Midcap\nDirect Growth',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: const [
                Text(
                  'Nav ₹ 104.2',
                  style: TextStyle(color: Colors.grey, fontSize: 14)),
                SizedBox(width: 16),
                AnimatedValueText(
                  value: -4.7,
                  unit: '₹',
                  suffix: '1D',
                ),
              ],
            ),
            Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ComparisonChip(
                        icon: Icons.show_chart,
                        iconColor: Colors.blue,
                        label: 'Your Investments',
                        value: -19.75,
                      ),
                      const SizedBox(width: 16),
                      ComparisonChip(
                        icon: Icons.show_chart,
                        iconColor: Colors.orange,
                        label: 'Nifty Midcap 150',
                        value: -12.97,
                      ),
                    ],
                  ),
            const SizedBox(height: 24),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFF1E1E1E),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      InvestmentStat(label: 'Invested', value: '₹1.5k'),
                      InvestmentStat(label: 'Current Value', value: '₹1.28k'),
                      InvestmentStat(
                        label: 'Total Gain',
                        value: '₹-220.16',
                        valueColor: Colors.red,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 150,
                    child: AnimatedLineChart(animation: _chartAnimation),
                  ),
                  const SizedBox(height: 10),
                  
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: ['1M', '3M', '6M', '1Y', 'MAX']
                          .map((e) => Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: TimePeriodChip(
                                  period: e,
                                  isSelected: e == '1Y',
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                setState(() {
                  _showDetails = !_showDetails;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: const Color(0xFF1E1E1E),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'If you invested ₹ 1 L',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        RotationTransition(
                          turns: _showDetails
                              ? const AlwaysStoppedAnimation(0.5)
                              : const AlwaysStoppedAnimation(0.0),
                          child: const Icon(
                            Icons.expand_more,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      child: SizedBox(
                        height: _showDetails ? null : 0,
                        child: Column(
                          children: [
                            const SizedBox(height: 12),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: Colors.blue,
                                inactiveTrackColor: Colors.grey[800],
                                thumbColor: Colors.blue,
                                overlayColor: Colors.blue.withOpacity(0.2),
                                trackHeight: 4,
                              ),
                              child: Slider(
                                value: _sliderValue,
                                onChanged: (val) {
                                  setState(() {
                                    _sliderValue = val;
                                  });
                                },
                                min: 1,
                                max: 10,
                                divisions: 9,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "This Fund's past returns",
                              style: TextStyle(color: Colors.white, fontSize: 14),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: const [
                                BarChartColumn(
                                    title: 'Saving A/C',
                                    amount: '₹1.19L',
                                    height: 60,
                                    color: Colors.grey),
                                BarChartColumn(
                                    title: 'Category Avg.',
                                    amount: '₹3.63L',
                                    height: 100,
                                    color: Colors.blue),
                                BarChartColumn(
                                    title: 'Direct Plan',
                                    amount: '₹4.55L',
                                    height: 140,
                                    color: Colors.green),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF121212),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, -2),
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Sell action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[800],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Sell'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  // Invest more action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Invest More'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedLineChart extends StatelessWidget {
  final Animation<double> animation;

  const AnimatedLineChart({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return CustomPaint(
          painter: LineChartPainter(animation.value),
        );
      },
    );
  }
}

class LineChartPainter extends CustomPainter {
  final double animationValue;

  LineChartPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final points = [
      Offset(0, size.height * 0.8),
      Offset(size.width * 0.2, size.height * 0.6),
      Offset(size.width * 0.4, size.height * 0.7),
      Offset(size.width * 0.6, size.height * 0.4),
      Offset(size.width * 0.8, size.height * 0.5),
      Offset(size.width, size.height * 0.3),
    ];

    final animatedPoints = points.map((point) {
      return Offset(
        point.dx,
        size.height - (size.height - point.dy) * animationValue,
      );
    }).toList();

    final path = Path();
    path.moveTo(animatedPoints[0].dx, animatedPoints[0].dy);

    for (int i = 1; i < animatedPoints.length; i++) {
      final p1 = animatedPoints[i - 1];
      final p2 = animatedPoints[i];
      path.cubicTo(
        p1.dx + (p2.dx - p1.dx) / 3,
        p1.dy,
        p1.dx + (p2.dx - p1.dx) * 2 / 3,
        p2.dy,
        p2.dx,
        p2.dy,
      );
    }

    canvas.drawPath(path, paint);

    // Draw dots at each point
    for (final point in animatedPoints) {
      canvas.drawCircle(
        point,
        3,
        Paint()..color = Colors.blue,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class AnimatedValueText extends StatefulWidget {
  final double value;
  final String unit;
  final String suffix;

  const AnimatedValueText({
    super.key,
    required this.value,
    this.unit = '',
    this.suffix = '',
  });

  @override
  State<AnimatedValueText> createState() => _AnimatedValueTextState();
}

class _AnimatedValueTextState extends State<AnimatedValueText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final animatedValue = widget.value * _animation.value;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${widget.unit}${animatedValue.toStringAsFixed(1)}',
              style: TextStyle(
                color: widget.value < 0 ? Colors.red : Colors.green,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              widget.value < 0 ? Icons.arrow_downward : Icons.arrow_upward,
              color: widget.value < 0 ? Colors.red : Colors.green,
              size: 14,
            ),
            if (widget.suffix.isNotEmpty) ...[
              const SizedBox(width: 4),
              Text(
                widget.suffix,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ],
        );
      },
    );
  }
}

class InvestmentStat extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const InvestmentStat({
    super.key,
    required this.label,
    required this.value,
    this.valueColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
              color: valueColor, fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }
}

class ComparisonChip extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final double value;

  const ComparisonChip({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(width: 4),
          Text(
            '$label ${value.toStringAsFixed(2)}%',
            style: TextStyle(
              color: value < 0 ? Colors.red : Colors.green,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class TimePeriodChip extends StatelessWidget {
  final String period;
  final bool isSelected;

  const TimePeriodChip({
    super.key,
    required this.period,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        period,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey,
          fontSize: 12,
        ),
      ),
    );
  }
}

class BarChartColumn extends StatelessWidget {
  final String title;
  final String amount;
  final double height;
  final Color color;

  const BarChartColumn({
    super.key,
    required this.title,
    required this.amount,
    required this.height,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(amount, style: const TextStyle(color: Colors.white, fontSize: 12)),
        const SizedBox(height: 4),
        TweenAnimationBuilder(
          duration: const Duration(milliseconds: 800),
          tween: Tween<double>(begin: 0, end: height),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Container(
              width: 30,
              height: value,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 10)),
      ],
    );
  }
}