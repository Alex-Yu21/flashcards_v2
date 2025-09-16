import 'dart:math' as math;

import 'package:flutter/material.dart';

// Константы дефолтных значений (плейсхолдер до Riverpod)
const int kGoalPerDay = 30;
const List<int> kDefaultLast7 = [32, 50, 24, 41, 50, 12, 20];
const List<String> kDefaultWeek = [
  'Mon',
  'Tue',
  'Wed',
  'Thu',
  'Fri',
  'Sat',
  'Sun',
];

const double kChartHeight = 100;
const double kPointRadius = 4;
const double kPadL = 8, kPadR = 8, kPadT = 8, kPadB = 18;
const double kStrokeWidth = 2;
const double kAxisStrokeWidth = 1;
const double kRingStrokeWidth = 2;
const double kCaptionAlpha = 0.6;
const double kAxisAlpha = 0.12;
const double kGuideAlpha = 0.18;
const double kFillAlpha = 0.10;
const double kWeekFontSize = 10;
const bool kUseSharpLine = false;

const String kStreakPrefix = 'Streak: ';
const String kThisWeek = 'This week';
const String kDaySingular = 'day';
const String kDayPlural = 'days';

// Модель данных, которую потом отдаст провайдер
class StreakData {
  final int goal;
  final List<int> last7;
  final List<String> week;
  const StreakData({
    required this.goal,
    required this.last7,
    required this.week,
  });
}

// Дефолтная заглушка
const StreakData kDefaultStreakData = StreakData(
  goal: kGoalPerDay,
  last7: kDefaultLast7,
  week: kDefaultWeek,
);

// UI-виджет. Готов к подстановке данных из Riverpod через параметр `data`.
class StreakWidget extends StatelessWidget {
  const StreakWidget({
    super.key,
    this.data = kDefaultStreakData, //  ref.watch(...)
    this.useSharpLine = kUseSharpLine, // можно тоже читать из настроек
  });

  final StreakData data;
  final bool useSharpLine;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final tt = theme.textTheme;

    if (data.last7.isEmpty) return const SizedBox.shrink();

    final values = data.last7.map((e) => e.toDouble()).toList();
    final goal = data.goal.toDouble();
    final week = data.week;
    final todayIdx = values.length - 1;

    var streak = 0;
    for (var i = todayIdx; i >= 0; i--) {
      if (values[i] >= goal) {
        streak++;
      } else {
        break;
      }
    }

    final caption = tt.labelMedium?.copyWith(
      color: cs.onSurface.withValues(alpha: kCaptionAlpha),
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                '$kStreakPrefix$streak ${streak == 1 ? kDaySingular : kDayPlural}',
                style: caption,
              ),
              const Spacer(),
              Text(kThisWeek, style: caption),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: kChartHeight,
            width: double.infinity,
            child: CustomPaint(
              painter: _LineChartPainter(
                values: values,
                goal: goal,
                lineColor: cs.primary,
                fillColor: cs.primary.withValues(alpha: kFillAlpha),
                pointColor: cs.primary,
                axisColor: cs.onSurface.withValues(alpha: kAxisAlpha),
                guideColor: cs.primary.withValues(alpha: kGuideAlpha),
                pointRadius: kPointRadius,
                padL: kPadL,
                padR: kPadR,
                padT: kPadT,
                padB: kPadB,
                strokeWidth: kStrokeWidth,
                axisStrokeWidth: kAxisStrokeWidth,
                ringStrokeWidth: kRingStrokeWidth,
                sharp: useSharpLine,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: List.generate(week.length, (i) {
              final isToday = i == todayIdx;
              return Expanded(
                child: Text(
                  week[i],
                  textAlign: TextAlign.center,
                  style: tt.bodySmall?.copyWith(
                    fontSize: kWeekFontSize,
                    fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
                    color: cs.onSurface.withValues(alpha: isToday ? 0.9 : 0.6),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ===== Painter
class _LineChartPainter extends CustomPainter {
  _LineChartPainter({
    required this.values,
    required this.goal,
    required this.lineColor,
    required this.fillColor,
    required this.pointColor,
    required this.axisColor,
    required this.guideColor,
    required this.pointRadius,
    required this.padL,
    required this.padR,
    required this.padT,
    required this.padB,
    required this.strokeWidth,
    required this.axisStrokeWidth,
    required this.ringStrokeWidth,
    required this.sharp,
  });

  final List<double> values;
  final double goal;
  final Color lineColor, fillColor, pointColor, axisColor, guideColor;
  final double pointRadius;
  final double padL, padR, padT, padB;
  final double strokeWidth, axisStrokeWidth, ringStrokeWidth;
  final bool sharp;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;

    final w = size.width - padL - padR;
    final h = size.height - padT - padB;
    final maxY = math.max(values.reduce(math.max), goal);
    final dx = w / (values.length - 1);

    final points = List<Offset>.generate(values.length, (i) {
      final x = padL + dx * i;
      final yNorm = (values[i] / (maxY == 0 ? 1 : maxY)).clamp(0.0, 1.0);
      final y = padT + (1 - yNorm) * h;
      return Offset(x, y);
    });

    final axisPaint = Paint()
      ..color = axisColor
      ..strokeWidth = axisStrokeWidth;
    canvas.drawLine(
      Offset(padL, padT + h),
      Offset(padL + w, padT + h),
      axisPaint,
    );

    final gy = padT + (1 - (goal / (maxY == 0 ? 1 : maxY))) * h;
    final goalPaint = Paint()
      ..color = guideColor
      ..strokeWidth = axisStrokeWidth;
    canvas.drawLine(Offset(padL, gy), Offset(padL + w, gy), goalPaint);

    final path = sharp
        ? _polylinePath(points)
        : _catmullRomPath(points, tension: 1.0);

    final fillPath = Path()
      ..addPath(path, Offset.zero)
      ..lineTo(points.last.dx, padT + h)
      ..lineTo(points.first.dx, padT + h)
      ..close();
    canvas.drawPath(fillPath, Paint()..color = fillColor);

    final strokePaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeJoin = sharp ? StrokeJoin.miter : StrokeJoin.round
      ..strokeCap = sharp ? StrokeCap.butt : StrokeCap.round;
    canvas.drawPath(path, strokePaint);

    final dot = Paint()..color = pointColor;
    final ring = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = ringStrokeWidth;
    for (final p in points) {
      canvas.drawCircle(p, pointRadius, dot);
      canvas.drawCircle(p, pointRadius, ring);
    }
  }

  Path _polylinePath(List<Offset> pts) {
    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (var i = 1; i < pts.length;) {
      path.lineTo(pts[i].dx, pts[i].dy);
    }
    return path;
  }

  Path _catmullRomPath(List<Offset> pts, {double tension = 1.0}) {
    final path = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (var i = 0; i < pts.length - 1; i++) {
      final p0 = i == 0 ? pts[i] : pts[i - 1];
      final p1 = pts[i];
      final p2 = pts[i + 1];
      final p3 = (i + 2 < pts.length) ? pts[i + 2] : pts[i + 1];

      final c1 = Offset(
        p1.dx + (p2.dx - p0.dx) * (tension / 6),
        p1.dy + (p2.dy - p0.dy) * (tension / 6),
      );
      final c2 = Offset(
        p2.dx - (p3.dx - p1.dx) * (tension / 6),
        p2.dy - (p3.dy - p1.dy) * (tension / 6),
      );
      path.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, p2.dx, p2.dy);
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter old) =>
      old.values != values ||
      old.goal != goal ||
      old.lineColor != lineColor ||
      old.fillColor != fillColor ||
      old.pointColor != pointColor ||
      old.axisColor != axisColor ||
      old.guideColor != guideColor ||
      old.pointRadius != pointRadius ||
      old.padL != padL ||
      old.padR != padR ||
      old.padT != padT ||
      old.padB != padB ||
      old.strokeWidth != strokeWidth ||
      old.axisStrokeWidth != axisStrokeWidth ||
      old.ringStrokeWidth != ringStrokeWidth ||
      old.sharp != sharp;
}
